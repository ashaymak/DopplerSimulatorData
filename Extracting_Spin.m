close all;
% clear all; 
 
%% Load golf shot data
filename = 'Driver_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
GolfBallData = str2double(AllData{1});  %Data values has all the data values from the .txt file 
Fs=17000;                               %Sampling frequency
Ts=1/Fs;                                %Sampling period
t=0:Ts:((length(GolfBallData)-1)/Fs);

GolfBallDataUpSampled=interp(GolfBallData, 10);

Fs=170000;

%% We on that Spin Shit now
% WedgeBallSpin=GolfBallData(2000:6000);
% IronShotSpin=GolfBallData(6000:12000);
% DriverShotSpin=GolfBallData(4000:12000);

%% This is for messing around: Wedge Spin Check 
 
% % DSpin=GolfBallData(5100:5600);
% % ISpin=GolfBallData(5000:5100);
% WSpin=GolfBallData(5100:5200);% This is the one that was used 
%  WSpin=GolfBallData(5100:6000);
% % It seems as if maintaining the 100 sample size maintains the 168.32 while
% % increasing the samples forward in time
% 
% Y=fft(WSpin);
% 
% % figure;
% % stem(Y)
% Lw=length(WSpin);
% f = Fs*(0:(Lw/2))/Lw;
% 
% P2 = abs(Y/Lw);
% P1 = P2(1:1:Lw/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% % figure;plot(WSpin);
% 
% figure('Color',[1 1 1])
% stem(f,P1) 
% hold on
% % plot(f,P1,'b')
% title('Single-Sided Amplitude Spectrum of Wedge Spin')
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% xlim([1500 2500])
% hold on 
% stem1=stem(f(14),P1(14),'filled','b')
% datatip(stem1,'DataIndex',1,'Location','northwest');
% stem2=stem(f(15),P1(15),'filled','b')
% datatip(stem2,'DataIndex',1);
% stem3=stem(f(13),P1(13),'filled','b')
% grid on


%% Iron spin check
% ISpin=GolfBallDataUpSampled(47000:48500);
% ISpin=GolfBallDataUpSampled(47000:49500);
% % seems like perfect size is 150 samples for this one
% Y=fft(ISpin);
% 
% Li=length(ISpin);
% f = Fs*(0:(Li/2))/Li;
% 
% P2 = abs(Y/Li);
% P1 = P2(1:1:Li/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% 
% figure('Color',[1 1 1])
% stem(f,P1) 
% hold on
% stem(f(32),P1(32),'filled','b') 
% stem(f(31),P1(31),'filled','b') 
% stem(f(33),P1(33),'filled','b') 
% title('Single-Sided Amplitude Spectrum 7 Iron Spin')
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% xlim([2500 4500])
% grid on



%% Driver spin check
% DSpin=GolfBallData(5100:5600);
% DSpin=GolfBallData(4250:4420);
% DSpin=GolfBallDataUpSampled(525000:542000);
% DSpin=GolfBallData(5100:6000);
% DSpin=GolfBallDataUpSampled(42500:46200); %This one looks to be the best
% % DSpin=GolfBallDataUpSampled(42500:43000);
% % plot(GolfBallData)
% Y=fft(DSpin);
% 
% Ld=length(DSpin)-1;
% f = Fs*(0:(Ld/2))/Ld;
% 
% P2 = abs(Y/Ld);
% P1 = P2(1:Ld/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% 
% figure('Color',[1 1 1])
% stem(f,P1) 
% hold on
% stem(f(108),P1(108),'filled','b') 
% stem(f(107),P1(107),'filled','b') 
% stem(f(109),P1(109),'filled','b') 
% title('Single-Sided Spectrum of Driver Spin')
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% xlim([4500 5500])
% grid on


%% Spectrogram Testing 
% wlen =10;                          %length of window                 
% overlap = wlen*0.9;                 %50 percent overlap                    
% nfft = wlen;                        %number of dft points                
% win = kaiser(wlen,10);                   %specifies type of window
% Fs=17000;
% 
% figure;
% spectrogram(WSpin,win,overlap,nfft,Fs,'yaxis'); %Spectrogram using MATLAB function 
% view(0,90);colormap jet;



%% Generic Spin Test Loop
% Res=[];
% c=0;
% Fs=170000;
% for i = 1000:100:10000 % Going from freqeuncy resolution of 168 Hz to resolution of 42.5 Hz
% % Spin=GolfBallDataUpSampled(42500:42600+i);          %Driver  
% Spin=GolfBallDataUpSampled(47000:47000+i);          %Iron
% % Spin=GolfBallDataUpSampled(51000:51000+i);            %Wedge
% Y=fft(Spin);
% 
% Ld=length(Spin)-1;
% f = Fs*(0:(Ld/2))/Ld;
% 
% P2 = abs(Y/Ld);
% P1 = P2(1:Ld/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% [M,I]=max(P1);
% 
% ball_velocity=f(I);
% H_a=f(I-1);
% H_b=f(I+1);
% Res1=H_b-ball_velocity;
% 
% 
% if  Res1*60 > 8000 && Res1*60 < 12000
%   c=c+1;  
%   k=[Res1*60 1000+i*100]
% %   figure('Color',[1 1 1])
% %   stem(f,P1) 
% %   xlim([2500 4000])
% end
% 
% 
% % if P1(I+2)/P1(I) <= 0.5 && P1(I-2)/P1(I)<=0.5
% % 
% % ball_velocity=f(I);
% % H_a=f(I-1);
% % H_b=f(I+1);
% % Res1=H_b-ball_velocity;
% % Res=[Res Res1];
% % end
% 
%    
% end
% % Rotation_Final=[Res(end-2) Res(end-1) Res(end)] 
% 
% % xlim([1000 3000])

%% FM Demodulation Test
% Fs=17000;
% r_rate=1000;
% freqdev=2/(0.02885)*0.047*(r_rate/60)*2*pi;
% z=fmdemod(WSpin,ball_velocity,Fs,freqdev);
% 
% Y=fft(z);
% 
% Ld=length(z)-1;
% f = Fs*(0:(Ld/2))/Ld;
% 
% P2 = abs(Y/Ld);
% P1 = P2(1:Ld/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% figure('Color',[1 1 1])
% stem(f,P1) 

%% STFT test Wedge works well
% Spin=GolfBallData(5780:10000); 
% plot(Spin);
% wlen =1000;                              %length of window                 
% overlap = wlen*0.98;                    %50 percent overlap                    
% nfft = wlen;                            %number of dft points                
% win = kaiser(wlen,10);                   %specifies type of window
% Fs=17000;
% 
% figure('Color',[1 1 1]);
% 
% spectrogram(Spin,win,overlap,nfft,Fs,'MinThreshold',25,'yaxis'); %Spectrogram using MATLAB function 
% view(0,90);colormap bone;

%% STFT test Driver ????
Spin = GolfBallData(5700:10000); 
window = kaiser(length(Spin),200);
SpinW=Spin.*window;

% % plot(Spin);
% wlen =2000  ;                            %length of window                 
% overlap = wlen*0.5;                    %50 percent overlap                    
% nfft = wlen;                            %number of dft points                
% win = rectwin(wlen);                   %specifies type of window
% Fs=17000;
% 
% figure('Color',[1 1 1]);
% 
% [s,f,t,p]=spectrogram(Spin,win,overlap,nfft,Fs,'MinThreshold',10,'twosided'); %Spectrogram using MATLAB function 
% 
% % v=(flip(-f)*0.02885)/2;
% P=20*log10(abs(p));
% imagesc(t,f,P);
% axis xy; axis tight; colormap(jet); 
% xlabel("Time (s)")
% ylabel("Frequency (Hz)")
% ylim([4100 5000])
% colorbar;  % Abdul Gaffar 


%% Power Spectrum
% Fs=17000;figure;
% pspectrum(Spin,Fs,'Leakage',1,'OverlapPercent',50,'FrequencyResolution',8,'FrequencyLimits',[2400 5200],'MinThreshold',10,'spectrogram')
% colormap jet

% Fs=17000;figure;% These parameters work well for the wedge
% pspectrum(Spin,Fs,'Leakage',0.01,'FrequencyResolution',10,'FrequencyLimits',[1400 2500],'MinThreshold',10)


% Fs=17000;figure;% These parameters work well for the iron
% pspectrum(Spin,Fs,'Leakage',0.00001,'FrequencyResolution',10,'FrequencyLimits',[2800 3800],'MinThreshold',10)


Fs=17000;
% figure;
% pspectrum(SpinW,Fs,'Leakage',0.00001,'FrequencyResolution',8.4,'FrequencyLimits',[4000 5500],'MinThreshold',10)


Y=fft(Spin);

Ld=length(Spin)-1;
f = Fs*(0:(Ld/2))/Ld;

P2 = abs(Y/Ld);
P1 = P2(1:Ld/2+1);
P1(2:end-1) = 2*P1(2:end-1);


figure('Color',[1 1 1])
stem(f,P1) 
hold on

xlabel('Frequency (Hz)')
ylabel('Magnitude')
xlim([4500 5500])
grid on

% Fs=17000;figure;
% pspectrum(Spin,Fs,'Leakage',0.00000000001,'OverlapPercent',50,'FrequencyResolution',20,'FrequencyLimits',[2400 5200],'MinThreshold',10,'spectrogram')
% colormap jet
%% STFT method


% [s,f,t]=stft(WSpin,Fs);

