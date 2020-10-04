
close all;
% clear all; 
 
% Load golf shot data
filename = '7_Iron_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
GolfBallData = str2double(AllData{1});  % Data values has all the data values from the .txt file 
Fs=17000;                               %Sampling frequency
Ts=1/Fs;                                %Sampling period
t=0:Ts:((length(GolfBallData)-1)/Fs);

%% Investigating Upsampling
GolfBallDataUpSampled=interp(GolfBallData, 10);
figure;plot(GolfBallDataUpSampled)
%% Driver cuts
% DriverDownAmplitude=DriverDownAmplotude(1:end-10);
% figure; plot(GolfBallData); grid on; 
% DriverDownSwing=GolfBallData(3630:3980);% Driver downswing 
% DriverFollow=GolfBallData(4050:4305);
% DriverBallbGain=GolfBallData(4050+145:14300);
% figure; plot(DriverBallbGain); grid on;xlabel("Samples");ylabel("Amplitude");title("Measured Data")

%% 7 Iron Cuts
% IronDownSwing=GolfBallData(3400:4300);
% IronDownSwingAmplitude=GolfBallData(3604:3995);
% IronBallBeforeGain=GolfBallData(3995:14300);
% IronBallAfterGain=GolfBallData(14301:end);
% figure; plot(IronBallAfterGain); grid on;xlabel("Samples");ylabel("Amplitude");title("Measured Data")

%% Wedge Cuts
% WedgeDownSwing=GolfBallData(3560:4200);
% WedgeBallBeforeGain=GolfBallData(4201:14200);
% WedgeBallAfterGain=GolfBallData(14500:14500+26000);%Cut to avoid random spikes which affect fitting
% figure; plot(WedgeBallBeforeGain); grid on;xlabel("Samples");ylabel("Amplitude");title("Measured Data")

%% We on that Spin Shit now
% WedgeBallSpin=GolfBallData(2000:6000);
% IronShotSpin=GolfBallData(6000:12000);
% DriverShotSpin=GolfBallData(4000:12000);

%% This is for messing around
 DSpin=GolfBallData(5100:5600);
% ISpin=GolfBallData(5000:5100);
% WSpin=GolfBallData(3000:3200);
% figure;plot(DSpin);
% figure;stem(abs(fft((DSpin))));

%% Spectrogram Testing 
wlen =600;                          %length of window                 
overlap = wlen*0.5;                 %50 percent overlap                    
nfft = wlen;                        %number of dft points                
win = hann(wlen);                   %specifies type of window
Fs=17000;

figure;
subplot(2,1,1)
spectrogram(GolfBallData,win,overlap,nfft,Fs,'yaxis'); %Spectrogram using MATLAB function 
view(0,90);colormap jet;

wlen =600;                          %length of window                 
overlap = wlen*0.5;                 %50 percent overlap                    
nfft = wlen;                        %number of dft points                
win = hann(wlen);                   %specifies type of window
Fs1=17000*2;

subplot(2,1,2)
spectrogram(GolfBallDataUpSampled,win,overlap,nfft,Fs1,'yaxis'); %Spectrogram using MATLAB function 
view(0,90);colormap jet;

%% Code to get frequency vs time shape
% [s,f,t,p]=spectrogram(GolfBallData,win,overlap,nfft,Fs,'MinThreshold',60,'yaxis');
% 
% f1 = f > 800;
% t1 = (0.4 < t) & (t < 3.8);
% m1 = medfreq(p(f1,t1),f(f1));
% hold on
% plot(t(t1),m1/1000,'linewidth',4)
% hold off
% figure;% Ball after gain
% tt=0.4:((3.8-0.4)/113):3.8-((3.8-0.4)/113);
% plot(tt,m1);


%% 7 iron ball flight modelling
% figure;% Ball after gain
% tt=0.82:((3.5-0.82)/89):3.5-((3.5-0.82)/89);
% plot(tt,m1);



%% Other stuff that needs sorting
% 
% %Driver after gain switch amplitude
% % Driver_a = 5451.6*t.^6 - 133928*t.^5 + 1e6*t.^4 - 7e6*t.^3 + 2e7*t.^2 - 3e7*t + 2e07;
% 
% % wlen = 200;                        %length of window                 
% % overlap = wlen*0.98;                 %50 percent overlap                    
% % nfft = wlen;                        %number of dft points                
% % win = hann(wlen);                   %specifies type of window
% % Fs=17000;
% % figure;
% % spectrogram(BallData,win,overlap,nfft,Fs,'MinThreshold',90,'yaxis'); %Spectrogram using MATLAB function 
% % view(0,90);colormap jet
% % 54 was the perfect minumum threshold for the Driver
% % [s,f,t,p]=spectrogram(BallData,win,overlap,nfft,Fs,'MinThreshold',20,'yaxis');
% % d=max(abs(s));
% 
% 
% 
% %d=d(3:end);
% 
% 
% 
% % figure;plot(t,d);xlabel('Time (s)');ylabel('Amplitude');
% 
% % f1 = f > 1300;
% % t1 = (0.9 < t) & (t < 6);
% 
% % m1 = medfreq(p(f1,t1),f(f1));
% % hold on
% % plot(t(t1),m1/1000,'linewidth',4)
% % hold off
% % k=t(t1);
% 
% %Driver frequency piecewise function
% Fs=17000;
% t0=(0:3594)/Fs;
% t1=(3595:3935)/Fs;
% tz=(3936:4053)/Fs;
% t2=(4054:4275)/Fs;
% t3=(4054:106054)/Fs;
% D0=NaN(1,length(t0));
% Dz=NaN(1,length(tz));
% 
% D1=110000*t1-22265;% Downswing relative to main time
% Dzz=110000*tz-22265;
% 
% 
% % D1 = chirp(t1,1000,0.02,3200);
% % 
% %       t=0:0.001:2;                    % 2 secs @ 1kHz sample rate
% %       y=chirp(t,0,1,150);             % Start @ DC, cross 150Hz at t=1sec
% %       spectrogram(y,256,250,256,1E3); % Display the spectrogram
% 
% 
% D2=-184615.385*t2+47030.77;% Follow through relative to main time
% D3=0.9761*t3.^4 -22.672*t3.^3+254.2*t3.^2-1480.7*t3+5219.5;% Ball profile relative to main time
% t=(0:106054)/Fs;
% D=[D0 D1 Dz D3];
% 
% 
% f1=cumsum(D1)/Fs;
% x1 = exp(1j*2*pi*f1);  
% f2=cumsum(D2)/Fs;
% x2 = exp(1j*2*pi*f2); 
% f3=cumsum(D3)/Fs;
% x3 = exp(1j*2*pi*f3); 
% 
% 
% D=[D1 Dzz D3];
% x=[x1 x2 x3];
% t=[t1 tz t3];
% % plot(t,D)
% D_a=1.071e5*exp(-1.492*t)+4.298e4*exp(-0.009711*t);
% ff=cumsum(D)/Fs;
% xx = D_a.*exp(1j*2*pi*ff); 
% plot(t,xx)
% 
% % Try using amplitude to create dicontinuous function
% 
% %Driver amplitude piecewise function
% 
% 
% 
% % % Driver after gain switch amplitude
% % Driver_a = 5451.6*t.^6 - 133928*t.^5 + 1e6*t.^4 - 7e6*t.^3 + 2e7*t.^2 - 3e7*t + 2e7;
% % 
% % D_a=1.071e5*exp(-1.492*t)+4.298e4*exp(-0.009711*t);
% % y=0.9761*t.^4 -22.672*t.^3+254.2*t.^2-1480.7*t+5219.5;
%  
% % int_fd=cumsum(D)/Fs;
% % x = exp(1j*2*pi*int_fd);  
% % figure;plot(t,x)
% 
% 
% wlen = 1000;                        %length of window                 
% overlap = wlen*0.98;                %50 percent overlap                    
% nfft = 200;                        %number of dft points                
% win = hann(wlen);                   %specifies type of window
% Fs=17000;
% figure;
% spectrogram(xx,win,overlap,nfft,Fs,'MinThreshold',20,'yaxis'); %Spectrogram using MATLAB function 
% view(0,90);colormap jet;


