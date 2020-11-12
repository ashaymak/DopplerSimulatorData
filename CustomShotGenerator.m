
close all
clear
%% Sampling Parameters
Fs=17000;
Ts=1/Fs;

%% Sample-time parameters
ta=3594;
tb=4100;
tc=tb+370;
td=110000;

t0=(0:ta)/Fs; % Change made here from Driver Final
tDS=(ta+1:tb)/Fs;
t01=(tb+1:tc)/Fs;
tB_1=(tc+1:14399)/Fs;
tB_2=(14400:td)/Fs;

Time=(length([tB_1 tB_2]))/Fs;

%% General Ball Parameters
p = 1.225;          %Air density at 15 degrees
D = 0.043 ;         %Diameter of Golf Ball around 4.3cm
R=D/2;              %Radius
m = 0.045;          %Mass of Golf Ball around 45 grams
g = 9.81;           %Acceleration Due to Gravity 
w = m*g;            %Weight of the Golf Ball 
A = pi*(R)^2;       %Cross Sectional area
k=(p*A)/(2*m);      %Constant for ease of implementation

%% Club paramters
thF=176;
thS=138;
thI=thS:(thF-thS)/(length(tDS)-1):thF;
aI=143:((180-143)/(length(thI)-1)):180;

lgI=0.94;   %length of club
rI=0.5;
dthI=27;
daI=3.5;
ddaI= 0;
ddthI=0;

%% Club Equations of motion

xI= -rI*sind(thI) + lgI*sind(thI+aI);
yI= rI*cosd(thI) - lgI*cosd(thI+aI);
VxI=-rI*cosd(thI)*dthI + lgI*cosd(thI+aI)*(dthI+daI);
VxI=VxI./cosd(10);
axI= rI*sind(thI)*dthI^2 -lgI*sind(thI+aI)*(dthI+daI)^2+lgI*cosd(thI+aI)*(ddaI+ddthI);
axI=axI./cosd(10);
tI= ((ta+1):((tb-(ta+1))/(length(thI)-1)):tb)/Fs;
% figure;plot(tDS,VxI)
%% Drag and Spin Parameters 
%Golf club linear acceleration between 1100 and 1800
% Club_acc=1400;
Cd = 0.2;   
Spin=5361;
launch_angle = 12;    
SF=1.4;
vi=50;

%% Projectile Parameters
vxi = vi*cosd(launch_angle)/cosd(10);    %Initial Velocity Resolved in x
vyi = vi*sind(launch_angle)/cosd(10);    %Initial Velocity Resolved in y

%% Instatiating Arrays Driver
n = Time*Fs;

xdisp = zeros(1, n+1);  %x-displacment Array
ydisp = zeros(1, n+1);  %y-displacment Array

v=zeros(1, n+1);
v(1)=vi;
vx = zeros(1, n+1);     %x-velocity Array
vx(1) = vxi;
vy = zeros(1, n+1);     %y-velocity Array
vy(1) = vyi;
ax=zeros(1, n+1);
ay=zeros(1, n+1);
Cl=zeros(1, n+1);
t = zeros(1, n+1);       %Time Array

%% Ball Iteration
dt = Ts;
i=1;

while i<n
    
  Cl(i)=1./(2+(v(i)./(R*Spin))) ;               %Equation From Ball Trajectories Literature
  ax(i)=-k*v(i).*(Cd*vx(i)+Cl(i).*vy(i));      %Equation From Ball Trajectories Literature
  ay(i)=k*v(i).*(Cl(i).*vx(i)-Cd*vy(i))-g;     %Equation From Ball Trajectories Literature
  vx(i+1)=vx(i)+ax(i)*dt;
  vy(i+1)=vy(i)+ay(i)*dt;
  xdisp(i+1)=xdisp(i)+vx(i)*dt+0.5*ax(i)*dt^2;
  ydisp(i+1)=ydisp(i)+vy(i)*dt+0.5*ay(i)*dt^2;
  if ydisp(i+1)<= 0
      ydisp(i+1)=0;
  end
  t(i+1)=t(i)+dt;
  v(i+1) = sqrt(vx(i).^2 + vy(i).^2);
  i=i+1;
  
end



%% Closed Form Amplitude vs time expressions
D0=zeros(1,length(t0));
D01=zeros(1,length(t01));
% DownSwing=Club_acc.*(tDS- tDS(length(tDS))) + vi/SF ;
% DownSwing=2.*(DownSwing)./0.02855;

d0=0.01;



AMP_DownSwing=-2.336e+08*exp(-((tDS-0.226)/0.007089).^2) + 2.34e+08*exp(-((tDS-0.226)/0.007136).^2);
AMP_Ball_1=7.997e+07*exp(-14.9*tB_1) + 1.503e+05*exp(-1.874*tB_1);
AMP_Ball_2=1.01e+07*exp(-4.353*tB_2) + 5.369e+04*exp(-0.0977*tB_2);


%% Frequency and Amplitude modulation

fDopp=(2*v(1:end-1)./cosd(10))./0.02855;
fclub=2*VxI./0.02855;



spinfreq=Spin/60;

h1t=fDopp(1:length(tB_1))+spinfreq;
h1b=fDopp(1:length(tB_1))-spinfreq;



fBall=cumsum(fDopp)/Fs;
f_h1t=cumsum(h1t)/Fs;
f_h1b=cumsum(h1b)/Fs;
 

f0=cumsum(D0)/Fs;
f1=cumsum(fclub)/Fs;
f01=cumsum(D01)/Fs;

x0 = d0*exp(-1j*2*pi*f0);  
x1 = AMP_DownSwing.*exp(-1j*2*pi*f1); 
x01 = d0*exp(-1j*2*pi*f01); 
aBall=[AMP_Ball_1 AMP_Ball_2];
xBall=aBall.*exp(-1j*2*pi*fBall);

%Spin harmonics
xh1t = 0.2*AMP_Ball_1.*exp(-1j*2*pi*f_h1t); 
xh1b = 0.2*AMP_Ball_1.*exp(-1j*2*pi*f_h1b); 


xCombined =xBall(1:length(tB_1))+xh1t+xh1b; 

x=[x0 x1 x01 xCombined xBall(length(tB_1)+1:end)];
t=[t0 tDS t01 tB_1 tB_2];


figure('Color',[1 1 1]);
subplot(2,1,1);
plot(t,real(x),'k');hold on;
plot(t,imag(x),'Color',[0.5 0 0.5]);hold off;
xlabel("Time (s)");
ylabel("Amplitude")
grid on;legend('I signal','Q signal')

%% Spectrogram plotting
wlen = 500;                             %length of window                 
overlap = wlen*0.5;                     %50 percent overlap                    
nfft = wlen;                            %number of dft points                
win = hann(wlen);                       %specifies type of window
Fs=17000;


subplot(2,1,2);
[s,f,ts,p]=spectrogram(x,win,overlap,nfft,Fs,'MinThreshold',60,'twosided'); %Spectrogram
% spectro_doppler(x,win,overlap,nfft,Fs,10);
v1=(flip(-f)*0.02855)/2;
P=10*log10(abs(p));
imagesc(ts,(-v1),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (s)")
ylabel("Radial Velocity (m/s)")
ylim([0 vi+20])
c=colorbar;
c.Label.String='Power/frequency (dB/Hz)'; 


%% Trajectory Plot

% figure('Color',[1 1 1]);plot3(xdisp(1:end-1),zeros(1,length(ydisp(1:end-1))),ydisp(1:end-1),'Color',[0.5 0 0.5],'LineWidth',2);grid on;
% xlabel('Range (m)');zlabel('Height (m)');ylabel('Position (m)');ylim([-0.2 0.2]);
%% Velocity vs Position Graph 
figure('Color',[1 1 1]);
plot(xdisp(1:end-1),ydisp(1:end-1),'Color',[0 0.4 0.6],'LineWidth',2);grid on;
hold on;
plot(xdisp(1:end-1),vx(1:end-1),'Color',[0.4 0 0.4],'LineWidth',2);grid on;
xlabel("Distance (m)");legend('Ball Trajectory','Ball Velocity (m/s)')

