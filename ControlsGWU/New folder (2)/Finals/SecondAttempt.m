%%Lag-Lead Compensator Design.
%Second attempt

%% %Lead Compensator Design.

%G = 10/s(s+2)(s+5)
%Sin(Phasem) = (1-a)/(1+a)
%S(Phase)+a*S(Phase) = 1-a
%a(S(Phase)+1) = 1-S(Phase)
%a = 1-0.2588190451/1+0.2588190451
%a = 0.58879070647 or 0.589.

%Kc *a*|G(jwc)| = 10log(a)
%Kc lim as s->0 sGc(s)G(s) = 10/10 (Kc*a) = 50.
%Kc*a = 50

%|Kc*a*Gc(jwc)| = 10/jw(jw+2)(jw+5)
%sqrt(a) = 0.76746335417
%In db = -1.14942352609db.
%|500/jw(jw+2)(jw+5)| = -1.15db.
bode(50*G)
grid on
%We use Bode to find the point at -1.15db.

%wc = ~7.78.
%T^-1 = 5.9708.
%Kc = 1/sqrt(a)*wc
%Kc = 0.4092.
%Gc(s) = 0.2410*(0.1675s+1)/(0.0986s+1)

%% Lag compensator design

%Gc(s) = Kc(s+1/t)/(s+1/beta*t)

%Kv = lim as s goes to 0 of:
%Gc(s)*G(s) = Kc*Beta = 50
%Phase margin of 50G(s) is around -40.
%15+40 = 55 degrees.
%The new phase margin is acquired at around 11 rad/s.
%New crossover freq = 11 radians per second.

%Placing the zero on the lag compensator: 
%w = 1/T = 11/50 = 0.22
%The crossover freq wc = 11 rad/sec when at -9.51db.
%We need to have atteunuation of -45db at wc.
%In order to do this, then -20*log(beta) = -9.51.
%Beta = 2.9888.
%Kc = 50/2.9888 = 16.7291
%Pole = 1/beta*T = 0.0736

%% %Combining both lag/lead.

%So at the end, we should have:

%K * (s+1/T1)(s+1/T2)/(s+1/aT1)(s+1/bT2)
%Gc(s) = 16.7291*0.4092 *(s+5.9708)(s+0.22)/(s+10.1372)(s+0.0736)
Gc = tf([6.84554 42.379 8.992],[1 10.2108 0.7461]);
bode(Gc*G)
grid on