%%Part 2

%Use one of the numerical techniques shown in class (root finding or optimization) to find
%the solution of the equation – given x, y. Basically create another MATLAB function to
%compute the angles, when end effector position is given.

close all;
clear all;

theta1_init = 0.5;
fun1 = @inverseEqn1;
fun2 = @inverseEqn2;

zRoot1 = fzero(fun1,theta1_init);
zRoot2 = fzero(fun2,theta1_init);
zOpt1 = fminunc(fun2,theta1_init);
%This is the solution, correct?

zOpt2 = fmincon(fun2,