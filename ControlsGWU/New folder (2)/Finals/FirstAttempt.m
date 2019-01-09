%Jung Min Bae
%MAE4182
%Finals: October 6th, 1995
%Question D: G(s) = 10/(s(s+2)(s+5)).

clear all;
close all;
clc;

%% %Section 1: Givens
%1. This is a Type-1 System.
%2. We are going to do frequency analysis.

num_a = 10; % open-loop transfer function
den_a = [1 7 10 0];

G = zpk([],[0,-2,-5],10); %Zpk Transfer Function.
Kv = 50; %Specified Velocity Error Constant
PM_spec = 15; %Specified Phase Margin
Ts_spec = 2; %Specified Settling Time
T = 0.5; %Ts = 4T
fig_size = [250 80 800 640];

%% %Section 2: Uncompensated Bode/Step (Comparison to Section 3/4)
s = tf('s');

figure(1)
step(G)
figure(2)
step(G / s)
figure(3)
bode(G, {0.1,100})
grid on

%% %Section 3: Bode Plots explained

%First, we get to the stability margin
[GM_a,PM_a,wphi_a,wx_a] = margin(num_a,den_a);
GMdb_a = 20*log10(GM_a);
w = logspace(-3,3,600);
[mag_a,ph_a] = bode(num_a,den_a,w);
figure(4), clf, semilogx(w,20*log(mag_a),w,ph_a,[min(w) max(w)],[-180 -180],'r--'),grid,xlabel('frequency'),ylabel('magnitude and Phase'),title('uncompensated system bode')

ess = 1/Kv; %ESS = 1/Kv for a Type 1 system.

% Kv = Lim as S->0 for [s*G(s)]
%Because of this,
Kv_a = num_a(length(num_a)) / den_a(length(den_a)-1);
%Lim as x goes to 0 for G(s) = (10/(2)(5))) = 1.
ess_a = 1/Kv_a; %Ess for the original system
Kc = ess_a / ess; %gain needed to satisfy the specified Kv

figure(5), clf, semilogx(w,20*log(mag_a),w,ph_a, w,20*log10(mag_a),'k--',[min(w) max(w)],[-180 -180],'r--'),grid, xlabel('frequency'),ylabel('magnitude and Phase'),title(['uncompensated system bode with Kc' num2str(Kc)])

%% %Section 4: Step Plots Explained
%We will compute both the step and ramp response of the closed-loop system.
%There will be two systems, one with Kcl = 1 (original)
%While the other Kcl will be the one computed to satisfy given Kv/Ess.

t = linspace(0,30,1001); % time vector

%Closed-Loop Systems:
[ncl_a,dcl_a] = cloop(num_a,den_a,-1);
[ncl_ak,dcl_ak] = cloop(Kc*num_a,den_a,-1);

%Step Response
ys_a = step(ncl_a,dcl_a,t);
ys_ak = step(ncl_ak,dcl_ak,t);

%We set the time and positions of the step response.
PO_a = 100*(max(ys_a)-1);
PO_ak = 100*(max(ys_ak)-1);

% ramp response
yr_a = step(ncl_a,[dcl_a 0],t);
yr_ak = step(ncl_ak,[dcl_ak 0],t);

% Step response 1, uncompensated
figure(6),clf,plot(t,ys_ak,t,ys_a),grid, xlabel('Time (s)'),ylabel('Step Responses'), title(['Uncompensated System and System with K_c = ' num2str(Kc)]), set(gcf,'Position',fig_size)
% Ramp response 2, uncompensated
figure(7),clf,plot(t,yr_ak,t,yr_a,[0 30],[0 30],'k--'),grid, xlabel('Time (s)'),ylabel('Ramp Responses'), title(['Uncompensated System and System with K_c = ' num2str(Kc)]), set(gcf,'Position',fig_size)

%% %section 5: Designing the Two-step compensator
%For the two-stage lead-lag, we need to raise the phase curve.

%We first need a stability margin with Kcl.
[GM_ak,PM_ak,wphi_ak,wx_ak] = margin(Kc*num_a,den_a);
GMdb_ak = 20*log10(GM_ak);
%To obtain the phase shift per stage:
phimax = (PM_spec+2-PM_ak)/2;
alfa_d = (1-sin(phimax*pi/180))/(1+sin(phimax*pi/180));
%To obtain the lead compensator poles and zeroes:
zc_d = wx_ak*sqrt(alfa_d);
pc_d = zc_d/alfa_d;
%To find the lead compensator numerator and denominator...
num_c_d = conv([1/zc_d 1],[1/zc_d 1]);
den_c_d = conv([1/pc_d 1],[1/pc_d 1]);
%Using both values, the compensated forward transfer function should be:
[nf_d,df_d] = series(Kc*num_c_d,den_c_d,num_a,den_a);
%Finding the stability margin with the lead compensator
[GM_d,PM_d,wphi_d,wx_d] = margin(nf_d,df_d);
GMdb_d = 20*log10(GM_d);
[mag_d,ph_d] = bode(nf_d,df_d,w);
%This concludes the first part of the lag-lead.

%% %Section 6: Creating the one-stage lag compensator
%We need to lower the magnitude curve to what the chosen value is.

%We first locate wx. It's found in the frequency vector.
[i0,i1] = min(abs(w-wx_ak));
%Aftewards, we prepare to find the lag compensator poles/zeroes.
alfa_g = Kc*mag_a(i1) / alfa_d;
%The zeroes of the compensator.
zc_g = wx_ak / 10;
%The poles of the compensator.
pc_g = zc_g / alfa_g;
%We start setting up the transfer function.
num_c_g = [1/zc_g 1]; 
den_c_g = [1/pc_g 1];
%We get the final compensated forward transfer function.
[nf_dg,df_dg] = series(num_c_g,den_c_g,nf_d,df_d);
%We also get the final stability margins.
[GM_dg,PM_dg,wphi_dg,wx_dg] = margin(nf_dg,df_dg); 
GMdb_dg = 20*log10(GM_dg);
[mag_dg,ph_dg] = bode(nf_dg,df_dg,w);

figure(8),clf,semilogx(w,20*log10(mag_dg),w,ph_dg, w,20*log10(mag_d),'k--',w,ph_d,'k--',[min(w) max(w)],[-180 -180],'r--'),grid, xlabel('Frequency (r/s)'),ylabel('Magnitude(db) and Phase(deg)'), title('Final Lag-Lead Compensated System')

%We get the final step and ramp response.
[ncl_dg,dcl_dg] = cloop(nf_dg,df_dg,-1);
ys_dg = step(ncl_dg,dcl_dg,t);
yr_dg = step(ncl_dg,[dcl_dg 0],t);

%Step Response Graph.
figure(9),clf,plot(t,ys_dg,t,ys_ak,t,ys_a),grid, xlabel('Time (s)'),ylabel('Step Responses'),title('Final Compensated Step Response')

%Ramp Response Graph.
figure(10),clf,plot(t,yr_dg,t,yr_ak,t,yr_a,[0 30],[0 30],'k--'),grid, xlabel('Time (s)'),ylabel('Ramp Responses'),title('Final Compensated Ramp Response')

%% %Section 7.1: Introduction to Explanation of Code 4-7.

%So we were given 3 conditions: 
%Velocity Error Constant (which can be converted to steady-state error for ramp input)
%Settling Time for a step input.
%Phase Margin of 15 degrees.

% Since the design has to be frequency domain, the first specification that
% needs to be dealt with is the Steady-state Error Requirement.

% Since the plant is Type-1 and Kv corrolates with Error Specification, we
% can compare the two error values of the plant and the goal error value.

%We find the values of the error constants and find Kc.
%Through Kc, we find the yield of the error for a ramp input when uncompensated.
%And we find the required error reduction needed.
%Therefore, we put in an amplifier with a gain to compensate.

%% Section 7.2: Explanation of the Figures.

%First step, we create the Bode Plots for Kc*Gp(s), the step response and
%the ramp responses in the time domain in the figures. The dashed lines are
%the original magnitude plots for reference.

%So a few things can be found from each plot:

%The Bode plot shows whether gain crossover freq. is increased by more than
%one decade. This either shows whether the system with gain has slower or
%faster response time then the original system. We can also find the phase
%margin either decreased or increased by the change of gain.

%Overall, we can find from the Bode plot if the system is becoming
%unstable.

%The Step Response, we find the reduction in stability through either
%overshooting by a large margin or rapid oscillations. The good part is
%that the step response will have decreased settling time, but this also
%shows that the final compensated system will have to eliminate both rapid
%oscillations and large overshoot.

%The Ramp Response shows the decrease in steady-state error. The dashed
%line is suppose to show the input signal.

%% %Section 7.3: After the bode plots. Creating the filters.

%So we have the gain crossover frequency from the step response.
%We need to find the final compensated gain crossover frequency, 
%which we can safely say would be close to Kc.
%To reduce OS% and Oscillations, we will raise the phase curve.

%To gain the crossover freq and phase margin specs, we will use two-steps.
%First, we will make a lead compensator.
%After that, we will create a lag compensator.

%% %Section 7.4: Creating the Lead Compensator

%The first compensator is to provide enough positive shift to satisfy the
%phase margin provided.

%The second compensator is designed to lower the magnitude curve from the
%combined system to 0db.

%With the Kc given, we can find the gain crossover frequency.
%Along with the GCF, we find th ephase shift.
%From that, we find the angle the lead need to provide.
%Since there is two-steps, we don't really need to compensate everything.
%So we cut phase comepnsation by half and require each step to do half the
%work.

%We find the alfa_lead with the phase shift
%Through that, we find the zeros and poles with the maximum Phase shift.
%We find the Bode plot from this.
%The system is unstable, but it'll be stabilized with the 2nd compensator.

%% %Section 7.5: Creating the Lag Compensator

%So we need to move the magnitude curve to 0db.
%We find the amount that needs to be moved down by the sums of the
%magnitude of KcGp(s) and the magnitude of the two-stage lead compensator
%at the same frequency.
%We find the value of alfa_lag through this and use the lag compensator
%zero frequency to find the gain crossover frequency.
%We find the zero and pole of the lag compensator through this.

%After this, the system is stabilized and we have the bode plots.

%We graph the step and ramp response to show that the time-domain
%specifications are satisfied and that the lag-lead has the same
%steady-state error.

%% %Section 7.6: Speculation on what went wrong.

%So... The graphs don't look as accurate.

%My guess is that the original source of the problem lies in G(s).

%Section 3 provided the Kv of the uncompensated and the required system.
%However, since the uncompensated system had a Kv of 1, Kc ended up
%becoming the same as Kv.