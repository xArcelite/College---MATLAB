function [f] = inverseEqn2(theta1) 
x = 9.2;
y = 13.2;
a1 = 10;
a2 = 10;
f = (a1*sin(theta1)+a2*sin(acos((x-a1*cos(theta1))/a2))- y);
