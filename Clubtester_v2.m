close all
%% Sampling parameters
Fs=17000;
Ts=1/Fs;

thD=131:179;
aD=145:((180-145)/(length(thD)-1)):180;

thI=138:176;
aI=143:((180-143)/(length(thI)-1)):180;

thW=142:174;
aW=143:((180-143)/(length(thW)-1)):180;
%% Empirical models
tD= 0.213:((0.235-0.213)/(length(thD)-1)):0.235;
DSwing=-4.546e+06*tD.^2 + 2.148e+06*tD - 2.506e+05;
vd=(DSwing.*0.02885)/2;

tI= 0.216:((0.24-0.216)/(length(thI)-1)):0.24;
ISwing=-2.857e+06*tI.^2 + 1.383e+06*tI -1.644e+05;
vI=(ISwing.*0.02885)/2;

tW= 0.216:((0.24-0.216)/(length(thW)-1)):0.24;
WSwing=-1.868e+06*tW.^2 + 9.068e+05*tW -1.077e+05;
vW=(WSwing.*0.02885)/2;

%% Modelling Parameters

lgD=1.14;   %length of club
rD=0.5;
dthD=20.2;


lgI=0.94;   %length of club
rI=0.5;
dthI=27;


lgW=0.89;   %length of club
rW=0.5;
dthW=24;

daD=10;
daI=3.5;
daW=0;

ddaD=0;
ddaI=0;
ddaW=0;

ddthD=100;
ddthI=50;
ddthW=50;

%% Equations of Motion Driver
xD= -rD*sind(thD) + lgD*sind(thD+aD);
yD= rD*cosd(thD) - lgD*cosd(thD+aD);
VxD=-rD*cosd(thD)*dthD + lgD*cosd(thD+aD)*(dthD+daD);
VxD=VxD./cosd(10);
axD= rD*sind(thD)*dthD^2 -lgD*sind(thD+aD)*(dthD+daD)^2+lgD*cosd(thD+aD)*(ddaD+ddthD);
axD=axD./cosd(10);

%% Equations of Motion Iron
xI= -rI*sind(thI) + lgI*sind(thI+aI);
yI= rD*cosd(thI) - lgD*cosd(thI+aI);
VxI=-rI*cosd(thI)*dthI + lgI*cosd(thI+aI)*(dthI+daI);
VxI=VxI./cosd(10);
axI= rI*sind(thI)*dthI^2 -lgI*sind(thI+aI)*(dthI+daI)^2+lgI*cosd(thI+aI)*(ddaI+ddthI);
axI=axI./cosd(10);

%% Equations of Motion Wedge
xW= -rW*sind(thW) + lgW*sind(thW+aW);
yW= rD*cosd(thW) - lgD*cosd(thW+aW);
VxW=-rW*cosd(thW)*dthW + lgW*cosd(thW+aW)*(dthW+daW);
VxW=VxW./cosd(10);
axW= rW*sind(thW)*dthW^2 -lgW*sind(thW+aW)*(dthW+daW)^2+lgW*cosd(thW+aW)*(ddaW+ddthW);
axW=axW./cosd(10);

%% Driver Plot
figure('Color',[1 1 1])
subplot(3,1,1)
plot(tD,vd,'Color',[0 0 0.4],'LineWidth',2);grid on; 
hold on;
plot(tD,VxD,'--k','LineWidth',2); 
legend('Empirical','EOM','Location','SouthEast')
xlabel("Time (s)")
ylabel("Velocity (m/s)");
xlim([0.21 0.24])
ylim([5 50])
% title("Driver")
hold off

%% Iron Plot
subplot(3,1,2)
% figure('Color',[1 1 1])
plot(tI,vI,'Color',[0.1 0 0.9],'LineWidth',2); grid on; 
hold on;
plot(tI,VxI,'--k','LineWidth',2);
legend('Empirical','EOM','Location','SouthEast')
xlabel("Time (s)")
ylabel("Velocity (m/s)");
xlim([0.21 0.245])
ylim([10 50])
% title("7-Iron")
hold off

%% Wedge Plot
subplot(3,1,3)
% figure('Color',[1 1 1])
plot(tW,vW,'Color',[0 0.7 0.9],'LineWidth',2); grid on; 
hold on;
plot(tW,VxW,'--k','LineWidth',2);
legend('Empirical','EOM','Location','SouthEast')
xlabel("Time (s)")
ylabel("Velocity (m/s)");
xlim([0.21 0.245])
ylim([10 40])
% title("Wedge")
hold off

%% Acceleration Profile Modelling
% figure;
% 
% dDSwing=2*-4.57e+06*tD + 2.16e+06 ;
% dvD=(dDSwing.*0.02885)/2;
% plot(tD,dvD,'LineWidth',2);
% hold on;
% plot(tD,axD,'--b','LineWidth',2);
% 
% dISwing=2*-2.857e+06*tI + 1.383e+06 ;
% dvI=(dISwing.*0.02885)/2;
% plot(tI,dvI,'k','LineWidth',2);
% plot(tI,axI,'--k','LineWidth',2);
% 
% dWSwing=2*-1.868e+06*tW + 9.068e+05;
% dvW=(dWSwing.*0.02885)/2;
% plot(tW,dvW,'LineWidth',2);
% xlabel("Time (s)");ylabel("Acceleration (m/s^2)")
% plot(tW,axW,'--g','LineWidth',2);
% grid on;legend("Driver Empirical","Driver EOM","7-Iron Empirical","7-Iron EOM","7-Iron Empirical","Wedge EOM")
% hold off;


%% Acceleration at Impact Error
aD_error=abs(axD(end)-dvD(end))/9.81;
aI_error=abs(axI(end)-dvI(end))/9.81;
aW_error=abs(axW(end)-dvW(end))/9.81;

ag_error=[aD_error,aI_error,aW_error];
%% Trajectory of golf club
% figure;
% plot(xD,yD);
% hold on
% plot(xI,yI);
% hold on
% plot(xW,yW);
% hold off
% grid on

%% Mean Square Error
Dc_error=sqrt(mse(VxD,vd));
Ic_error=sqrt(mse(VxI,vI));
Wc_error=sqrt(mse(VxW,vW));

Club_Error = [Dc_error, Ic_error, Wc_error]

%% Mean Squared Error Function

function [MSE] = mse(y,y1)

s=sum((y-y1).^2);
MSE=1/(length(y)-1)  *  s;
end



