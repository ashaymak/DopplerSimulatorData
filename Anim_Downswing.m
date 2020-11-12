
close all;

%% Positions

thD=[131:179]';
aD=[145:((180-145)/(length(thD)-1)):180]';

lgD=1.14;   %length of club
rD=0.5;
dthD=20.2;

xD= -rD*sind(thD) + lgD*sind(thD+aD);
yD= rD*cosd(thD) - lgD*cosd(thD+aD);

c=zeros(1,length(yD));
% [x, y] positions
pos0 =[zeros(length(thD),1),c', zeros(length(thD),1)+1.7];
pos1 =[-rD*sind(thD),c', rD*cosd(thD)+1.7]; 
pos2 =[xD,c' , yD+1.7];

%% Create Figure Handles
figure('Color',[1 1 1]);
axis([-2 2 -2 2 0 2])
grid on
hold on;

% The Links
h1 = line('Color', 'k','LineStyle','--', 'LineWidth', 2);
h2 = line('Color', 'k', 'LineWidth', 1);

% Mass plots
p0= plot3(pos0(1,1),pos0(1,2),pos0(1,3),'o','MarkerFaceColor','black','MarkerSize',5);
p1= plot3(pos1(1,1),pos1(1,2),pos1(1,3),'o','MarkerFaceColor','black','MarkerSize',8);
p2= plot3(pos2(1,1),pos2(1,2),pos2(1,3),'s','MarkerFaceColor','black','MarkerSize',10);
ball=plot3(0,0,pos2(end,3),'o','MarkerFaceColor','g','MarkerSize',5);
Club_Speed=plot3(pos2(:,1),pos2(:,2), pos2(:,3),'--','Color','b','MarkerFaceColor','black','MarkerSize',2);
view(0,9)

% general plot setup;
xlabel({'X Position (m)'},'FontSize',10,'FontName','AvantGarde');
zlabel({'Height (m)'},'FontSize',10,'FontName','AvantGarde');
ylabel('Position (m)')


% title({'Two Link Club Downswing'},'FontWeight','bold','FontSize',14,...
%     'FontName','AvantGarde');

%% Update the rod and masses in the plot in a loop
for i = 1:length(thD)
    % Rod
    
    set(h1, 'XData', [pos0(i,1), pos1(i,1)]);
    set(h1, 'YData', [pos0(i,2), pos1(i,2)]);
    set(h1, 'ZData', [pos0(i,3), pos1(i,3)]);
    
    set(h2, 'XData', [pos1(i,1), pos2(i,1)]);
    set(h2, 'YData', [pos1(i,2), pos2(i,2)]);
    set(h2, 'ZData', [pos1(i,3), pos2(i,3)]);


    % Mass Positions
    set(p0, 'XData', pos0(i,1));
    set(p0, 'YData', pos0(i,2));
    set(p0, 'ZData', pos0(i,3));
    
    set(p1, 'XData', pos1(i,1));
    set(p1, 'YData', pos1(i,2));
    set(p1, 'ZData', pos1(i,3));
    
    set(p2, 'XData', pos2(i,1));
    set(p2, 'YData', pos2(i,2));
    set(p2, 'ZData', pos2(i,3));
    
    pause(0.01);  
    drawnow 
   
    xlim('manual')
    ylim('manual')
end

