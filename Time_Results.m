
% Please run Driver_Final.m, Iron_Final.m and Wedge_Final.m first, to store
% necessary variables in workspace
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


%% Comparison of measured and generated time domain data
figure('Color',[1 1 1]);

subplot(3,1,1)
plot(t3(1:length(x_d)),DriverData(1:length(x_d)),'Color',[0.6 0.6 0.6])
hold on 
plot(t_d,real(x_d),'Color',[0 0 0.4]); %Time Domain Signal
xlabel("Time (s)");
ylabel("Amplitude");grid on;
legend("Measured","Synthetic")


subplot(3,1,2)
plot(t2(1:length(x_i)),IronData(1:length(x_i)),'Color',[0.6 0.6 0.6])
hold on 
plot(t_i,real(x_i),'Color',[0.1 0 0.9]); %Time Domain Signal
xlabel("Time (s)");
ylabel("Amplitude");grid on;
legend("Measured","Synthetic")

subplot(3,1,3)
plot(t1(1:length(x_w)),WedgeData(1:length(x_w)),'Color',[0.6 0.6 0.6])
hold on 
plot(t_w,real(x_w),'Color',[0 0.7 0.9]); %Time Domain Signal
xlabel("Time (s)");
ylabel("Amplitude");grid on;
legend("Measured","Synthetic")