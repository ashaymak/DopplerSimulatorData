close all;

filename = '7_Iron_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
IronData = str2double(AllData{1});  %Data values has all the data values from the .txt file 
t2=0:Ts:length(IronData)/Fs-Ts; 
%% Initial parameters
Fs=17000;
Ts=1/17000;

%% Sample-time parameters
t0=(0:3671)/Fs;             % Deadtime before downswing
tID=(3672:4080)/Fs;         % Time for 7 Iron downswing
t01=(4081:4160)/Fs;  
tIB_1=(4161:14300)/Fs;      % Time for 7 Iron ball before gain switch
tIB_2=(14301:85000)/Fs;     % Time for 7 iron ball after gain switch

%% Frequency vs time expressions
spinfreq=113.26;
I0=zeros(1,length(t0));
IDownSwing=-2.857e+06*tID.^2 + 1.383e+06*tID -1.644e+05;
I01=zeros(1,length(t01));
Iball_1=11.42*tIB_1.^4  -134.6*tIB_1.^3 + 669.2*tIB_1.^2 + -1975*tIB_1 + 4207;

h1t = Iball_1+spinfreq;
h1b = Iball_1-spinfreq;

Iball_2=11.42*tIB_2.^4  -134.6*tIB_2.^3 + 669.2*tIB_2.^2 + -1975*tIB_2 + 4207;

%% Amplitude vs time expressions
i0=0.01;
iDownSwing=-2.336e+08*exp(-((tID-0.226)/0.007089).^2) + 2.34e+08*exp(-((tID-0.226)/0.007136).^2);
iBall_1=7.997e+07*exp(-14.9*tIB_1) + 1.503e+05*exp(-1.874*tIB_1);
iBall_2=1.01e+07*exp(-4.353*tIB_2) + 5.369e+04*exp(-0.0977*tIB_2);
%% Signal Generation

f0=cumsum(I0)/Fs;
f1=cumsum(IDownSwing)/Fs;
f01=cumsum(I01)/Fs;
f2=cumsum(Iball_1)/Fs;
f3=cumsum(Iball_2)/Fs;


f_h1t=cumsum(h1t)/Fs;
f_h1b=cumsum(h1b)/Fs;


x0 =i0*exp(-1j*2*pi*f0); 
x1 =iDownSwing.*exp(-1j*2*pi*f1); 
x01 =i0*exp(-1j*2*pi*f01); 
x2 =iBall_1.*exp(-1j*2*pi*f2); 
x_h1t=0.2*iBall_1.*exp(-1j*2*pi*f_h1t);
x_h1b=0.2*iBall_1.*exp(-1j*2*pi*f_h1b);
x_spin=x2+x_h1t+x_h1b;
x3 =iBall_2.*exp(-1j*2*pi*f3); 

x_i=[x0 x1 x01 x_spin x3];
t_i=[t0 tID t01 tIB_1 tIB_2];


%% Time Domain and Spectrogram Plot

% wlen = 400;                             %length of window                 
% overlap = wlen*0.98;                     %50 percent overlap                    
% nfft = wlen;                            %number of dft points                
% win = kaiser(wlen,15);                  %specifies type of window
% Fs=17000;
% 
wlen = 600;                             %length of window                 
overlap = wlen*0.9;                     %50 percent overlap                    
nfft = wlen;                            %number of dft points                
win = hann(wlen);                       %specifies type of window
Fs=17000;


figure('Color',[1 1 1]);
% subplot(2,1,1)
% plot(t,imag(x),'k')
% hold on 
% plot(t,real(x),'Color',[0.1 0 0.9]); %Time Domain Signal
% xlabel("Time (s)");
% ylabel("Amplitude");grid on;
% legend("Quadrature","In phase")
% subplot(2,1,2); 
[s,f,t1,p]=spectrogram(x_i,win,overlap,nfft,Fs,'MinThreshold',50,'twosided'); %Spectrogram
view(0,90);colormap jet;
v=(flip(-f)*0.02855)/2;
P=10*log10(abs(p));
imagesc(t1,(-v),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (s)")
ylabel("Radial Velocity (m/s)")
ylim([0 70]);%xlim([200 270])
c=colorbar;
c.Label.String='Power/frequency (dB/Hz)';



%% Comparison of measured and generated time domain data
% figure('Color',[1 1 1]);
% 
% plot(t2(1:length(x)),IronData(1:length(x)),'Color',[0.6 0.6 0.6])
% hold on 
% plot(t,real(x),'Color',[0.1 0 0.9]); %Time Domain Signal
% xlabel("Time (s)");
% ylabel("Amplitude");grid on;
% legend("Measured","Synthetic")

