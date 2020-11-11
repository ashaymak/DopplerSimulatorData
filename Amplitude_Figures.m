close all;
% clear all; 
 
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
                             
                             

%%
Fs=17000;                   %Sampling frequency 
t0W=(0:3559)/Fs;            % Deadtime before downswing
% tWD=(3560:4200)/Fs;         % Time for Wedge downswing
tWD=0.216:((0.24-0.216)/Fs):0.24-((0.24-0.216)/Fs);
tWB_1=(4201:14499)/Fs;      % Time for Wedge ball before gain switch
tWB_2=(14500:76500)/Fs;     % Time for Wedge ball after gain switch

t0D=(0:3594)/Fs; % Change made here from Driver Final
% tDD=(3595:3935)/Fs;
tDD=0.212:((0.234-0.212)/Fs):0.234-((0.234-0.212)/Fs);
tDB_1=(3936:14399)/Fs;
tDB_2=(14400:106054)/Fs;

t0I=(0:3603)/Fs;            % Deadtime before downswing
% tID=(3604:3995)/Fs;         % Time for 7 Iron downswing
tID=0.216:((0.24-0.216)/Fs):0.24-((0.24-0.216)/Fs);
tIB_1=(3996:14300)/Fs;      % Time for 7 Iron ball before gain switch
tIB_2=(14301:85000)/Fs;     % Time for 7 iron ball after gain switch


%% Amplitude Values
w0=0.01;
wDownSwing= 1.268e+06*exp(-((tWD-0.2231)/0.01018).^2) + 1.223e+06*exp(-((tWD-0.2415)/0.006069).^2);
wBall_1=2.3e+08*exp(-18.44*tWB_1) + 5.77e+05*exp(-3.566*tWB_1);
wBall_2=3.341e+07*exp(-5.933*tWB_2) + 1.175e+05*exp(-0.2956*tWB_2);

i0=0.01;
iDownSwing=-2.336e+08*exp(-((tID-0.226)/0.007089).^2) + 2.34e+08*exp(-((tID-0.226)/0.007136).^2);
iBall_1=7.997e+07*exp(-14.9*tIB_1) + 1.503e+05*exp(-1.874*tIB_1);
iBall_2=1.01e+07*exp(-4.353*tIB_2) + 5.369e+04*exp(-0.0977*tIB_2);

d0=0.01;
dDownSwing =5.701e+06*exp(-((tDD-0.2141)/0.001708).^2) + 2.916e+06*exp(-((tDD-0.2191)/0.009985).^2);
dBall_1= 2.434e+10*exp(-41.53*tDB_1) + 1.132e+06*exp(-6.129*tDB_1);% Ball before gain
dBall_2 =1.071e5*exp(-1.492*tDB_2)+4.298e4*exp(-0.009711*tDB_2);% Ball after gain
% Downswing amplitude comparison
figure('Color',[1 1 1]);
plot(tWD,wDownSwing,'LineWidth',2);hold on;
plot(tID,iDownSwing,'LineWidth',2);hold on;
plot(tDD,dDownSwing,'LineWidth',2);hold off;
grid on;legend('Wedge','7-Iron','Driver');
xlabel('Time (s)');ylabel('Amplitude');