clc;
clearvars;

startT = 0;
endT = 30;
stepT = 0.04;
n0 = (endT - startT)/stepT + 1;

% noise_imu = randn(n0,3);  %标准正态分布σ=1
% noise_imu = 0.1 * randn(n0,3);  %σ=0.1
noise_imu = 0.01 * randn(n0,3);  %σ=0.01

noise_uwb = 0.001 * randn(n0,1);

time = zeros(1,n0);
gtd = zeros(n0,3);
vel = zeros(n0,3);
imu0 = zeros(n0,3);
uwb0 = zeros(1,n0);
imu = zeros(n0,3);
uwb = zeros(1,n0);
gtd_p = zeros(n0,3);
vel_p = zeros(n0,3);

for i = 1:n0
    t = 0.04 * (i-1);
    time(i) = t;
    
    gtd(i,1) = sin(0.08*t);
    gtd(i,2) = cos(0.12*t);
    gtd(i,3) = sin(0.1*t + pi/4);
    uwb0(1,i) = sqrt(gtd(i,1)^2 + gtd(i,2)^2 + gtd(i,3)^2);
    vel(i,1) = 0.08 * cos(0.08*t);
    vel(i,2) = - 0.12 * sin(0.12*t);
    vel(i,3) = 0.1 * cos(0.1*t + pi/4);
    imu0(i,1) = - 0.0064 * sin(0.08*t);
    imu0(i,2) = - 0.0144 * cos(0.12*t);
    imu0(i,3) = - 0.01 * sin(0.1*t + pi/4);
    
    imu(i,1) = imu0(i,1) + noise_imu(i,1);
    imu(i,2) = imu0(i,2) + noise_imu(i,2);
    imu(i,3) = imu0(i,3) + noise_imu(i,3);
    
    uwb(1,i) = uwb0(1,i) + noise_uwb(i,1);
end

gtd_p(1,1) = 0;
gtd_p(1,2) = 1;
gtd_p(1,3) = sin(pi/4);
vel_p(1,1) = 0.08;
vel_p(1,2) = 0;
vel_p(1,3) = 0.1 * cos(pi/4);

for i = 2:n0
    vel_p(i,1) = trapz(imu(1:i,1)) * stepT + vel_p(1,1);
    vel_p(i,2) = trapz(imu(1:i,2)) * stepT + vel_p(1,2);
    vel_p(i,3) = trapz(imu(1:i,3)) * stepT + vel_p(1,3);
end

for i = 2:n0
    gtd_p(i,1) = trapz(vel_p(1:i,1)) * stepT + gtd_p(1,1);
    gtd_p(i,2) = trapz(vel_p(1:i,2)) * stepT + gtd_p(1,2);
    gtd_p(i,3) = trapz(vel_p(1:i,3)) * stepT + gtd_p(1,3);
end

plot3(gtd(:,1),gtd(:,2),gtd(:,3),gtd_p(:,1),gtd_p(:,2),gtd_p(:,3));
legend('VICON','prediction');
% plot(time(:),uwb0(:),time(:),uwb(:));

fname = 'trace2';
save(fname);
