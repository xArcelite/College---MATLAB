close all
clear 
clc

%question 1.
G = tf(10,[1 3]);
GH = feedback(G,1);
step(GH)

t = linspace(0, 45, 1000);
u = (sin(t+(pi/6))) - (2*cos(2*t - (pi/4)));
figure
lsim(GH, u, t)

%question 4.
G = zpk([],[0,-1,-10],25)
figure
margin(G)

%question 5.
G = tf([.84 1],[1 0 0])
figure
margin(G)

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