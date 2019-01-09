% hw10_3.m
% Modified to HW12_1.m

%Firstly, recitation: K = ~0.6 for 20% Overshoot.
%tf = K/(2s^2+s)
%When Time Delay = 3 seconds, K = ~0.15 for 20%.

clear all;
close all;
clc;

w = logspace(-2,3,101);
gain = zeros(size(w));
phs = zeros(size(w));
for i = 1:length(w)
	this_w = w(i);
	sys = sim('hw12_rec1_mdl','StopTime',num2str(3+20*2*pi/this_w),'MaxStep',num2str(2*pi/(100*this_w)));
	simout = sys.get('simout');
	t = simout.time;
	x = simout.data;

	% trim first 3s to remove transients
	x = x(t>=3,:);
	t = t(t>=3);

	N = length(t);
	g = sqrt(2/N*sum(x(:,1).^2));
	cos_phs = 2/(g*N)*sum(sin(this_w*t).*x(:,1));
	sin_phs = 2/(g*N)*sum(cos(this_w*t).*x(:,1));
	phs(i) = 180/pi*atan2(sin_phs,cos_phs);
	gain(i) = 20*log10(g);
end

figure;
subplot(2,1,1);
semilogx(w,gain);
grid on;
subplot(2,1,2);
semilogx(w,unwrap(phs));
grid on;
