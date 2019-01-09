%%Function: PD Controller for Quadrotor

clc
clear all
close all

global Jr Ix Iy Iz b d l m g 
global Kpz Kdz Kpp Kdp Kpt Kdt Kpps Kdps ZdF PhidF ThetadF PsidF 
global ztime phitime thetatime psitime Zinit Phiinit Thetainit Psiinit 
global U1 U2 U3 U4 Ez Ep Et Eps

%gains
kpp = 0.7;
kdp = 0.3;
kpt = 1.1;
kdt = 0.3;
kpps = 1;
kdps = 0.4;
kpz = 100;
kdz = 20;
Gains = [kpp kdp kpt kdt kpps kdps kpz kdz];
disp(Gains);

%Moments of Inertia
Ix = 7.5*10^(-3); 
Iy = 7.5*10^(-3);  
Iz = 1.0*10^(-2);  
Jr = 7.0*10^(-5);  

b = ()*10^(-6);  % Thrust coefficient (input)
d = ()*10^(-6);  % Drag coefficient (input)

l = 0.23;  % Distance from Center to Quadrotors (m)
m = ;  % Mass of Quadrotor (kg) (input)
g = 9.81;   %  Gravity (m/s2)

sim('PDQuadrotor')
