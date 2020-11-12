close all;
%% Import dataset
filename = 'Wedge_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
WedgeData = str2double(AllData{1});  %Data values has all the data values from the .txt file 
t1=0:Ts:length(WedgeData)/Fs-Ts; 

%% Initial parameters
Fs=17000;                   %Sampling frequency
Ts=1/Fs;                    %Sampling Time

%% Time segmentation
t0=(0:3620)/Fs;             % Dead time before downswing        
tWD=(3621:4100)/Fs;         % Time for Wedge downswing
t01=(4101:4250)/Fs;         % Dead time after downswing
tWB_1=(4251:14499)/Fs;      % Time for Wedge ball before gain switch
tWB_2=(14500:76500)/Fs;     % Time for Wedge ball after gain switch

%% Frequency vs time expressions
spinfreq=168.32;           %spin rate specified in Hz

W0=zeros(1,length(t0));
WDownSwing=-1.868e+06*tWD.^2 + 9.068e+05*tWD -1.077e+05;
W01=zeros(1,length(t01));
Wball_1=2.963*tWB_1.^4 -35.81*tWB_1.^3 + 276.1*tWB_1.^2 -1127*tWB_1 + 2450;

h1t = Wball_1+spinfreq;     %First harmonic top
h1b = Wball_1-spinfreq;     %Fist harmonic bottom

Wball_2=2.963*tWB_2.^4 -35.81*tWB_2.^3 + 276.1*tWB_2.^2 -1127*tWB_2 + 2450;


%% Amplitude vs time expressions
w0=0.01;
wDownSwing= 1.268e+06*exp(-((tWD-0.2231)/0.01018).^2) + 1.223e+06*exp(-((tWD-0.2415)/0.006069).^2);
wBall_1=2.3e+08*exp(-18.44*tWB_1) + 5.77e+05*exp(-3.566*tWB_1);
wBall_2=3.341e+07*exp(-5.933*tWB_2) + 1.175e+05*exp(-0.2956*tWB_2);


%% Signal Generation
f0=cumsum(W0)/Fs;
f1=cumsum(WDownSwing)/Fs;
f01=cumsum(W01)/Fs;
f2=cumsum(Wball_1)/Fs;
f3=cumsum(Wball_2)/Fs;


f_h1t=cumsum(h1t)/Fs;
f_h1b=cumsum(h1b)/Fs;

x0 =w0*exp(-1j*2*pi*f0); 
x1 =wDownSwing.*exp(-1j*2*pi*f1); 
x01 =w0*exp(-1j*2*pi*f01); 
x2 =wBall_1.*exp(-1j*2*pi*f2); 
x_h1t=0.09*wBall_1.*exp(-1j*2*pi*f_h1t);
x_h1b=0.09*wBall_1.*exp(-1j*2*pi*f_h1b);
x_spin=x2+x_h1t+x_h1b;

x3 =wBall_2.*exp(-1j*2*pi*f3); 



%% Concatenate signals together
x_w=[x0 x1 x01 x_spin x3];
t_w=[t0 tWD t01 tWB_1 tWB_2];

%% Spectrogram Plot

wlen =700;                              %length of window                 
overlap = wlen*0.9;                     %percent overlap                    
nfft = wlen;                            %number of dft points                
win = hann(wlen);                       %specifies type of window
Fs=17000;


figure('Color',[1 1 1]);
[s,f,t1,p]=spectrogram(x_w,win,overlap,nfft,Fs,'MinThreshold',50,'twosided'); %Spectrogram
view(0,90);colormap jet;

v=(flip(-f)*0.02855)/2;     % Convert frequency axis to velocity

P=10*log10(abs(p));
imagesc(t1,(-v),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (s)")
ylabel("Radial Velocity (m/s)")
ylim([0 40]);
c=colorbar;
c.Label.String='Power/frequency (dB/Hz)';




%% Comparison of measured and generated time domain data

% figure('Color',[1 1 1]);
% 
% plot(t1(1:length(x)),WedgeData(1:length(x)),'Color',[0.6 0.6 0.6])
% hold on 
% plot(t,real(x),'Color',[0 0.7 0.9]); %Time Domain Signal
% xlabel("Time (s)");
% ylabel("Amplitude");grid on;
% legend("Measured","Synthetic")