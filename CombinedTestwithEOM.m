%%
close all

%% Sampling Parameters
Fs=17000;
Ts=1/Fs;
T_f=(10)/Fs;
%% Sample-time parameters
t0W=(0:3559)/Fs;            % Deadtime before downswing
% tWD=(3560:4200)/Fs;         % Time for Wedge downswing
tWD=0.216:((0.24-0.216)/Fs):0.24-((0.24-0.216)/Fs);
tWB_1=(4201:14499)/Fs;      % Time for Wedge ball before gain switch
tWB_2=(14500:76500)/Fs;     % Time for Wedge ball after gain switch

t0D=(0:3594)/Fs; % Change made here from Driver Final
% tDD=(3595:3935)/Fs;
tDD=0.212:((0.234-0.212)/Fs):0.234-((0.234-0.212)/Fs);
tDB_1=(3936:14399)/Fs;
tDB_2=(14400:106054)/Fs;
% tDB_2=(14400:156054)/Fs;


t0I=(0:3603)/Fs;            % Deadtime before downswing
% tID=(3604:3995)/Fs;         % Time for 7 Iron downswing
tID=0.216:((0.24-0.216)/Fs):0.24-((0.24-0.216)/Fs);
tIB_1=(3996:14300)/Fs;      % Time for 7 Iron ball before gain switch
tIB_2=(14301:85000)/Fs;     % Time for 7 iron ball after gain switch

% TimeW=(76500)/Fs; % Time for wedge
% TimeI=(85000)/Fs;
% TimeD=(106055)/Fs;

TimeW=(length([tWB_1 tWB_2]))/Fs; % Time for wedge
TimeI=(length([tIB_1 tIB_2]))/Fs;
TimeD=(length([tDB_1 tDB_2]))/Fs;

%% General Ball Parameters
p = 1.225;          %Air density at 15 degrees
D = 0.043 ;         %Diameter of Golf Ball around 4.3cm
R=D/2;              %Radius
m = 0.045;          %Mass of Golf Ball around 45 grams
g = 9.81;           %Acceleration Due to Gravity/m/s^2
w = m*g;            %Weight of the Golf Ball/N
A = pi*(R)^2;       %Cross Sectional area
k=(p*A)/(2*m);      %Constant for ease of implementation
%% Drag and Spin Parameters 
%Driver
CdD = 0.2;   
SpinD=1000;%/9.55;      %Spin in RPM

%7 Iron
CdI=0.3;
SpinI=6000;

%Wedge
CdW=0.23;
SpinW=10000;

%% Projectile Parameters
%Launch Angle (degrees)
alphaD = 9;    
alphaI=15;
alphaW=42;

%Initial Velocity  (m/s)
viD=69; 
viI=52;
viW=31.8;

vxiD = viD*cosd(alphaD)/cosd(10);    %Initial Velocity Resolved in x
vyiD = viD*sind(alphaD)/cosd(10);    %Initial Velocity Resolved in y

vxiI = viI*cosd(alphaI)/cosd(10);    %Initial Velocity Resolved in x
vyiI = viI*sind(alphaI)/cosd(10);    %Initial Velocity Resolved in y

vxiW = viW*cosd(alphaW)/cosd(10);    %Initial Velocity Resolved in x
vyiW = viW*sind(alphaW)/cosd(10);    %Initial Velocity Resolved in y

%% Instatiating Arrays Driver

nD = TimeD*Fs;
nI = TimeI*Fs;
nW = TimeW*Fs;

xdispD = zeros(1, nD+1);  %x-displacment Array
ydispD = zeros(1, nD+1);  %y-displacment Array

vD=zeros(1, nD+1);
vD(1)=viD;
vxD = zeros(1, nD+1);     %x-velocity Array
vxD(1) = vxiD;
vyD = zeros(1, nD+1);     %y-velocity Array
vyD(1) = vyiD;
axD=zeros(1, nD+1);
ayD=zeros(1, nD+1);
ClD=zeros(1, nD+1);
tD = zeros(1, nD+1);       %Time Array

%% Instatiating Arrays 7 Iron

xdispI = zeros(1, nI+1);  %x-displacment Array
ydispI = zeros(1, nI+1);  %y-displacment Array

vI=zeros(1, nI+1);
vI(1)=viI;
vxI = zeros(1, nI+1);     %x-velocity Array
vxI(1) = vxiI;
vyI = zeros(1, nI+1);     %y-velocity Array
vyI(1) = vyiI;
axI=zeros(1, nI+1);
ayI=zeros(1, nI+1);
ClI=zeros(1, nI+1);
tI = zeros(1, nI+1);       %Time Array

%% Instatiating Arrays Wedge

xdispW = zeros(1, nW+1);  %x-displacment Array
ydispW = zeros(1, nW+1);  %y-displacment Array

vW=zeros(1, nW+1);
vW(1)=viW;
vxW = zeros(1, nW+1);     %x-velocity Array
vxW(1) = vxiW;
vyW = zeros(1, nW+1);     %y-velocity Array
vyW(1) = vyiW;
axW=zeros(1, nW+1);
ayW=zeros(1, nW+1);
ClW=zeros(1, nW+1);
tW = zeros(1, nW+1);       %Time Array


%% Driver Iteration
dt = Ts;
i=1;

while i<nD
    
  ClD(i)=1./(2+(vD(i)./(R*SpinD))) ;                %Equation From Ball Trajectories Literature
  axD(i)=-k*vD(i).*(CdD*vxD(i)+ClD(i).*vyD(i));     %Equation From Ball Trajectories Literature
  ayD(i)=k*vD(i).*(ClD(i).*vxD(i)-CdD*vyD(i))-g;    %Equation From Ball Trajectories Literature
  vxD(i+1)=vxD(i)+axD(i)*dt;
  vyD(i+1)=vyD(i)+ayD(i)*dt;
  xdispD(i+1)=xdispD(i)+vxD(i)*dt+0.5*axD(i)*dt^2;
  ydispD(i+1)=ydispD(i)+vyD(i)*dt+0.5*ayD(i)*dt^2;
  tD(i+1)=tD(i)+dt;
  vD(i+1) = sqrt(vxD(i).^2 + vyD(i).^2);
  i=i+1;
  
end


%% 7 Iron Iteration
dt = Ts;
i=1;

while i<nI
    
  ClI(i)=1./(2+(vI(i)./(R*SpinI))) ;            %Equation From Ball Trajectories Literature
  axI(i)=-k*vI(i).*(CdI*vxI(i)+ClI(i).*vyI(i));    %Equation From Ball Trajectories Literature
  ayI(i)=k*vI(i).*(ClI(i).*vxI(i)-CdI*vyI(i))-g;   %Equation From Ball Trajectories Literature
  vxI(i+1)=vxI(i)+axI(i)*dt;
  vyI(i+1)=vyI(i)+ayI(i)*dt;
  xdispI(i+1)=xdispI(i)+vxI(i)*dt+0.5*axI(i)*dt^2;
  ydispI(i+1)=ydispI(i)+vyI(i)*dt+0.5*ayI(i)*dt^2;
  tI(i+1)=tI(i)+dt;
  vI(i+1) = sqrt(vxI(i).^2 + vyI(i).^2);
  i=i+1;
  
end

%% Wedge Iteration
dt = Ts;
i=1;

while i<nW
    
  ClW(i)=1./(2+(vW(i)./(R*SpinW))) ;            %Equation From Ball Trajectories Literature
  axW(i)=-k*vW(i).*(CdW*vxW(i)+ClW(i).*vyW(i));    %Equation From Ball Trajectories Literature
  ayW(i)=k*vW(i).*(ClW(i).*vxW(i)-CdW*vyW(i))-g;   %Equation From Ball Trajectories Literature
  vxW(i+1)=vxW(i)+axW(i)*dt;
  vyW(i+1)=vyW(i)+ayW(i)*dt;
  xdispW(i+1)=xdispW(i)+vxW(i)*dt+0.5*axW(i)*dt^2;
  ydispW(i+1)=ydispW(i)+vyW(i)*dt+0.5*ayW(i)*dt^2;
  tW(i+1)=tW(i)+dt;
  vW(i+1) = sqrt(vxW(i).^2 + vyW(i).^2);
  i=i+1;
  
end

%% Time Parameters
tI=(0:Ts:TimeI);
tW=(0:Ts:TimeW);
tD=(0:Ts:TimeD);


%% Ball Trajectory Maker
figure('Color',[1 1 1]);plot3(xdispW(1:end-1),zeros(1,length(ydispW(1:end-1))),ydispW(1:end-1),'Color',[0 0.7 0.9],'LineWidth',2);grid on;hold on;
plot3(xdispI(1:end-1),zeros(1,length(ydispI(1:end-1))),ydispI(1:end-1),'Color',[0.1 0 0.9],'LineWidth',2);
plot3(xdispD(1:end-1),zeros(1,length(ydispD(1:end-1))),ydispD(1:end-1),'Color',[0 0 0.4],'LineWidth',2);
hold off;xlabel('Range (m)');zlabel('Height (m)');ylabel('Position (m)');ylim([-0.2 0.2]);
legend('Wedge','7-Iron','Driver')

%% Closed Form Frequency vs time expressions
W0=zeros(1,length(t0W));
% WDownSwing= 69230.77*tWD-14146.15;
WDownSwing=-1.868e+06*tWD.^2 + 9.068e+05*tWD -1.077e+05;
Wball_1=2.963*tWB_1.^4 -35.81*tWB_1.^3 + 276.1*tWB_1.^2 -1127*tWB_1 + 2554;
Wball_2=2.963*tWB_2.^4 -35.81*tWB_2.^3 + 276.1*tWB_2.^2 -1127*tWB_2 + 2554;

I0=zeros(1,length(t0I));
% IDownSwing= 97826.09*tID-19989.13;
IDownSwing=-2.857e+06*tID.^2 + 1.383e+06*tID -1.644e+05;
Iball_1=11.42*tIB_1.^4  -134.6*tIB_1.^3 + 669.2*tIB_1.^2 + -1975*tIB_1 + 4207;
Iball_2=11.42*tIB_2.^4  -134.6*tIB_2.^3 + 669.2*tIB_2.^2 + -1975*tIB_2 + 4207;

D0=zeros(1,length(t0D));
% DDownSwing=110000*tDD-22265;
DDownSwing=-4.546e+06*tDD.^2 + 2.148e+06*tDD -2.506e+05;
Dball_1=0.9761*tDB_1.^4 -22.672*tDB_1.^3+254.2*tDB_1.^2-1480.7*tDB_1+5219.5;
Dball_2=0.9761*tDB_2.^4 -22.672*tDB_2.^3+254.2*tDB_2.^2-1480.7*tDB_2+5219.5;

% Downswing velocity comparison
% figure;plot(tWD,0.02855*WDownSwing./2,'LineWidth',2);
% hold on;plot(tID,0.02855*IDownSwing./2,'LineWidth',2);
% hold on;plot(tDD,0.02855*DDownSwing./2,'LineWidth',2);
% hold off;grid on;legend('Wedge','7-Iron','Driver');ylim([0 50])
% xlabel("Time (s)");ylabel("Velocity (m/s)");title("Club Downswing Velocity vs Time")
%% Closed Form Amplitude vs time expressions
w0=0.01;
wDownSwing= 1.268e+06*exp(-((tWD-0.2231)/0.01018).^2) + 1.223e+06*exp(-((tWD-0.2415)/0.006069).^2);
wBall_1=2.3e+08*exp(-18.44*tWB_1) + 5.77e+05*exp(-3.566*tWB_1);
wBall_2=3.341e+07*exp(-5.933*tWB_2) + 1.175e+05*exp(-0.2956*tWB_2);

i0=0.01;
iDownSwing=-2.336e+08*exp(-((tID-0.226)/0.007089).^2) + 2.34e+08*exp(-((tID-0.226)/0.007136).^2);
iBall_1=7.997e+07*exp(-14.9*tIB_1) + 1.503e+05*exp(-1.874*tIB_1);
iBall_2=1.01e+07*exp(-4.353*tIB_2) + 5.369e+04*exp(-0.0977*tIB_2);

d0=0.01;
dDownSwing =5.701e+06*exp(-((tDD-0.2141)/0.001708).^2) + 2.916e+06*exp(-((tDD-0.2191)/0.009985).^2);
dBall_1= 2.434e+10*exp(-41.53*tDB_1) + 1.132e+06*exp(-6.129*tDB_1);% Ball before gain
dBall_2 =1.071e5*exp(-1.492*tDB_2)+4.298e4*exp(-0.009711*tDB_2);% Ball after gain
% % Downswing amplitude comparison
% figure('Color',[1 1 1]);
% plot(tWD,wDownSwing,'LineWidth',2);hold on;
% plot(tID,iDownSwing,'LineWidth',2);hold on;
% plot(tDD,dDownSwing,'LineWidth',2);hold off;
% grid on;legend('Wedge','7-Iron','Driver');
% xlabel('Time (s)');ylabel('Amplitude');
%% Velocity vs Time plotting
% figure('Color',[1 1 1]);
% subplot(3,1,1)
% Dball=0.02855*[Dball_1 Dball_2]./2;
% plot(tD(1:end-1),Dball,'Color',[0 0 0.4],'LineWidth',2);
% hold on
% plot(tD(1:end-1),vD(1:end-1),'--k','LineWidth',2);xlabel("Time (s)");ylabel("Velocity (m/s)");
% ylim([0 80]);xlim([0 6.5]);legend('Empirical','EOM');grid on;
% hold off
% 
% subplot(3,1,2)
% % figure('Color',[1 1 1])
% Iball=0.02855*[Iball_1 Iball_2]./2;
% plot(tI(1:end-1),Iball,'Color',[0.1 0 0.9],'LineWidth',2);
% hold on
% plot(tI(1:end-1),vI(1:end-1),'--k','LineWidth',2);xlabel("Time (s)");ylabel("Velocity (m/s)");
% ylim([0 60]);xlim([0 5]);legend('Empirical','EOM');grid on;
% hold off
% 
% subplot(3,1,3)
% % figure('Color',[1 1 1])
% Wball=0.02855*[Wball_1 Wball_2]./2;
% plot(tW(1:end-1),Wball,'Color',[0 0.7 0.9],'LineWidth',2);
% hold on
% plot(tW(1:end-1),vW(1:end-1),'--k','LineWidth',2);xlabel("Time (s)");ylabel("Velocity (m/s)");
% ylim([0 40]);xlim([0 4.5]);legend('Empirical','EOM');grid on;
% hold off

Dc_error=sqrt(mse(Dball,vD(1:end-1)));
Ic_error=sqrt(mse(Iball,vI(1:end-1)));
Wc_error=sqrt(mse(Wball,vW(1:end-1)));

%% Frequency and Amplitude modulation
% fDopp=(2*vD(1:end-1)./cosd(10))./0.02855;
% 
% fDriver=cumsum(fDopp)/Fs;
% f0=cumsum(D0)/Fs;
% f1=cumsum(DDownSwing)/Fs;
% 
% x0 = d0*exp(1j*2*pi*f0);  
% x1 = dDownSwing.*exp(1j*2*pi*f1);  
% dBall=[dBall_1 dBall_2];
% xDriver=dBall.*exp(1j*2*pi*fDriver); 
% 
% x=[x0 x1 xDriver];
% t=[t0D tDD tDB_1 tDB_2];

%% Spectrogram plotting
% wlen = 400;                             %length of window                 
% overlap = wlen*0.5;                     %50 percent overlap                    
% nfft = wlen;                            %number of dft points                
% win = hann(wlen);                       %specifies type of window
% 
% figure;
% spectrogram(x,win,overlap,nfft,Fs,'MinThreshold',49,'yaxis'); %Spectrogram
% colormap jet;
