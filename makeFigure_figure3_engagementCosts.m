% Author: Susanne Schindler
% Date: 21.1.2019
% Copyright: Susanne Schindler (susanne.schindler2@web.de)

function makeFigure_figure3_engagementCosts

%% parameters
directory = '~/Forschung/Programme/OutgroupConflict_FawcettRadford/ProportionOfWarriorsIsSentOut/EffectParameter_ca_cd/Output/';
filename = 'mergedResults_effectParameter_ca_cd.mat';

%% load data
load([directory filename]);

%% exlude data when ca and cd are too high, i.e. at 0.1
excludeIndeces_ca01=find(caArray==0.1);
excludeIndeces_cd01=find(cdArray==0.1);
% remove double entries
excludeIndeces = unique([excludeIndeces_ca01 excludeIndeces_cd01]);

%% work with reduced data
meanW = meanWLevel;
meanW(excludeIndeces,:)=[];
meanA = meanALevel;
meanA(excludeIndeces,:)=[];
meanAttack = squeeze(meanAttackForce(:,:,end));
meanAttack(excludeIndeces,:) =[];
meanDefence = squeeze(meanDefenceForce(:,:,end));
meanDefence(excludeIndeces,:) =[];

%% create groups
caOrder=[repmat('ca1',3,1);repmat('ca2',3,1);repmat('ca3',3,1)];
cdOrder = repmat(['0.0125';'0.025 ';'0.05  '],3,1);
cdOrder2=[repmat('cd1',3,1);repmat('cd2',3,1);repmat('cd3',3,1)];
caOrder2 = repmat(['0.0125';'0.025 ';'0.05  '],3,1);

%% visualisation
figure;
%h(3)=subplot(2,2,2);
   b1=boxplot(meanW',{caOrder, cdOrder},'factorgap',10,'color','krb');
   set(b1(6,:),'LineWidth',3);               % change line width of median
   set(b1(7,[1 4 7]),'MarkerEdgeColor','k'); % change colors of outliers
   set(b1(7,[2 5 8]),'MarkerEdgeColor','r');
   set(b1(7,[3 6 9]),'MarkerEdgeColor','b');
   set(gca,'FontSize',18);
   ylabel('Mean w');
   xlabel('c_d')
   text(-0.25,1.05,'d','FontWeight','bold','FontSize',18);
   ylim([0 1]);
   text(1,1.05,'c_{d1}=0.0125','FontSize',18);
   text(5,1.05,'c_{d2}=0.025','FontSize',18);
   text(9,1.05,'c_{d3}=0.05','FontSize',18);
  
% h(3)=subplot(2,2,1);
%    b2=boxplot(meanW([1 4 7 2 5 8 3 6 9],:)',{cdOrder2, caOrder2},'factorgap',10,'color','kkkrrrbbb');
%    set(b2(6,:),'LineWidth',3);           % change line width of median
%    set(b2(7,1:3),'MarkerEdgeColor','k'); % change colors of outliers
%    set(b2(7,4:6),'MarkerEdgeColor','r');
%    set(b2(7,7:9),'MarkerEdgeColor','b');
%    set(gca,'FontSize',18);
%    ylabel('Mean w');
%    xlabel('c_a');
%    text(-0.27,1.05,'c','FontWeight','bold','FontSize',18);
%    ylim([0 1]);
%    text(1,1.05,'c_{d1}=0.0125','FontSize',18);
%    text(5,1.05,'c_{d2}=0.025','FontSize',18);
%    text(9,1.05,'c_{d3}=0.05','FontSize',18);

figure;
h(1)=subplot(1,2,1);
   b3=boxplot(meanAttack([1 4 7 2 5 8 3 6 9],:)',{cdOrder2, caOrder2},'factorgap',10,'color','kkkrrrbbb');
   set(b3(6,:),'LineWidth',3);           % change line width of median
   set(b3(7,1:3),'MarkerEdgeColor','k'); % change colors of outliers
   set(b3(7,4:6),'MarkerEdgeColor','r');
   set(b3(7,7:9),'MarkerEdgeColor','b');
   set(gca,'FontSize',18);
   ylabel('Mean attack force');
   xlabel('c_a');
   text(-0.25,1.05,'e','FontWeight','bold','FontSize',18);
   ylim([0 1]);
   text(1,1.05,'c_{a1}=0.0125','FontSize',18);
   text(5,1.05,'c_{a2}=0.025','FontSize',18);
   text(9,1.05,'c_{a3}=0.05','FontSize',18);
   
h(2)=subplot(1,2,2);
   b4=boxplot(meanDefence',{caOrder, cdOrder},'factorgap',10,'color','krb');
   set(b4(6,:),'LineWidth',3);           % change line width of median
   set(b4(7,[1 4 7]),'MarkerEdgeColor','k'); % change colors of outliers
   set(b4(7,[2 5 8]),'MarkerEdgeColor','r');
   set(b4(7,[3 6 9]),'MarkerEdgeColor','b');
   set(gca,'FontSize',18);
   ylabel('Mean defence force');
   xlabel('c_d');
   text(-0.25,1.05,'f','FontWeight','bold','FontSize',18);
   ylim([0 1]);
   text(1,1.05,'c_{d1}=0.0125','FontSize',18);
   text(5,1.05,'c_{d2}=0.025','FontSize',18);
   text(9,1.05,'c_{d3}=0.05','FontSize',18);

%pos = get(h,'Position');
%new = mean(cellfun(@(v)v(1),pos(1:2)));
%set(h(3),'Position',[new,pos{end}(2:end)]);
   
% subplot(3,2,5);
%    b5=boxplot(meanA',{caOrder, cdOrder},'factorgap',10,'color','krb');
%    set(b5(6,:),'LineWidth',3);               % change line width of median
%    set(b5(7,[1 4 7]),'MarkerEdgeColor','k'); % change colors of outliers
%    set(b5(7,[2 5 8]),'MarkerEdgeColor','r');
%    set(b5(7,[3 6 9]),'MarkerEdgeColor','b');
%    set(gca,'FontSize',18);
%    ylabel('Mean a');
%    text(-0.25,1.05,'e','FontWeight','bold','FontSize',18);
%    ylim([0 1]);
   
% subplot(3,2,6);
%    b6=boxplot(meanA([1 4 7 2 5 8 3 6 9],:)',{cdOrder2, caOrder2},'factorgap',10,'color','kkkrrrbbb');
%    set(b6(6,:),'LineWidth',3);           % change line width of median
%    set(b6(7,1:3),'MarkerEdgeColor','k'); % change colors of outliers
%    set(b6(7,4:6),'MarkerEdgeColor','r');
%    set(b6(7,7:9),'MarkerEdgeColor','b');
%    set(gca,'FontSize',18);
%    ylabel('Mean a');
%    text(-0.25,1.05,'f','FontWeight','bold','FontSize',18);
%    ylim([0 1]);
