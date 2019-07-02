% Author: Susanne Schindler
% Date: 16.1.2019
% Copyright: Susanne Schindler (susanne.schindler2@web.de)

function makeFigure_figure4bToC_homeAdvantage

%% parameters
directory = '~/Forschung/Programme/OutgroupConflict_FawcettRadford/ProportionOfWarriorsIsSentOut/WithHomeAdvantage/Output/';
filename = 'mergedResults_effectParameter_homeAdvantage.mat';

%% load data
load([directory filename]);



%% visualisation
figure;
% get label array and weed it out
myLabelArray = strread(num2str(hArray),'%s');
myLabelArray(2:2:end)={' '};
subplot(1,2,1);
   rectangle('Position',[11.5 0 1 1],'FaceColor',[1 0.6 0.6],'EdgeColor',[1 0.6 0.6]);
   hold on;
   b1=boxplot(squeeze(meanAttackForce(:,:,end))','Color','k','Labels',myLabelArray,'Symbol','k+');
   hold off;
   set(b1(6,:),'LineWidth',3);
   set(gca,'FontSize',18);
   ylabel('Mean attack force');
   xlabel('h');
   ylim([0 1]);
   text(-1,1.05,'b','FontWeight','bold','FontSize',19);
subplot(1,2,2);
    rectangle('Position',[4.5 0 6 1],'FaceColor',[0 0.9 0.4],'EdgeColor',[0 0.9 0.4]);
    hold on;
    b2=boxplot(squeeze(meanDefenceForce(:,:,end))','Color','k','Labels',myLabelArray,'Symbol','k+');
    hold off;
    set(b2(6,:),'LineWidth',3);
    set(gca,'FontSize',18);
    ylabel('Mean defence force');
    xlabel('h');
    ylim([0 1]);
    text(-1,1.05,'c','FontWeight','bold','FontSize',19);


