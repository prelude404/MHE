%% load data
clc;
clearvars -except gamma;
% data = load('data/bag1.mat');
% data = load('data/bag2.mat');
% data = load('data/bag3.mat');
% data = load('data/bag4.mat');
% data = load('data/bag5.mat');
data = load('trace2.mat');

gamma = [10, 0.5, 0.2, 0.1, 100];  % ¦Ã1,2,3,3',4
dt = 0.04;
% starti = 175;endi = 605;   %bag1
% starti = 175;endi = 735;   %bag2
% starti = 115;endi = 740;   %bag3
% starti = 210;endi = 1140;  %bag4
% starti =  70;endi = 1030;  %bag5
starti = 1;endi = data.n0;  %trace
lopt = 15;

%% store data
time = data.time;       % time
gtd = data.gtd';        % position from vicon
gtd(4:6,:) = data.vel'; % velocity from vicon
uwb = data.uwb;         % uwb distance
imu = data.imu';        % imu data

% % remove the bias of VICON
% gtd(1,:) = gtd(1,:) + 3.93; 
% gtd(2,:) = gtd(2,:) - 0.18;
% gtd(3,:) = gtd(3,:) - 0.47;

uwb = uwb(starti:endi);
imu = imu(:,starti:endi);
gtd = gtd(:,starti:endi);
time = time(starti:endi);

% acceleration
lav = 200;
% imu(3,:) = imu(3,:) - 9.8;
mu(1:lav) = imu(3,1:lav);
for i = lav+1:length(imu(3,:))
    mu(i) = imu(3,i) - mean(imu(3,i-lav:i));
end
imu(3,:) = mu;

%% S-G filt
order = 4;
framelen = 31;

imu(1,:) = sgolayfilt(imu(1,:),order,framelen);
imu(2,:) = sgolayfilt(imu(2,:),order,framelen);
imu(3,:) = sgolayfilt(imu(3,:),order,framelen);

y = sgolayfilt(uwb,order,framelen);
uwb = y;

vy = [0,0];
for i = 2:length(uwb)
    vy(i) = (y(i)-y(i-1))/(dt);
end
vy = sgolayfilt(vy,order,framelen);

%% initialize
delta = 20;
xt = gtd(:,1:lopt+delta);
xt_imu = gtd(:,1:lopt+delta);
xi = xt(:,1);
opt_range = endi - starti + 1;
X = xi;

%% MHE
for i = lopt+delta:opt_range
%%
    yt = sgolayfilt(uwb(1:i),order,framelen);
    y(i) = yt(end);
    vy(i) = (y(i)-y(i-1))/(dt);
    vy = sgolayfilt(vy,order,framelen);
    
%%
    xi = xt(:,i-lopt+1);  % estimated initial value
    disp(['STEP ',num2str(i)]);
    
    % used for MHE, 15 points
    MHE_imu = imu(:,i-lopt+1:i);
    MHE_uwb = y(i-lopt+1:i);
    MHE_v = vy(i-lopt+1:i);
    
    x0 = prediction(xi, MHE_imu, dt);  % use prediction as initial guess
    x0(:,1:lopt-1) = xt(:, i-lopt+1:i-1);
    x_t = prediction(xt_imu(:,i-lopt), MHE_imu, dt);  % always use imu to guess
    xt_imu(:,i) = x_t(:,end);
    
%%
    options = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',200000);
    % X = fmincon(@(x)objmulti_1(x, xi, MHE_imu, MHE_uwb, MHE_v, gamma), x0,[],[],[],[],[],[],[],options);
    % X = fmincon(@(x)objmulti_2(x, xi, MHE_imu, MHE_uwb, MHE_v, gamma), x0,[],[],[],[],[],[],[],options);
    X = fmincon(@(x)objmulti_3(x, xi, MHE_imu, MHE_uwb, MHE_v, gamma), x0,[],[],[],[],[],[],[],options);
    % X = fmincon(@(x)objmulti_4(x, xi, MHE_imu, MHE_uwb, MHE_v, gamma), x0,[],[],[],[],[],[],[],options);
    % X = fmincon(@(x)objmulti_5(x, xi, MHE_imu, MHE_uwb, MHE_v, gamma), x0,[],[],[],[],[],[],[],options);
    % X = fmincon(@(x)objmulti_6(x, xi, MHE_imu, MHE_uwb, MHE_v, gamma), x0,[],[],[],[],[],[],[],options);
    % X = fmincon(@(x)objmulti_7(x, xi, MHE_imu, MHE_uwb, MHE_v, gamma), x0,[],[],[],[],[],[],[],options);
    
    xt(:,i) = X(:,end);   
    
%%
    xt(1,:) = sgolayfilt(xt(1,:), order, framelen);
    xt(2,:) = sgolayfilt(xt(2,:), order, framelen);
    xt(3,:) = sgolayfilt(xt(3,:), order, framelen);
    xt(4,:) = sgolayfilt(xt(4,:), order, framelen);
    xt(5,:) = sgolayfilt(xt(5,:), order, framelen);
    xt(6,:) = sgolayfilt(xt(6,:), order, framelen);
end
error = evalerror(xt,gtd);

%% save file
fname = ['trace2','-','Jv3',];
save(fname);
return


