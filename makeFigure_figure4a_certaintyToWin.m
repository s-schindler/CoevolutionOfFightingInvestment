% Author: Susanne Schindler
% Date: 3.12.2018
% Copyright: Susanne Schindler (susanne.schindler2@web.de)

function makeFigure_figure4a_certaintyToWin

%% parameters
directory = '~/Forschung/Programme/OutgroupConflict_FawcettRadford/ProportionOfWarriorsIsSentOut/EffectParameter_k/Output/';
filename = 'mergedResults_effectParameter_k.mat';

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

%% visualisation
figure;
   b=bar(squeeze(mean(new_timeInEachAttractor(:,:,:),2)),'stacked');
   %% assign colors (white, gray, black) to the three states
   b(1).FaceColor=[1 1 1];
   b(2).FaceColor=[0.5 0.5 0.5];
   b(3).FaceColor=[0 0 0];
   set(gca,'FontSize',18);
   set(gca,'XTickLabel',kArray)
   ylim([0 1]);
   xlabel('k');
   ylabel('Time spent');
   text(-1.1,1.05,'a','FontWeight','bold','FontSize',19);

