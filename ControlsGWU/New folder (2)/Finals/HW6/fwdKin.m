function [pos] = fwdKin(a1,a2,theta1,theta2)
 % Define End Effector Position Using Forward Kinematics Solution
 x = a1*cos(theta1) + a2*cos(theta1+theta2);
 y = a1*sin(theta1) + a2*sin(theta1+theta2);

 pos = [x; y];