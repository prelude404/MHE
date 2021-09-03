function f = objmulti_7(x, x0, u, y, v, gamma)
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

% get d and dd
d(:,1) = 0.5 * u(:,1) * (dt^2);
vd(:,1) = u(:,1) * dt;
dd(:,1) = d(:,1)/dt;
for i = 2:length(u)
    d(:,i) = d(:,i-1) + dt * vd(:,i-1) + 0.5 * (dt^2) * u(:,i);
    vd(:,i) = vd(:,i-1) + dt * u(:,i);
    dd(:,i) = (d(:,i)-d(:,i-1))/dt;
end

% get dx
dx(:,1) = (x(1:3,1)-x0(1:3,1))/dt;
for i = 2:length(u)
    dx(:,i) = (x(1:3,i)-x(1:3,i-1))/dt;
end

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
    t_obj = y(i) * v(i) - d(:,i)' * dx(:,i);
    obj = obj + gamma(3) * t_obj;

% 4th
    t_obj = d(:,i)' * x(1:3,i) - d(:,i)' * dd(:,i) + x0(1:3,1)' * x0(4:6,1) + (norm(x0(4:6,1)))^2 * dt * i;
    obj = obj - gamma(4) * (t_obj^2);

 end
% 5th
t_obj = (x(:,1)- x0(:,1))' * (x(:,1) - x0(:,1));
obj = obj + gamma(5) * t_obj;

f = obj;  %function with regard to x