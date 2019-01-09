clear all

G1 = zpk([-1 -0.5],[-5],1);
G2 = tf([1],[1 0.25 1]);

w = logspace(-3,7,1000000);

[mag,phase] = bode(G1,w);
[mag2,phase2] = bode(G2,w);

mag = mag(1,:);
phase = phase(1,:);
mag2 = mag2(1,:);
phase2 = phase2(1,:);

figure
polar(phase*pi/180,mag)
figure
polar(phase2*pi/180,mag2)