close all;

%% Load golf shot data: 
%Please change filename according to dataset being used, then uncomment the corresponding section below
filename = 'Driver_Shot.txt';
AllData = fileread(filename);
[~, beg_idx] = regexp(AllData,':'); % start extracting data after ':' character is found 
AllData = AllData(beg_idx+1:end);
AllData = textscan(AllData,'%s');
GolfBallData = str2double(AllData{1});  %Data values has all the data values from the .txt file 
Fs=17000;                               %Sampling frequency
Ts=1/Fs;                                %Sampling period
t=0:Ts:((length(GolfBallData)-1)/Fs);






%%  Wedge Spin Check 

% WSpin=GolfBallData(5100:5200);

% Y=fft(WSpin);

% Lw=length(WSpin);
% f = Fs*(0:(Lw/2))/Lw;

% P2 = abs(Y/Lw);
% P1 = P2(1:1:Lw/2+1);
% P1(2:end-1) = 2*P1(2:end-1);

% figure('Color',[1 1 1])
% stem(f,P1) 
% hold on
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
% ISpin=GolfBallData(4700:4950);
% Y=fft(ISpin);

% Li=length(ISpin);
% f = Fs*(0:(Li/2))/Li;

% P2 = abs(Y/Li);
% P1 = P2(1:1:Li/2+1);
% P1(2:end-1) = 2*P1(2:end-1);

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

% DSpin=GolfBallData(4250:4620); 

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


