% Author: Susanne Schindler
% Date: 20.11.2018
% Copyright: Susanne Schindler (susanne.schindler2@web.de)

function makeFigure_figure1()

% parameters
directory = '~/Forschung/Programme/OutgroupConflict_FawcettRadford/ProportionOfWarriorsIsSentOut/Output/';
% a randomly chosen simulation
filename1 = 'populationOverTime_longSim_7546919353100050314';
noAttractors=9;
simLengthToPlot = 100000;
blowUp_begin = 50100;
blowUp_end = blowUp_begin+6000;

% load a simulation
resultMat = load([directory filename1]);

% extract further parameters
noIterations = size(resultMat,1);
noIndividuals = (size(resultMat,2)-4)/6;

%% initialize matrices and accounting variables
attractor = nan(noIterations,1);
timeForTransition1to8 = 0;
timeForTransition8to1 = 0;
count1to8 = 0;
count8to1 = 0;

% re-write simulation results into arrays with meaningful names
WmeanVec = resultMat(:,6*noIndividuals+1);
AmeanVec = resultMat(:,6*noIndividuals+2);

%% SAVING EXERCISE FOR TIM FAWCETT
%% mat = [AmeanVec WmeanVec];
%% save('Output/forTim_meanA_vs_meanW_190228.txt','mat','-ascii', '-tabs');

% states
attractor((WmeanVec <= 0.35 & AmeanVec <= 0.35)) = 1;
attractor((WmeanVec <= 0.35 & (AmeanVec>0.35 & AmeanVec<=0.65))) = 2;
attractor((WmeanVec <= 0.35 &  AmeanVec>0.65)) = 3;
attractor(((WmeanVec > 0.35 & WmeanVec <= 0.65) & AmeanVec <= 0.35))  =4 ;
attractor(((WmeanVec > 0.35 & WmeanVec <= 0.65) & (AmeanVec>0.35 & AmeanVec<=0.65)))  =5;
attractor(((WmeanVec > 0.35 & WmeanVec <= 0.65) & AmeanVec > 0.65))  =6 ;
attractor((WmeanVec > 0.65 & AmeanVec <= 0.35)) = 7;
attractor(WmeanVec > 0.65 & (AmeanVec>0.35 & AmeanVec<=0.65)) = 8;
attractor((WmeanVec > 0.65 & AmeanVec > 0.65)) = 9;
  
for j=1:noAttractors
  % count time points for each state
  timeInEachAttractor(j) = sum(attractor==j)/noIterations;
end
disp([' ']);  
disp(['Time in each attractor']);
disp(['Defensive state: ' num2str(timeInEachAttractor(1)*100) '%']);
disp(['Armed state: ' num2str(timeInEachAttractor(8)*100) '%']);
disp(['State 3: ' num2str(timeInEachAttractor(3)*100) '%']);
disp(['Rest: ' num2str((1-sum(timeInEachAttractor([1 3 8])))*100) '%']);


%% prepare to get transition times
% identify switches (=changes in attractor)
attractorChanges = attractor(1:end-1)-attractor(2:end);
switchIndeces = find(attractorChanges ~=0);

attractorSwitches = nan(length(switchIndeces),2);
for sw=1:length(switchIndeces)
  attractorSwitches(sw,1) = attractor(switchIndeces(sw));
  attractorSwitches(sw,2) = attractor(switchIndeces(sw)+1);
end

  %% extract times to switch between certain states (here, we focus
  %% on 1 to 8 and back only)
  % extract entry times (first time in a state) and exit times
  % (last time in a state)
  entryTime1 = switchIndeces(find(attractorSwitches(:,2)==1))+1;
  exitTime1 = switchIndeces(find(attractorSwitches(:,1)==1));
  entryTime8 = switchIndeces(find(attractorSwitches(:,2)==8))+1;
  exitTime8 = switchIndeces(find(attractorSwitches(:,1)==8));
  % transition from 1 to 8
  lastIndex = nan;
  for j=1:length(entryTime8)
    % find latest time staying in 1 before being in state 8
    index = max(find(exitTime1 < entryTime8(j)));
    % only count transitions between 1 and 8 but not those 1-8-8
    % (some transitions into 8 in-between) 
    if index ~= lastIndex
      timeForTransition1to8 = timeForTransition1to8 + entryTime8(j)-exitTime1(index);
      count1to8 = count1to8 + 1;
      lastIndex = index;
    end
  end
  % transition from 8 to 1
  lastIndex = nan;
  for j=1:length(entryTime1)
    % find latest time staying in 1 before being in state 8
    index = max(find(exitTime8 < entryTime1(j)));
    % only count transitions between 8 and 1 but not those 8-1-1
    % (some transitions into 1 in-between) 
    if index ~= lastIndex
      timeForTransition8to1 = timeForTransition8to1 + entryTime1(j)-exitTime8(index);
      count8to1 = count8to1 + 1;
      lastIndex = index;
    end
  end

disp([' ']);  
disp(['Transition times']);
disp(['Mean time taken from defensive to armed state: ' num2str(timeForTransition1to8/count1to8)]);
disp(['Mean time taken from armed to defensive state: ' num2str(timeForTransition8to1/count8to1)]);
disp(['Factor: ' num2str((timeForTransition8to1/count8to1)/(timeForTransition1to8/count1to8))]);


%% TIME SERIES
figure;
   plot([WmeanVec(1:simLengthToPlot) AmeanVec(1:simLengthToPlot)],'LineWidth',2);
   set(gca,'FontSize',18);
   xlabel('Time');
   legend({'fighters','of which attack'},'Box','off','Orientation','horizontal');
   text(-7000,1.05,'a','FontSize',15,'FontWeight','bold');
figure;
   plot([WmeanVec(1:simLengthToPlot) AmeanVec(1:simLengthToPlot)],'LineWidth',2);
   rectangle('Position',[blowUp_begin -0.001 blowUp_end-blowUp_begin 1.002],'LineWidth',3);
   set(gca,'FontSize',18);
   xlabel('Time');
   ylim([-0.001 1.001]);
   legend({'fighters','of which attack'},'Box','off','Orientation','horizontal');
   text(-7000,1.05,'a','FontSize',15,'FontWeight','bold');

%% BLOW UP OF TIME SERIES
figure;
   plot(blowUp_begin:blowUp_end,[WmeanVec(blowUp_begin:blowUp_end) AmeanVec(blowUp_begin:blowUp_end)],'LineWidth',2);
   set(gca,'FontSize',18);
   xlabel('Time');
   legend({'fighters','of which attack'},'Box','off','Orientation','horizontal');
   xlim([blowUp_begin blowUp_end]);
   text(blowUp_begin-700,1.05,'c','FontSize',15,'FontWeight','bold');
   
   
%% DYNAMICS IN STATE SPACE
figureHandle = makeFigure_attractorNumbers;
   set(gca,'ydir','normal')
   colorbar('off');
   hold on;
   plot(AmeanVec(1:simLengthToPlot),WmeanVec(1:simLengthToPlot),'k');
   hold off;
   annotation('arrow',[0.3 0.23],[0.8 0.7],'Color','w','LineWidth',3)
   annotation('arrow',[0.35 0.47],[0.55 0.75],'Color','w','LineWidth',3)
   text(-0.1,1.05,'b','FontSize',15,'FontWeight','bold');


