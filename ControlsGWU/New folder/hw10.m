close all
clear all

a = 5;
k = 2.15;
s = tf('s');
G = k/(s*(s+2)*(s+5));
h = s+a;

rlocus(G*h);

inner = feedback(G,h);
outer = feedback(1.3*inner,1);
figure
step(outer);