clc;
clearvars;
data = load('trace2-Jv3.mat');
x = data.time;
y = data.gtd;
z = data.xt - data.gtd;
e = data.xt;

% Position
% plot(x(:),y(1,:),'r',x(:),y(2,:),'m',x(:),y(3,:),'b','LineWidth',1.5);
% axis([0 15 -2 2]);
% set(gca,'FontSize',12,'Fontname', 'Times New Roman');
% xlabel('Time (s)','FontName','Times New Roman','FontSize',16);
% ylabel('Position (m)','FontName','Times New Roman','FontSize',16);
% title('Trace1 - Jv3','FontName','Times New Roman','FontSize',16);
% hold on;
% plot(x(:),e(1,:),'--r',x(:),e(2,:),'--m',x(:),e(3,:),'--b','LineWidth',1.5);
% legend('$\hat{x}$','$\hat{y}$','$\hat{z}$','$\hat{x}_g$','$\hat{y}_g$','$\hat{z}_g$','Interpreter','LaTex','FontName','Times New Roman','FontSize',12,'NumColumns',2);
% hold off;

% %Error
% plot(x(:),z(1,:),'r',x(:),z(2,:),'m',x(:),z(3,:),'b','LineWidth',1.5);
% axis([7 24.2 -1 1.5]);
% set(gca,'FontSize',12,'Fontname', 'Times New Roman');
% xlabel('Time (s)','FontName','Times New Roman','FontSize',16);
% ylabel('Error (m)','FontName','Times New Roman','FontSize',16);
% title('Bag1 - Jv1','FontName','Times New Roman','FontSize',16);
% legend('$\hat{e}_x$','$\hat{e}_y$','$\hat{e}_z$','Interpreter','LaTex','FontName','Times New Roman','FontSize',12);

% %Velocity
% plot(x(:),y(4,:),'r',x(:),y(5,:),'m',x(:),y(6,:),'b','LineWidth',1.5);
% axis([7 24.2 -2.5 3]);
% set(gca,'FontSize',12,'Fontname', 'Times New Roman');
% xlabel('Time (s)','FontName','Times New Roman','FontSize',16);
% ylabel('Velocity (m/s)','FontName','Times New Roman','FontSize',16);
% title('Bag1 - Jv1','FontName','Times New Roman','FontSize',16);
% hold on;
% plot(x(:),e(4,:),'--r',x(:),e(5,:),'--m',x(:),e(6,:),'--b','LineWidth',1.5);
% legend('$\hat{v}_x$','$\hat{v}_y$','$\hat{v}_z$','$\hat{v}_{xg}$','$\hat{v}_{yg}$','$\hat{v}_{zg}$','Interpreter','LaTex','FontName','Times New Roman','FontSize',12,'NumColumns',2);
% hold off;

%Trace
plot3(y(1,:),y(2,:),y(3,:),'b',e(1,:),e(2,:),e(3,:),'r','LineWidth',1);
legend('VICON','Estimation','Prediction','FontName','Times New Roman','FontSize',12);
xlabel('X (m)','FontName','Times New Roman','FontSize',16);
ylabel('Y (m)','FontName','Times New Roman','FontSize',16);
zlabel('Z (m)','FontName','Times New Roman','FontSize',16);
title('Bag1 - Jv3','FontName','Times New Roman','FontSize',16);


