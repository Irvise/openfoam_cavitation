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
 
title('symetryComparison')
legend('Radius =  7.07e-3','Radius =  2.12e-2','Radius =  4.71e-2' )
xlabel('time in s')
ylabel('p/po ')
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
