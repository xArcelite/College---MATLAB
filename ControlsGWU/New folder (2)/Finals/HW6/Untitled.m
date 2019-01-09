close all;
clear all;

l1 = 10;
l2 = 10;
l3 = 0;
t1 = 30;
t2 = 45;
t3 = 0;

syms xv yv zv
x = l1*cosd(t1) + l2*cosd(t1+t2)+l3*cosd(t1+t2+t3);
y = l1*sind(t1) + l2*sind(t1+t2)+l3*sind(t1+t2+t3);
z = t1+t2+t3;
M = [l1*cosd(t1) l2*cosd(t1+t2) l3*cosd(t1+t2+t3), 
    l1*sind(t1) l2*sind(t1+t2) l3*sind(t1+t2+t3), 
    1 1 1];
diff(M);