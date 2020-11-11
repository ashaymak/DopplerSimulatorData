close all;
clear all; 
 
%% Load golf shot data
filename = 'Wedge_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
WedgeData = str2double(AllData{1});  %Data values has all the data values from the .txt file 
                             
filename = '7_Iron_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
IronData = str2double(AllData{1});  %Data values has all the data values from the .txt file 

filename = 'Driver_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
DriverData = str2double(AllData{1});  %Data values has all the data values from the .txt file 

l=0.02855/2;
                             

%% Time sample parameters

Fs=17000;                   %Sampling frequency 
t0W=(0:3559)/Fs;            % Deadtime before downswing
% tWD=(3560:4200)/Fs;         % Time for Wedge downswing
tWD=0.216:((0.24-0.216)/Fs):0.24-((0.24-0.216)/Fs);
tWB_1=(4201:14499)/Fs;      % Time for Wedge ball before gain switch
tWB_2=(14500:76500)/Fs;     % Time for Wedge ball after gain switch

t0D=(0:3594)/Fs; % Change made here from Driver Final
% tDD=(3595:3935)/Fs;
tDD=0.21:((0.234-0.21)/Fs):0.234-((0.234-0.21)/Fs);
tDB_1=(3936:14399)/Fs;
tDB_2=(14400:106054)/Fs;

t0I=(0:3603)/Fs;            % Deadtime before downswing
% tID=(3604:3995)/Fs;         % Time for 7 Iron downswing
tID=0.216:((0.234-0.216)/Fs):0.234-((0.234-0.216)/Fs);
tIB_1=(3996:14300)/Fs;      % Time for 7 Iron ball before gain switch
tIB_2=(14301:85000)/Fs;     % Time for 7 iron ball after gain switch



%% Spectrogram of Club for Wedge
 
WedgeDownSwing=WedgeData(3400:4300);

wlen =300;                              %length of window                 
overlap = wlen*0.98;                    %50 percent overlap                    
nfft = wlen;                            %number of dft points                
win = kaiser(wlen,10);                   %specifies type of window
Fs=17000;

figure('Color',[1 1 1]);
% subplot(3,1,1)
[~,f,t,p]=spectrogram(WedgeDownSwing,win,overlap,nfft,Fs,'MinThreshold',60,'twosided');  
view(0,90);colormap jet;
v=(flip(-f)*0.02855)/2;
P=10*log10(abs(p));
imagesc((t+3400/Fs)*1000,(-v),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (ms)")
ylabel("Radial Velocity (m/s)")
c=colorbar;
c.Label.String='Power/frequency (dB/Hz)';
ylim([0 50])

hold on;

[s,f,t,p]=spectrogram(WedgeDownSwing,win,overlap,nfft,Fs,'MinThreshold',50,'yaxis');
 
f1 = (2000 < f) & (f < 3500);
f2=  (700 < f) & (f < 3500);
t1 = (0.033 < t) & (t < 0.04);
t2 = (0.016 < t) & (t < 0.033);
m1 = medfreq(p(f1,t1),f(f1));
m2 = medfreq(p(f2,t2),f(f2));
m3 = [m2 m1];

 tc = (0.016 < t) & (t < 0.04);
 mc=[m2 m1];

hold on
plot((t(tc)+3400/Fs)*1000,mc*l,'Color',[0.717647058823529 0.274509803921569 1],'linewidth',4)

hold on
 
tS= 0.216:((0.24-0.216)/68):0.24-((0.24-0.216)/68);
ttttt=0.016:((0.04-0.016)/68):0.04-((0.04-0.016)/68);
WSwing=-1.868e+06*tS.^2 + 9.068e+05*tS -1.077e+05;
plot((ttttt+3400/Fs)*1000,WSwing*l,'--k','LineWidth',4);legend('Median Frequency Estimate','Fitted Model')
hold off;


%% Spectrogram of Club for 7 Iron
 
IronDownSwing=IronData(3400:4300); 

wlen =300;                              %length of window                 
overlap = wlen*0.98;                    %50 percent overlap                    
nfft = wlen;                            %number of dft points                
win = kaiser(wlen,10);                  %specifies type of window
Fs=17000;

% subplot(3,1,2)
figure('Color',[1 1 1]);
[s,f,t,p]=spectrogram(IronDownSwing,win,overlap,nfft,Fs,'MinThreshold',70,'twosided');
v=(flip(-f)*0.02855)/2;
P=10*log10(abs(p));
imagesc((t+3400/Fs)*1000,(-v),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (ms)")
ylabel("Radial Velocity (m/s)")
c=colorbar;
c.Label.String='Power/frequency (dB/Hz)';
ylim([0 60])
view(0,90);colormap jet;

hold on;
[s,f,t,p]=spectrogram(IronDownSwing,win,overlap,nfft,Fs,'MinThreshold',50,'yaxis');

f1 = (2000 < f) & (f < 3500);
f2=  (700 < f) & (f < 3500);
t1 = (0.033 < t) & (t < 0.04);
t2 = (0.016 < t) & (t < 0.033);
m1 = medfreq(p(f1,t1),f(f1));
m2 = medfreq(p(f2,t2),f(f2));
m3 = [m2 m1];
 
hold on
tc = (0.016 < t) & (t < 0.04);
mc=[m2 m1];

plot((t(tc)+3400/Fs)*1000,mc*l,'Color',[0.717647058823529 0.274509803921569 1],'linewidth',4)

hold on

tS= 0.216:((0.24-0.216)/68):0.24-((0.24-0.216)/68);
ttttt=0.016:((0.04-0.016)/68):0.04-((0.04-0.016)/68);
ISwing=-2.857e+06*tS.^2 + 1.383e+06*tS -1.644e+05;
plot((ttttt+3400/Fs)*1000,ISwing*l,'--k','LineWidth',4);legend('Median Frequency Estimate','Fitted Model')
hold off;



%% Spectrogram of Club for Driver
DriverDownSwing=DriverData(3630:3980);
DriverDownSwing=DriverData(3400:4200);

wlen =300;                              %length of window                 
overlap = wlen*0.98;                    %50 percent overlap                    
nfft = wlen;                            %number of dft points                
win = kaiser(wlen,50);                  %specifies type of window
Fs=17000;

% subplot(3,1,3)
figure('Color',[1 1 1]);
[s,f,t,p]=spectrogram(DriverDownSwing,win,overlap,nfft,Fs,'MinThreshold',65,'twosided'); %Spectrogram using MATLAB function 
view(0,90);colormap jet;
v=(flip(-f)*0.02855)/2;
P=10*log10(abs(p));
imagesc((t+3400/Fs)*1000,(-v),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (ms)")
ylabel("Radial Velocity (m/s)")
c=colorbar;
c.Label.String='Power/frequency (dB/Hz)';
ylim([0 70])

hold on;
[s,f,t,p]=spectrogram(DriverDownSwing,win,overlap,nfft,Fs,'MinThreshold',50,'yaxis');
 f1 = (1000 < f) & (f < 5000);
 t1 = (0.012 < t) & (t < 0.034);
 m1 = medfreq(p(f1,t1),f(f1));
plot((t(t1)+3400/Fs)*1000,m1*l,'Color',[0.717647058823529 0.274509803921569 1],'linewidth',4)

tS= 0.213:((0.235-0.213)/62):0.235-((0.235-0.213)/62);
ttttt=0.012:((0.034-0.012)/62):0.034-((0.034-0.012)/62);
WSwing=-4.546e+06*tS.^2 + 2.148e+06*tS -2.506e+05;
plot((ttttt+3400/Fs)*1000,WSwing*l,'--k','LineWidth',5);
hold off; legend('Median Frequency Estimate','Fitted Model')
