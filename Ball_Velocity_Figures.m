close all;
clear all; 
 
%% Load golf shot data

Fs=17000;
Ts=1/Fs;
filename = 'Wedge_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
WedgeData = str2double(AllData{1});  %Data values has all the data values from the .txt file 
t1=0:Ts:length(WedgeData)/Fs-Ts; 

filename = '7_Iron_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
IronData = str2double(AllData{1});  %Data values has all the data values from the .txt file 
t2=0:Ts:length(IronData)/Fs-Ts; 

filename = 'Driver_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
DriverData = str2double(AllData{1});  %Data values has all the data values from the .txt file 
t3=0:Ts:length(DriverData)/Fs-Ts; 

l=0.02855;
%% Time Domain of Data
% figure('Color',[1 1 1]);
% subplot(3,1,1)
% plot(t1,WedgeData,'Color',[0 0.7 0.9]);
% xlabel("Time (s)")
% ylabel("Amplitude")
% grid on
% 
% subplot(3,1,2)
% plot(t2,IronData,'Color',[0.1 0 0.9]);
% xlabel("Time (s)")
% ylabel("Amplitude")
% grid on
% 
% subplot(3,1,3)
% plot(t3,DriverData,'Color',[0 0 0.4]);
% xlabel("Time (s)")
% ylabel("Amplitude")
% grid on

%% Time sample parameters

Fs=17000;                   %Sampling frequency 
t0W=(0:3559)/Fs;            % Deadtime before downswing       
tWD=0.216:((0.24-0.216)/Fs):0.24-((0.24-0.216)/Fs); % Time for Wedge downswing
tWB_1=(4201:14499)/Fs;      % Time for Wedge ball before gain switch
tWB_2=(14500:76500)/Fs;     % Time for Wedge ball after gain switch

t0D=(0:3594)/Fs; 
tDD=0.21:((0.234-0.21)/Fs):0.234-((0.234-0.21)/Fs);
tDB_1=(3936:14399)/Fs;
tDB_2=(14400:106054)/Fs;

t0I=(0:3603)/Fs;            % Deadtime before downswing     
tID=0.216:((0.234-0.216)/Fs):0.234-((0.234-0.216)/Fs);  % Time for 7 Iron downswing
tIB_1=(3996:14300)/Fs;      % Time for 7 Iron ball before gain switch
tIB_2=(14301:102000)/Fs;     % Time for 7 iron ball after gain switch


%% Closed Form Frequency vs time expressions
W0=zeros(1,length(t0W));
WDownSwing=-1.868e+06*tWD.^2 + 9.068e+05*tWD -1.077e+05;
Wball_1=2.963*tWB_1.^4 -35.81*tWB_1.^3 + 276.1*tWB_1.^2 -1127*tWB_1 + 2554;
Wball_2=2.963*tWB_2.^4 -35.81*tWB_2.^3 + 276.1*tWB_2.^2 -1127*tWB_2 + 2554;


IDownSwing=-2.857e+06*tID.^2 + 1.383e+06*tID -1.644e+05;
Iball_1=2.602*tIB_1.^4  -45.35*tIB_1.^3 + 353.3*tIB_1.^2 + -1526*tIB_1 + 4011;
Iball_2=2.602*tIB_2.^4  -45.35*tIB_2.^3 + 353.3*tIB_2.^2 + -1526*tIB_2 + 4011;


D0=zeros(1,length(t0D));
DDownSwing=-4.546e+06*tDD.^2 + 2.148e+06*tDD -2.506e+05;
Dball_1=0.9761*tDB_1.^4 -22.672*tDB_1.^3+254.2*tDB_1.^2-1480.7*tDB_1+5219.5;
Dball_2=0.9761*tDB_2.^4 -22.672*tDB_2.^3+254.2*tDB_2.^2-1480.7*tDB_2+5219.5;

%% Driver

% wlen =1000;                          %length of window                 
% overlap = wlen*0.9;                 %50 percent overlap                    
% nfft = wlen;                        %number of dft points                
% win = kaiser(wlen,10);                   %specifies type of window
% Fs=17000;
% 
% figure('Color',[1 1 1]);
% subplot(3,1,1)
% [~,f,t,p]=spectrogram(DriverData,win,overlap,nfft,Fs,'MinThreshold',40,'twosided');colormap jet;
% v=(flip(-f)*0.02855)/2;
% P=10*log10(abs(p));
% imagesc(t,(-v),P);
% axis xy; axis tight; colormap(jet); 
% xlabel("Time (s)")
% ylabel("Radial Velocity (m/s)")
% colorbar;ylim([0 80])
% [s,f,t,p]=spectrogram(DriverData,win,overlap,nfft,Fs,'MinThreshold',56,'yaxis');
% 
% f1 = f > 800;
% t1 = (0.4 < t) & (t < 6);
% m1 = medfreq(p(f1,t1),f(f1));
% hold on
% plot(t(t1),m1*l/2,'m','linewidth',4)
% hold on
% plot([tDB_1 tDB_2],[Dball_1 Dball_2].*l/2,'--k','linewidth',2.5)
% hold off;legend('Median Frequency Estimation','Fitted Model');

%% Iron
wlen =1000;                          %length of window                 
overlap = wlen*0.9;                 %50 percent overlap                    
nfft = wlen;                        %number of dft points                
win = kaiser(wlen,10);                   %specifies type of window
Fs=17000;

% subplot(3,1,2)
figure('Color',[1 1 1]);
[~,f,t,p]=spectrogram(IronData,win,overlap,nfft,Fs,'MinThreshold',40,'twosided');colormap jet;
v=(flip(-f)*0.02855)/2;
P=10*log10(abs(p));
imagesc(t,(f),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (s)")
% ylabel("Radial Velocity (m/s)")
ylabel("Frequency (Hz)")
c=colorbar;
c.Label.String='Power/frequency (dB/Hz)';
% ylim([0 60])
ylim([0 4000])
[s,f,t,p]=spectrogram(IronData,win,overlap,nfft,Fs,'MinThreshold',56,'yaxis');

f1 = f > 800;
t1 = (0.4 < t) & (t < 6);
m1 = medfreq(p(f1,t1),f(f1));
hold on
plot(t(t1),m1,'m','linewidth',3)
% hold on
% plot([tIB_1 tIB_2],[Iball_1 Iball_2].*l/2,'--k','linewidth',2.5)
hold off;%legend('Median Frequency Estimation','Fitted Model')
legend('Median Frequency Estimation')
% figure;% Ball after gain
tt=0.4:((6-0.4)/951):6-((6-0.4)/951);
% plot(tt,m1);

%% Wedge

% wlen =700;                          %length of window                 
% overlap = wlen*0.5;                 %50 percent overlap                    
% nfft = wlen;                        %number of dft points                
% win = kaiser(wlen,8);                   %specifies type of window
% Fs=17000;
% 
% subplot(3,1,3)
% [~,f,t,p]=spectrogram(WedgeData,win,overlap,nfft,Fs,'MinThreshold',40,'twosided');colormap jet;
% v=(flip(-f)*0.02855)/2;
% P=10*log10(abs(p));
% imagesc(t,(-v),P);
% axis xy; axis tight; colormap(jet); 
% xlabel("Time (s)")
% ylabel("Radial Velocity (m/s)")
% colorbar;ylim([0 40]);xlim([0 6])
% 
% [s,f,t,p]=spectrogram(WedgeData,win,overlap,nfft,Fs,'MinThreshold',56,'yaxis');
% 
% f1 = f > 500;
% t1 = (0.4 < t) & (t < 4);
% m1 = medfreq(p(f1,t1),f(f1));
% hold on
% plot(t(t1),m1*l/2,'m','linewidth',4)
% hold on
% plot([tWB_1(1+3000:end) tWB_2],[Wball_1(1+3000:end) Wball_2].*l/2,'--k','linewidth',2.5)
% hold off;legend('Median Frequency Estimation','Fitted Model')
% % figure;% Ball after gain
% tt=0.4:((6-0.4)/951):6-((6-0.4)/951);
% % plot(tt,m1);