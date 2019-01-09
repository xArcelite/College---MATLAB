close all;
clear all;
%% Define Link Lengths
a1 = 10;
a2 = 10;
%% Define Joint Angle Values
theta1 = 0.7845;
theta2 = 0;
%% Compute End Effector Position
pos = fwdKin(a1,a2,theta1,theta2)
%% Plot Workspace
% Open Figure
figure(1);
hold on;
for theta1 = 0:0.1:pi/2
 for theta2 = -pi/2:0.1:pi/2
 pos = fwdKin(a1,a2,theta1,theta2);
 scatter(pos(1),pos(2),'b');
 end
end

circleCenter = [13; 13]; 
radius = 2; 

for phi = 0:0.4:2*pi 
xCircle = radius*cos(phi) + circleCenter(1); 
yCircle = radius*sin(phi) + circleCenter(2); 
scatter(xCircle,yCircle,'filled','r'); 
end
