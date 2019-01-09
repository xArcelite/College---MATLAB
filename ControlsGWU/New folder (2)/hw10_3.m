% hw10_3.m

clear all;
close all;
clc;

w = logspace(-2,3,101);
gain = zeros(size(w));
phs = zeros(size(w));
for i = 1:length(w)
	this_w = w(i);
	sys = sim('hw10_rec1_mdl','StopTime',num2str(50+20*2*pi/this_w),'MaxStep',num2str(2*pi/(100*this_w)));
	simout = sys.get('simout');
	t = simout.time;
	x = simout.data;

	% trim first 50s to remove transients
	x = x(t>=50,:);
	t = t(t>=50);

	N = length(t);
	g = sqrt(2/N*sum(x(:,2).^2));
	cos_phs = 2/(g*N)*sum(sin(this_w*t).*x(:,2));
	sin_phs = 2/(g*N)*sum(cos(this_w*t).*x(:,2));
	phs(i) = 180/pi*atan2(sin_phs,cos_phs);
	gain(i) = 20*log10(g);
end

figure;
subplot(2,1,1);
semilogx(w,gain);
grid on;
subplot(2,1,2);
semilogx(w,phs);
grid on;
