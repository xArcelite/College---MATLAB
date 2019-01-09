%%Problem 1A %%

%Find the closed form inverse kinematic solution (using whatever method you like) to find
%?1, ?2 given x, y (no orientation given). [This should be a simpler problem than the one
%worked out in class, and you may be able to make use of similar identities to work out
%the solution.]. Also write a MATLAB function to compute the joint angles, given x, y
%(using the closed form inverse solution directly).

%I used the q = f^-1([oN,RN]) approach with [theta1,theta2] = f-1(x,y)

a1 = 10;
a2 = 10;
a = (a1^2+a2^2);

x = 7.2;
y = 10.2;
d = sqrt(x^2+y^2);

theta2 = 180 - acosd((d-a)/(2*a1*a2));
%I used the law of cosines to find the theta2.

theta1 = atand(y/x) - atand(a2*sin(theta2)/(a1+a2*cos(theta2)));
%afterwards, I consider the two triangles made by the x0 point and the one
%made with the manipulator arms to find the solution.