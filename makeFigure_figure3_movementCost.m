% Author: Susanne Schindler
% Date: 3.12.2018
% Copyright: Susanne Schindler (susanne.schindler2@web.de)

function makeFigure_figure3_movementCost

%% parameters
directory = '~/Forschung/Programme/OutgroupConflict_FawcettRadford/ProportionOfWarriorsIsSentOut/EffectParameter_cm/Output/';
filename = 'mergedResults_effectParameter_cm.mat';

%% load data
load([directory filename]);

%% Re-classification
% model output is classified in nine different states, we are only
% interested into state 1 and state 8, so we'll re-classify states
% 2,3,4,5,6,7,9 as state 4.5

new_timeInEachAttractor = nan(size(timeInEachAttractor,1),size(timeInEachAttractor,2),3);
% time spent in state 1
new_timeInEachAttractor(:,:,1) = timeInEachAttractor(:,:,1);
% time spent in state 8
new_timeInEachAttractor(:,:,3) = timeInEachAttractor(:,:,8);
% time spent in all other states
new_timeInEachAttractor(:,:,2) = sum(timeInEachAttractor(:,:,2:7),3)+timeInEachAttractor(:,:,9);





figure;
% time spent in each state
   b=bar(cmArray,squeeze(mean(new_timeInEachAttractor,2)),'stacked');
   %% assign colors (white, gray, black) to the three states
   b(1).FaceColor=[1 1 1];
   b(2).FaceColor=[0.5 0.5 0.5];
   b(3).FaceColor=[0 0 0];
   set(gca,'FontSize',18);
   ylim([0 1]);
   xlabel('c_m');
   ylabel('Time spent');
   text(-0.02,1.05,'b','FontWeight','bold','FontSize',18);
   ticks=get(gca,'XTickLabel');
   
figure; 
   b=boxplot(squeeze(meanAttackForce(:,:,end))','Color','k','Labels',strread(num2str(cmArray),'%s'),'Symbol','k+');
   set(b(6,:),'LineWidth',3);
   myTicks = {' ','0.02',' ','0.04',' ','0.06',' ','0.08',' ','0.1'};
   set(gca,'FontSize',18,'XTickLabel',myTicks);
   xlabel('c_m');
   ylabel('Mean attack force');
   text(-0.75,1.125,'c','FontWeight','bold','FontSize',18);
   ylim([-0.05 1.05]);
 
   
% figure; % mean attack force in last time step
%    means = mean(meanAttackForce(:,:,end),2);
%    stds = nan(length(cmArray),1);
%    for i=1:length(cmArray)
%      stds(i) = std(meanAttackForce(i,:,end));
%    end
%    errorbar(cmArray,means,stds,'ko','LineWidth',2);
%    set(gca,'FontSize',18);
%    xlabel('c_m');
%    ylabel('Mean attack force');
%    text(-0.02,1.05,'c','FontWeight','bold');
%    ylim([0 1]);
   
