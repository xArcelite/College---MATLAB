function [f] = inverseEqn1(theta1)
 % End Effector Position
 x = 8.66;
 % Link Length
 a = 10;

 % Residual
 f = x - a*cos(theta1);