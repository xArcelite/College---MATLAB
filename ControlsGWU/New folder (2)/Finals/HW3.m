clear all;

t1 = 45;
t2 = 30;
t3 = -30;
l1 = 10;
l2 = 10;
l3 = 0;


T01 = [cosd(t1) sind(t1) 0 0; ...
    cosd(0)*sind(t1) cosd(0)*cosd(t1) -sin(0) -0*sin(0);
    sind(0)*sind(t1) sind(0)*cosd(t1) cos(0) 0*cos(0);
    0 0 0 1];

T12 = [cosd(t2) sind(t2) 0 10; ...
    cosd(t1)*sind(t2) cosd(t1)*cosd(t2) -sin(t1) -0*sin(t1);
    sind(t1)*sind(t2) sind(t1)*cosd(t2) cos(t1) 0*cos(t1);
    0 0 0 1];

T23 = [cosd(t3) sind(t3) 0 10; ...
    cosd(t1)*sind(t2) cosd(t1)*cosd(t2) -sin(t1) -0*sin(t1);
    sind(t1)*sind(t2) sind(t1)*cosd(t2) cos(t1) 0*cos(t1);
    0 0 0 1];

T03 = T01*T12*T23;