clear all
close all

d = [0; 0; 0];
dx = [d(1)];
dy = [d(2)];
f = 0:0.002:0.81;
theta = 0.0;

dxr = 1.234;
dyr = 2;
dthetar = 0.1;

for f = 0:0.002:(10)

Tr = [cos(theta) sin(theta) 0;
    -sin(theta) cos(theta) 0;
    0 0 1];
matrix = [dxr; dyr; dthetar];

Tf = Tr*matrix;
d = d + Tf*0.002;
theta = d(3);
dx = [dx, d(1)];
dy = [dy, d(2)];
plot(dx,dy);
end