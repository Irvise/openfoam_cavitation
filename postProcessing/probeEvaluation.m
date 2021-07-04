clc
close all force
clear all

addpath('data');
addpath('figures');

p_center 	        = 	load('data/p')	;
ambientPressure   =  1e5              ;

 
fig1=figure(1);
semilogy(p_center(:,1),p_center(:,2)/ambientPressure,'k')
hold on
plot(p_center(:,1),p_center(:,3)/ambientPressure,'r')
plot(p_center(:,1),p_center(:,4)/ambientPressure,'b')
 
title('Pressure probes symmetry bubble. Normalized to p_{inf}')
legend('Radius =  7.07e-3','Radius =  2.12e-2','Radius =  4.71e-2' )
xlabel('Time [s]')
ylabel('p/po [-]')
hold off
 
 
 
%{ 
fig2=figure(2);
plot(p_center(:,1),p_center(:,2)/ambientPressure,'k')
hold on
plot(p_center(:,1),p_center(:,3)/ambientPressure,'r')
plot(p_center(:,1),p_center(:,4)/ambientPressure,'b')
title('symetryComparison')
legend('probe-1','probe-2','probe-3')
xlabel('time in s')
ylabel('p/po ')
hold off
%}
saveas(fig1,'figures/probeLog.png')
%saveas(fig2,'figures/probeNormal.png')



%% TEST RP equation!
%% Taken from https://www.researchgate.net/publication/340741680_Numerical_Integration_of_the_Rayleigh-Plesset_Equation

rho = 998; % [kg/m^3] water density 
S = 72e-3; % [N/m] surface tension of water (wikipedia) 
mu = 0.0009106819194523486; % [Pa*s] dynamic viscosity of water (wikipedia) 
k = 1.4; % Gamma = Cp/Cv (ratio of specific heat of gas) 
p0 = 100e3; % [Pa] static pressure (~ 1 atmosphere) 
pV = 2985.7979043823643; % [Pa] water vapor pressure at 297.15K (wikipedia) 
%% initial conditions 
R_0 = 3e-3; %[m] initial bubble radius 
Rt_0 = 0; % [m/s] initial radius velocity 
pG = p0 + 2*S/R_0 - pV; % [Pa] initial constant dissolved gas pressure in bubble 
dt = 2e-9; % [s] time step

% Personally fixed
N = 0.0005/dt;
R = zeros(N,1); % Empty array
R(1) = R_0; % Initialize array

%% integration 
Rt = Rt_0; % first velocity 
disp('starting'), tic 
for i1 = 2:N, 
    Rp = R(i1 - 1) ; % previous R 
    % Old complete version
    %Rtt = ( pV - pt(i1) + pG*( R_0/Rp)^(3*k) - (2*S + 4*mu*Rt)/Rp )/(rho*Rp) - 1.5*Rt*Rt/Rp;% next aceleration (Check!!) 
    
    % My version
    Rtt = ( pV - p0 - (2*S + 4*mu*Rt)/Rp )/(rho*Rp) - 1.5*Rt*Rt/Rp;
    %Rtt = -(p0/rho)*(R_0^3/Rp^4);
    if ~isreal(Rtt), break, end
    if Rtt >= 1400, Rtt=1400; end
    if Rp = 0, Rtt =0; end
    %Rt = Rt + Rtt*dt; % next velocity - Old version 
    R_new = R(i1 - 1) + Rt*dt+ 0.5*Rtt*dt*dt; % next radius 
    if ~isreal(R_new), break, end
    if R_new < 0.0000001, R_new = 0; end
    R(i1) = R_new; 
    Rt = Rt + Rtt*dt; % next velocity - New version!!! 
    if ~isreal(Rt), break, end 
end 
toc, disp('::finished') 
if ~(i1==N), disp('imaginary values broke the loop!!!'), end

%% Pressure calculation

r_seq = [0.00707, 0.02121, 0.04666];
[_, r_seq_size] = size(r_seq);
p_stimated = zeros(N, r_seq_size);
delta_t_sim = 1e-6;
jump_r_to_p = int64(delta_t_sim/dt);
%R_reduced = R(1:jump_r_to_p:end);
R_reduced = R;
for t = 1:N,
  for r = 1:r_seq_size,
    p_stimated(t,r) = 1 + (R_reduced(t)/(3*r_seq(r))) * (R_0^3/R_reduced(t)^3 - 4) - (R_reduced(t)^4/(3 * r_seq(r)^4))*(R_0^3/R_reduced(t)^3 -1);
  endfor
endfor

p_stimated_sliced = zeros(size(p_center)(1), r_seq_size);
p_stimated_sliced = p_stimated(1:jump_r_to_p:size(p_center)(1)*jump_r_to_p,:);

%% Plot the comparison
fig2=figure(2);
semilogy(p_center(:,1),p_center(:,2)/ambientPressure,'k')
hold on
plot(p_center(:,1),p_stimated_sliced(:,1),'k--')

plot(p_center(:,1),p_center(:,3)/ambientPressure,'r')
plot(p_center(:,1),p_stimated_sliced(:,2),'r--')
plot(p_center(:,1),p_center(:,4)/ambientPressure,'b')
plot(p_center(:,1),p_stimated_sliced(:,3),'b--')

title('Comparison between Rayleigh-Plesset and Simulation. Normalized pressure')
legend('Radius =  7.07e-3', "" ,'Radius =  2.12e-2', "",'Radius =  4.71e-2', "")
xlabel('Time [s]')
ylabel('p/po [-]')

hold off
saveas(fig2,'figures/probeLogRP.png')
