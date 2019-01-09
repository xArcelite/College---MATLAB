%Jung Bae
%G00908808
%HW11 MATLAB

clear all
close all

num=8000; 
den=poly([-6 -20 -35]); 
G=tf(num,den);

figure(1)
bode(G)

figure(2)
nyquist(G)
