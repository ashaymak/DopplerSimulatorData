close all;
%% Initial parameters
Fs=17000;
Ts=1/Fs;
%% Import dataset
filename = 'Driver_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
DriverData = str2double(AllData{1});  %Data values has all the data values from the .txt file 
t3=0:Ts:length(DriverData)/Fs-Ts; 


%% Time segmentation
t0=(0:3629)/Fs;             %Dead time before downswing
tDD=(3595:3935)/Fs;         %Time for Driver downswing
t01=(3936:4100)/Fs;         %Dead time after downswing
tDB_1=(4101:14399)/Fs;      %Time for Driver ball before gain switch
tDB_2=(14400:106054)/Fs;    %Time for Driver ball after gain switch


%% Frequency vs time expressions
spinfreq=45.96;         %spin rate specified in Hz

D0=zeros(1,length(t0));
DDownSwing=-4.546e+06*tDD.^2 + 2.148e+06*tDD -2.506e+05;
D01=zeros(1,length(t01));
Dball_1=0.9761*tDB_1.^4 -22.672*tDB_1.^3+254.2*tDB_1.^2-1480.7*tDB_1+5219.5;

h1t = Dball_1+spinfreq;     %First harmonic top
h1b = Dball_1-spinfreq;     %Fist harmonic bottom

Dball_2=0.9761*tDB_2.^4 -22.672*tDB_2.^3+254.2*tDB_2.^2-1480.7*tDB_2+5219.5;


%% Amplitude vs time expressions
d0=0.01;
dDownSwing =5.701e+06*exp(-((tDD-0.2141)/0.001708).^2) + 2.916e+06*exp(-((tDD-0.2191)/0.009985).^2);
dBall_1= 2.434e+10*exp(-41.53*tDB_1) + 1.132e+06*exp(-6.129*tDB_1);% Ball before gain
dBall_2 =1.071e5*exp(-1.492*tDB_2)+4.298e4*exp(-0.009711*tDB_2);% Ball after gain

%% Signal Generation

f0=cumsum(D0)/Fs;
f1=cumsum(DDownSwing)/Fs;
f01=cumsum(D01)/Fs;
f2=cumsum(Dball_1)/Fs;
f3=cumsum(Dball_2)/Fs;


f_h1t=cumsum(h1t)/Fs;
f_h1b=cumsum(h1b)/Fs;


x0 = d0*exp(-1j*2*pi*f0);  
x1 = dDownSwing.*exp(-1j*2*pi*f1);  

x01 = d0*exp(-1j*2*pi*f01);  

x2 = dBall_1.*exp(-1j*2*pi*f2);
x_h1t=0.3*dBall_1.*exp(-1j*2*pi*f_h1t);
x_h1b=0.3*dBall_1.*exp(-1j*2*pi*f_h1b);
x_spin=x2+x_h1t+x_h1b;

x3 = dBall_2.*exp(-1j*2*pi*f3); 

%% Concatenate signals together
x_d=[x0 x1 x01 x2 x3];
t_d=[t0 tDD t01 tDB_1 tDB_2];

%% Spectrogram Plot



wlen = 600;                             %length of window                 
overlap = wlen*0.9;                     %50 percent overlap                    
nfft = wlen;                            %number of dft points                
win = hann(wlen);                       %specifies type of window
Fs=17000;

figure('Color',[1 1 1]);
[s,f,t1,p]=spectrogram(x_d,win,overlap,nfft,Fs,'MinThreshold',50,'twosided'); 
view(0,90);colormap jet;

v=(flip(-f)*0.02855)/2;     % Convert frequency axis to velocity
P=10*log10(abs(p));
imagesc(t1,(-v),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (s)")
ylabel("Radial Velocity (m/s)")
ylim([0 80]);


c=colorbar;
c.Label.String='Power/frequency (dB/Hz)';


%% Comparison of measured and generated time domain data
% figure('Color',[1 1 1]);
% 
% plot(t3(1:length(x)),DriverData(1:length(x)),'Color',[0.6 0.6 0.6])
% hold on 
% plot(t,real(x),'Color',[0 0 0.4]); %Time Domain Signal
% xlabel("Time (s)");
% ylabel("Amplitude");grid on;
% legend("Measured","Synthetic")









