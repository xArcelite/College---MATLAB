clear all;

Bp = 0.0024;
Br = 0.0024;
mp = 0.127;
lp = 0.337;
dp = 0.156;
jp = 0.0012;
marm = 0.257;
r = 0.216;
larm = 0.0619;
jarm = 9.98*10^-4;
Jarm = 0.002;
Kcnc = 4096;

%How we simplify in part 1 is by first singling out the torque function in
%equation 1. After that, we linearize by putting all variables to 0.

P_motor = c*s^2/((marm*s^2 + br*s)*(mp*s^2+bp*s+K)-c^2*s^4);

%We are given b1 and b2 through bp/br.
%We are also given mp and marm.
%The problem is finding k and c.

tm = (mp*lc^2 + jr)*thetaaccel - 0.5*mp*lp*lr*aAccel + Br*thetavelo;
%Linearization of first equation

aVelo = (-0.5*mp*lp*lr*thetaAccel + (jp+0.25*mp*lp^2)*aAccel - 0.5*mp*lp*9.81*a)/-Bp;
%Linearization of second equation

Jt = jp*mp*lr^2 + jr*jp + 0.25*jp*mp*lp^2;
%Determinent of matries using both linearizations.

ThetaAccel = (1/Jt)*(-(jp+0.25*mp*lp^2)*Br*ThetaVelo-0.5*mp*lp*lr*bp*+0.25*mp^2*lp^2*lr*9.81*a+(jp+0.25*mp*lp^2)*Tm);
aAccel = (1/Jt)*(0.5*mp*lp*lr*br*thetavelo-(Jr+mp+lr^2)*bp*aveloc+0.5*mp*lp*9.81*(jr+mp*lr^2)*a+0.5*mp*lp*lr*tm);

%After this, aAccel and ThetaAccel making a 3x4 matrix. The said matrix
%should be like A= 1/(jt)[0 0 -1 0, 0 0 0 1, 0 0.25mp^2...]. I still have
%to do some calibration. Along with it, B should provide (1/Jt)[0, 0,
%Jp+0.25*mp*lp^2, 0.5*mp*lp*lr].

%I'll bring the code next class. It takes way too long for Matlab to
%process this even on school computers for some reason.