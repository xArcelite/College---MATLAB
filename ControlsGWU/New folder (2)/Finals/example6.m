%Changing Stiffness/damping/etc.

%% Define system
k= 0.1;
m = 1;
f = 10;
F = [0, 1; -k/m 0];
G = [0; 1/m];
Hx = [1, 0; 0, 1];
Hu = [0; 0];

%State Space System

sys = ss(F,G,Hx,Hu);

%% Define Input Vectors
t = [0:1:100]';
u = 10*ones(size(t));


lsim(sys,u,t)