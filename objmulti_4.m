function f = objmulti_4(x, x0, u, y, v, gamma)
obj = 0;
% gamma = [10, 0.5, 0.2, 0.1, 100];  ¦Ã1,¦Ã2,¦Ã3,¦Ã3',¦Ã4
dt = 0.04;

A = [1, 0, 0, dt, 0, 0;
     0, 1, 0, 0, dt, 0;
     0, 0, 1, 0, 0, dt;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1;];
 
B = [0.5*dt^2, 0, 0;
     0, 0.5*dt^2, 0;
     0, 0, 0.5*dt^2;
     dt, 0,  0;
     0,  dt, 0;
     0,  0, dt;];
 
 xt(:,1) = x0;
 
 for i = 1:length(u)
% 1st
    xt(:,i+1) = A * x(:,i) + B * u(:,i);
    t_obj = (xt(:,i) - x(:,i))' * (xt(:,i) - x(:,i));  % temp save
    obj = obj + gamma(1) * t_obj;
 
% 2nd
    lx = sqrt(x(1:3,i)' * x(1:3,i));
    t_obj = (lx - y(i))^2;
    obj = obj + gamma(2) * t_obj;
% 3rd
    vt = v(i);
    ve = (x(1:3,i)'*x(4:6,i))/norm(x(1:3,i));
    t_obj = (vt - ve)^2;
    obj = obj + gamma(3) * t_obj;
 end
% 4th
t_obj = (x(:,1)- x0(:,1))' * (x(:,1) - x0(:,1));
obj = obj + gamma(5) * t_obj;

f = obj;  %function with regard to x