%Problem 2:

%General model: wn^2 / s^2+2zetawns+wn^2

wn = 8;
Zeta = 0.1;
%we'll say that Zeta = 0.1, since the overshoot is around +14dB
%Looking at the dots, there's 15 dots from 0 to 20, the graph stops at 10th
%dot. 20 * (10/15) = ~13.33. So we'll say it's +14 dB.

PercentOvershoot = 0.66;

% ts = 4/(zeta*wn)

ts = 2;

%tp = pi/wn*sqrt(1-zeta^2);

tp = 0.3947;

%There is a zero at 1 rad/s, adding a few things for slope compensation
%Frequency at 15 rad/s.
%Zero at 8 for steep slope

%G = (8*(s+15)*(s)*wn^2)/(15*(s^2+2*wn*Zeta*s+wn^2)(s+8));
%G = s^2+15s / s^3+9.6s^2+76.8s+512

K = wn^2;
H = 15;

G = tf([K 15*K 0],[1*H 9.6*H 76.8*H 512*H]);

bode(G)