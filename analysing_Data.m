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
% subplot(1,3,1)
% plot(t1,WedgeData,'Color',[0 0.7 0.9]);
% xlabel("Time (s)")
% ylabel("Amplitude")
% grid on
% 
% subplot(1,3,2)
% plot(t2,IronData,'Color',[0.1 0 0.9]);
% xlabel("Time (s)")
% ylabel("Amplitude")
% grid on
% 
% subplot(1,3,3)
% plot(t3,DriverData,'Color',[0 0 0.4]);
% xlabel("Time (s)")
% ylabel("Amplitude")
% grid on


%% Driver
% 
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


%% Iron
% wlen =1000;                          %length of window                 
% overlap = wlen*0.9;                 %50 percent overlap                    
% nfft = wlen;                        %number of dft points                
% win = kaiser(wlen,10);                   %specifies type of window
% Fs=17000;
% 
% subplot(3,1,2)
% [~,f,t,p]=spectrogram(IronData,win,overlap,nfft,Fs,'MinThreshold',40,'twosided');colormap jet;
% v=(flip(-f)*0.02855)/2;
% P=10*log10(abs(p));
% imagesc(t,(-v),P);
% axis xy; axis tight; colormap(jet); 
% xlabel("Time (s)")
% ylabel("Radial Velocity (m/s)")
% colorbar;ylim([0 60])

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


%% Note: Spectrogram for club is modified for analysis of data
%% Spectrogram of Club for Wedge
 
WedgeDownSwing=WedgeData(3200:5000);

wlen =400;                              %length of window                 
overlap = wlen*0.98;                    %50 percent overlap                    
nfft = wlen;                            %number of dft points                
win = kaiser(wlen,15);                   %specifies type of window
Fs=17000;

figure('Color',[1 1 1]);
% subplot(3,1,1)
[~,f,t,p]=spectrogram(WedgeDownSwing,win,overlap,nfft,Fs,'MinThreshold',60,'twosided');  
view(0,90);colormap jet;
v=(flip(-f)*0.02855)/2;
P=10*log10(abs(p));
imagesc(t*1000+(3200/Fs)*1000,(-v),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (ms)")
ylabel("Radial Velocity (m/s)")
colorbar;ylim([0 50])

%% Spectrogram of Club for 7 Iron
 
IronDownSwing=IronData(3200:4800); 

wlen =400;                              %length of window                 
overlap = wlen*0.98;                    %50 percent overlap                    
nfft = wlen;                            %number of dft points                
win = kaiser(wlen,15);                  %specifies type of window
Fs=17000;

% subplot(3,1,2)
figure('Color',[1 1 1]);
[s,f,t,p]=spectrogram(IronDownSwing,win,overlap,nfft,Fs,'MinThreshold',70,'twosided');
v=(flip(-f)*0.02855)/2;
P=10*log10(abs(p));
imagesc(t*1000+(3200/Fs)*1000,(-v),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (ms)")
ylabel("Radial Velocity (m/s)")
colorbar;
ylim([0 60])
view(0,90);colormap jet;



%% Spectrogram of Club for Driver

DriverDownSwing=DriverData(3400:4800);

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
imagesc(t*1000+200,(-v),P);
axis xy; axis tight; colormap(jet); 
xlabel("Time (ms)")
ylabel("Radial Velocity (m/s)")
colorbar;ylim([0 80])

