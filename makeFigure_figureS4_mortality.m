% Author: Susanne Schindler
% Date: 9.1.2019
% Copyright: Susanne Schindler (susanne.schindler2@web.de)

function makeFigure_figureS4_mortality

%% parameters
directory = '~/Forschung/Programme/OutgroupConflict_FawcettRadford/ProportionOfWarriorsIsSentOut/EffectParameter_mu/Output/';
filename = 'mergedResults_effectParameter_mu.mat';

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
   b=bar(muArray,squeeze(mean(new_timeInEachAttractor,2)),'stacked');
   %% assign colors (white, gray, black) to the three states
   b(1).FaceColor=[1 1 1];
   b(2).FaceColor=[0.5 0.5 0.5];
   b(3).FaceColor=[0 0 0];
   set(gca,'FontSize',18);
   ylim([0 1]);
   xlabel('\mu');
   ylabel('Time spent');
   text(-0.1,1,'a','FontWeight','bold','FontSize',18);
   myTicks = get(gca,'XTick');
   myTickMarks = get(gca,'XTickLabel');

figure;   
subplot(1,2,1);% mean w-level in last time step
   b1=boxplot(meanWLevel','Color','k','Labels',strread(num2str(muArray),'%s'),'Symbol','k+');
   set(b1(6,:),'LineWidth',3);
   set(gca,'FontSize',18,'XTickLabel',{'','','',myTicks(2),'','','',myTicks(3)});
   xlabel('\mu');
   ylabel('Mean w-level');
   text(-1,1.05,'b','FontWeight','bold','FontSize',18);
   ylim([-0.05 1.05]);
   
subplot(1,2,2);% mean a-level in last time step
   b2=boxplot(meanALevel','Color','k','Symbol','k+');
   set(b2(6,:),'LineWidth',3);
   set(gca,'FontSize',18,'XTickLabel',{'','','',myTicks(2),'','','',myTicks(3)});
   xlabel('\mu');
   ylabel('Mean a-level');
   text(-1,1.05,'c','FontWeight','bold','FontSize',18);
   ylim([-0.05 1.05]);

   
   
figure; % mean attack force in last time step
subplot(1,2,1);
   b3=boxplot(meanAttackForce(:,:,end)','Color','k','Labels',strread(num2str(muArray),'%s'),'Symbol','k+');
   set(b3(6,:),'LineWidth',3);
   set(gca,'FontSize',18,'XTickLabel',{'','','',myTicks(2),'','','',myTicks(3)});
   xlabel('\mu');
   ylabel('Mean attack force');
   text(-1,1.05,'d','FontWeight','bold','FontSize',18);
   ylim([-0.05 1.05]);

subplot(1,2,2);% mean defence force in last time step
   b3=boxplot(meanDefenceForce(:,:,end)','Color','k','Labels',strread(num2str(muArray),'%s'),'Symbol','k+');
   set(b3(6,:),'LineWidth',3);
   set(gca,'FontSize',18,'XTickLabel',{'','','',myTicks(2),'','','',myTicks(3)});
   xlabel('\mu');
   ylabel('Mean defence force');
   text(-1,1.05,'e','FontWeight','bold','FontSize',18);
   ylim([-0.05 1.05]);
