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


%% Amplitude Values
w0=0.01;
wDownSwing= 1.268e+06*exp(-((tWD-0.2231)/0.01018).^2) + 1.223e+06*exp(-((tWD-0.2415)/0.006069).^2);
wBall_1=2.3e+08*exp(-18.44*tWB_1) + 5.77e+05*exp(-3.566*tWB_1);
wBall_2=3.341e+07*exp(-5.933*tWB_2) + 1.175e+05*exp(-0.2956*tWB_2);

i0=0.01;
iDownSwing=-2.336e+08*exp(-((tID-0.226)/0.007089).^2) + 2.34e+08*exp(-((tID-0.226)/0.007136).^2);
iDownSwing=1.771e+06*exp(-((tID-0.232)/0.003336).^2) + 1.006e+06*exp(-((tID-0.2188)/0.006236).^2);
iBall_1=7.997e+07*exp(-14.9*tIB_1) + 1.503e+05*exp(-1.874*tIB_1);
iBall_2=1.01e+07*exp(-4.353*tIB_2) + 5.369e+04*exp(-0.0977*tIB_2);

d0=0.01;
dDownSwing =5.701e+06*exp(-((tDD-0.2141)/0.001708).^2) + 2.916e+06*exp(-((tDD-0.2191)/0.009985).^2);
dBall_1= 2.434e+10*exp(-41.53*tDB_1) + 1.132e+06*exp(-6.129*tDB_1);% Ball before gain
dBall_2 =1.071e5*exp(-1.492*tDB_2)+4.298e4*exp(-0.009711*tDB_2);% Ball after gain

% dBall_2 =649.7*exp(-2.948*tDB_2)+4.158e4*exp(-0.01919*tDB_2);% Ball after gain
% 
% figure;plot(tDB_2,dBall_21);hold on;plot(tDB_2,dBall_2);hold off
%% Downswing amplitude comparison
figure('Color',[1 1 1]);
subplot(3,1,1)
tW=0.216:((0.24-0.216)/408):0.24;%-((0.24-0.216)/408);
plot(tWD,wDownSwing,'Color',[0 0.7 0.9],'LineWidth',2);hold on;
plot(tW,WedgeData(3672:4080),'k');hold off;
grid on; xlabel('Time (s)');ylabel('Amplitude');xlim([0.215 0.244]);legend('Amplitude Model','Orignal Ball Data')

% figure('Color',[1 1 1]);
subplot(3,1,2)
tI=0.216:((0.234-0.216)/306):0.234;
plot(tID,iDownSwing,'Color',[0.1 0 0.9],'LineWidth',2);hold on;
plot(tI,IronData(3672:3978),'k');hold off;
grid on; xlabel('Time (s)');ylabel('Amplitude');xlim([0.215 0.235]);legend('Amplitude Model','Orignal Ball Data')

% figure('Color',[1 1 1]);
subplot(3,1,3)
tD=0.21:((0.232-0.21)/374):0.232;
plot(tDD(1:end-1500),dDownSwing(1:end-1500),'Color',[0 0 0.4],'LineWidth',2);hold on;
plot(tD,DriverData(3604:3978),'k');hold off;
grid on; xlabel('Time (s)');ylabel('Amplitude');xlim([0.21 0.235]);legend('Amplitude Model','Orignal Ball Data')


%% Ball Amplitude Comparison

figure('Color',[1 1 1]);
subplot(3,1,1)
plot(tWB_1,WedgeData(4201:14499),'Color',[0.6 0.6 0.6],'LineWidth',0.2);hold on;
plot(tWB_1,wBall_1,'Color',[0 0.7 0.9],'LineWidth',2);
plot(tWB_2,WedgeData(14500:76500),'Color',[0.6 0.6 0.6],'LineWidth',0.2);hold on;
plot(tWB_2,wBall_2,'Color',[0 0.7 0.9],'LineWidth',2);hold off;
grid on; xlabel('Time (s)');ylabel('Amplitude');legend('Orignal Ball Data','Amplitude Model');ylim([-4e6 4e6])


subplot(3,1,2)
plot(tIB_1,IronData(3996:14300),'Color',[0.6 0.6 0.6],'LineWidth',0.2);hold on;
plot(tIB_1,iBall_1,'Color',[0.1 0 0.9],'LineWidth',2);
plot(tIB_2,IronData(14301:85000),'Color',[0.6 0.6 0.6],'LineWidth',0.2);hold on;
plot(tIB_2,iBall_2,'Color',[0.1 0 0.9],'LineWidth',2);hold off;
grid on; xlabel('Time (s)');ylabel('Amplitude');legend('Orignal Ball Data','Amplitude Model');ylim([-4e6 4e6])


subplot(3,1,3)
plot(tDB_1,DriverData(3936:14399),'Color',[0.6 0.6 0.6],'LineWidth',0.2);hold on;
plot(tDB_1(1:end-51),dBall_1(1:end-51),'Color',[0 0 0.4],'LineWidth',1.5);
plot(tDB_2,DriverData(14400:106054),'Color',[0.6 0.6 0.6],'LineWidth',0.2);hold on;
plot(tDB_2,dBall_2,'Color',[0 0 0.4],'LineWidth',1.5);hold off;
grid on; xlabel('Time (s)');ylabel('Amplitude');legend('Orignal Ball Data','Amplitude Model');ylim([-3e6 3e6])




% plot(tID,iDownSwing,'LineWidth',2);hold on;
% plot(tDD,dDownSwing,'LineWidth',2);hold off;
% grid on;legend('Wedge','7-Iron','Driver');
% xlabel('Time (s)');ylabel('Amplitude');