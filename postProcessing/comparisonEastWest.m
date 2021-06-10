clc
close all force
clear all

addpath('data');
addpath('figures');

p_center 	= 	load('data/center/line_p.xy')	;
p_east 		= 	load('data/east/line_p.xy') 	;
p_west 		= 	load('data/west/line_p.xy') 	;

U_center 	= 	load('data/center/line_U.xy') ;
U_east 		= 	load('data/east/line_U.xy')	  ;
U_west 		= 	load('data/west/line_U.xy') 	;



fig1=figure(1);
plot(p_east(:,1),p_east(:,2)/max(p_east(:,2)))
hold on
plot(p_west(:,1),p_west(:,2)/max(p_east(:,2)),'--')
title('symetryComparison')
legend('p-east','p-west')
xlabel('distance in Z')
ylabel('p Pa')
hold off

fig2 = figure(2);
plot(U_east(:,1), sqrt(U_east(:,2).^2 +U_east(:,3).^2+U_east(:,4).^2)/max(sqrt(U_east(:,2).^2 +U_east(:,3).^2+U_east(:,4).^2)))
hold on
plot(U_west(:,1),sqrt(U_west(:,2).^2 +U_west(:,3).^2+U_west(:,4).^2)/max(sqrt(U_east(:,2).^2 +U_east(:,3).^2+U_east(:,4).^2)))
title('symetryComparison')
legend('magnU-east','magnU-west')
xlabel('distance in Z')
ylabel('magn(U)/max(magnU) ')
hold off

saveas(fig1,'figures/symmetryPressure.png')
saveas(fig2,'figures/symmetryAlphavapour.png')