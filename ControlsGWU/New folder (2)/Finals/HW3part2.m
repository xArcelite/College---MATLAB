clc
clear all
close all
 
l1 = 0;
l2 = 10;
l3 = 10;
 
% in degree
d1 = 45;
d2 = 30;
d3 = -30;
 
x0 = l1*cos(degtorad(d1));
y0 = l1*sin(degtorad(d1));
x1 = x0 + l2 * cosd(d1 + d2);
y1 = y0 + l2 * sind(d1 + d2);
x2 = x1 + l3 * cosd(d1 + d2 + d3 );
y2 = y1 + l3 * sind(d1 + d2 + d3);
x = [0 x0 x1 x2] ;
y = [0 y0 y1 y2];
plot(x,y,'-s');
