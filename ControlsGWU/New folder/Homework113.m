K = 5; %Adjust to gain
L = tf([-K K],[1 1]);
figure
nyquist(L) 
%P = 0.
%Nyquist Criterion:

%G(jw)= (-jw+1)(-jw+1)/(jw+1)(-jw+1)
%G(jw)= (1-jw)^2 /(w+1)
%G(jw)= (-w^2+1) + j(-2w) / w^2 + 1
%G(j0+) = 1 when w -> 0+
%G(J0+) = K* (0 + 1) + (0) / 0 + 1

%The polar plot is a circle that starts at the origin.
%Radius is K.
%N = Z - P = 0.
%K must be greater then unity.
%K is therefore stable for all values.

%Polar graph:
grid

w = logspace(-4,6,1000000);
[mag3,phase3] = bode(L,w);
mag3 = mag3(1,:);
phase3 = phase3(1,:);

figure
polar(phase3*pi/180,mag3)