clear all

G1 = zpk([-1 -0.5],[-5],1);
G2 = tf([1],[1 0.25 1]);

asymp(G1)
figure
margin(G1)

asymp(G2)
figure
margin(G2)