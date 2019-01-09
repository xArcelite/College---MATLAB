close all
clear 
clc

%Jung Min Bae
%Homework #11
%Wickenheiser MAE 4194

%% Question 1.
G = tf(10,[1 3]);
GH = feedback(G,1);
step(GH)

t = linspace(0, 45, 1000);
u = (sin(t+(pi/6))) - (2*cos(2*t - (pi/4)));
figure
lsim(GH, u, t)

%% Question 2

G1 = zpk([-1 -0.5],[-5],1);
G2 = tf([1],[1 0.25 1]);

asymp(G1)
figure
margin(G1)

asymp(G2)
figure
margin(G2)


G1 = zpk([-1 -0.5],[-5],1);
G2 = tf([1],[1 0.25 1]);

w = logspace(-7,7,100000);

[mag,phase] = bode(G1,w);
[mag2,phase2] = bode(G2,w);

mag = mag(1,:);
phase = phase(1,:);
mag2 = mag2(1,:);
phase2 = phase2(1,:);

figure
polar(phase*pi/180,mag) %Makes a almost complete circle.
figure
polar(phase2*pi/180,mag2) %goes straight up.
%these make sense. Because of the magnitude and phase being used as
%variables.
%Source: https://www.kullabs.com/classes/subjects/units/lessons/notes/note-detail/4344

%% Question 3.
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

%% Question 4.
G = zpk([],[0,-1,-10],25)
figure
asymp(G) %part 1.
%Part 2.
%Gain = ~50.
%Cutoff = 3.2 rad/s.
figure
margin(G) %Part 3.

%% Question 5.
G = tf([.84 1],[1 0 0])
figure
margin(G)
%Phase Margin already shown on graph.

%% Question 6

mu = 0.08;
sig = 0.01;
b = mu + sig*randn(1000,1);
j = 0;

for i = 1:length(b)
    s = tf('s');
    G = 1/((s+3)*(s^2 + b(i).*s + 5));
    [Gm, Pm, Wcg, Wcp] = margin(G);
    stable = 0; %Nyquist of G
    if Gm > 1 && Pm >0
        stable = 1;
        j = j+1;
        r(j) = b(i); %Word of caution, unstablility.
    end
end
percentage = 100*(j/length(b))
%To increase percentage, increase j or decrease B. Meaning we need to
%decrease mu and sig.