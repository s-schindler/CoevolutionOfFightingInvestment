% Author: Susanne Schindler
% Date: 12.2.2019
% Copyright: Susanne Schindler (susanne.schindler2@web.de)


% filenames 
directory = '/panfs/panasas01/bisc/ss16191/Forschung/Programme/OutgroupConflict_FawcettRadford/EffectParameter_cmu/Output/';
seedFilename = '../listOfRandomSeeds_100simulations';
filename = 'populationOverTime_cmu_';
outputFilename = 'mergedResults_effectParameter_cmu';

%% load list of seeds
fileID = fopen([directory seedFilename],'r');
seeds = textscan(fileID,'%s');
fclose(fileID);
noSimulationPerParameter = length(seeds{1});

%% parameters
noAttractors = 9;
cmuArray = 0.01:0.01:0.1;
stringInsets = {'001','002','003','004','005','006','007','008','009','01'};
noParameter = length(cmuArray);
aportCond = false;

%% load initial file to extract parameters
resultMat = load([string(strcat(directory,filename,stringInsets{1},'_',seeds{1}(1)))]);
lengthOfSimulations = size(resultMat,1);
noIndividuals = (size(resultMat,2)-4)/6;

%% initialize matrices
attractor = nan(noParameter,noSimulationPerParameter,lengthOfSimulations);
meanAttackForce = nan(noParameter,noSimulationPerParameter,lengthOfSimulations);
meanDefenceForce = nan(noParameter,noSimulationPerParameter,lengthOfSimulations);
meanWLevel = nan(noParameter,noSimulationPerParameter);
meanALevel = nan(noParameter,noSimulationPerParameter);
timeInEachAttractor = nan(noParameter,noSimulationPerParameter,noAttractors);
meanWLevelInAttractor = nan(noParameter,noSimulationPerParameter,noAttractors);
meanALevelInAttractor = nan(noParameter,noSimulationPerParameter,noAttractors);
% countCycleLength(1) counts 1-cycles
countCycleLength = zeros(noParameter,noSimulationPerParameter,lengthOfSimulations);
countsInBins = zeros(noParameter,noSimulationPerParameter,7);
meanStayInState = zeros(noParameter,noSimulationPerParameter,noAttractors);
countTransitionsBetweenStates = zeros(noParameter,noSimulationPerParameter,noAttractors,noAttractors);
totalNumberOfSwitches = zeros(noParameter,noSimulationPerParameter);
timeForTransition1to8 = zeros(noParameter,noSimulationPerParameter);
timeForTransition8to1 = zeros(noParameter,noSimulationPerParameter);
timeForTransition3to8 = zeros(noParameter,noSimulationPerParameter);
timeForTransition8to3 = zeros(noParameter,noSimulationPerParameter);
count1to8 = zeros(noParameter,noSimulationPerParameter);
count8to1 = zeros(noParameter,noSimulationPerParameter);
count3to8 = zeros(noParameter,noSimulationPerParameter);
count8to3 = zeros(noParameter,noSimulationPerParameter);

%% loop through each parameter value
for param =1:noParameter
  disp(['mu value = ' num2str(cmuArray(param))])
  %% loop through each output file and record mean(w) and mean(a)
  for i=1:noSimulationPerParameter
    disp(['Sim run = ' num2str(i)]);
  
    fn = string(strcat(directory,filename,stringInsets{param},'_',seeds{1}(i)));
    resultMat = load(fn);
  
    % check that simulation proceeded correctly to the end
    if lengthOfSimulations ~= size(resultMat,1)
      disp(['Simulation terminated unexpectantly.']);
      aportCond = true;
      break;
    end
    
    % extract mean attack force
    Warray = resultMat(:,1:noIndividuals);
    Aarray = resultMat(:,noIndividuals+1:2*noIndividuals);

    % extract mean attack and defence level
    meanAttackForce(param,i,:)  = resultMat(:,6*noIndividuals+3);
    meanDefenceForce(param,i,:) = resultMat(:,6*noIndividuals+4);

    % extract mean(w) and mean(a)
    WmeanVec = resultMat(:,6*noIndividuals+1)';
    AmeanVec = resultMat(:,6*noIndividuals+2)';

    % extract the mean w and a levels in the last time step
    meanWLevel(param,i) = WmeanVec(end);
    meanALevel(param,i) = AmeanVec(end);
    
    % extract in which attractor (or rather state) population was at each time point
    % we chunk the w-a-plane up into 9 separate areas 
    % 1) (w,a)=(<=0.35  , <=0.35) and 
    % 2) (w,a)=(<=0.35  , > 0.35 & <=0.65) and 
    % 3) (w,a)=(<=0.35  ,          > 0.65)
    % 4) (w,a)=(> 0.35 & <= 0.65  , <=0.35)
    % 5) (w,a)=(> 0.35 & <= 0.65  , > 0.35 & <=0.65)
    % 6) (w,a)=(> 0.35 & <= 0.65  ,          > 0.65)
    % 7) (w,a)=(>0.65,  <=0.35 )
    % 8) (w,a)=(>0.65,  > 0.35 & <= 0.65)
    % 9) (w,a)=(>0.65,           >  0.65)
    % then identify the periods in which the dynamics spends time in
    % each attractor 
    attractor(param,i,(WmeanVec <= 0.35 & AmeanVec <= 0.35)) = 1;
    attractor(param,i,(WmeanVec <= 0.35 & (AmeanVec>0.35 & AmeanVec<=0.65))) = 2;
    attractor(param,i,(WmeanVec <= 0.35 &  AmeanVec>0.65)) = 3;
    attractor(param,i,((WmeanVec > 0.35 & WmeanVec <= 0.65) & AmeanVec <= 0.35))  =4 ;
    attractor(param,i,((WmeanVec > 0.35 & WmeanVec <= 0.65) & (AmeanVec>0.35 & AmeanVec<=0.65)))  =5;
    attractor(param,i,((WmeanVec > 0.35 & WmeanVec <= 0.65) & AmeanVec > 0.65))  =6 ;
    attractor(param,i,(WmeanVec > 0.65 & AmeanVec <= 0.35)) = 7;
    attractor(param,i,WmeanVec > 0.65 & (AmeanVec>0.35 & AmeanVec<=0.65)) = 8;
    attractor(param,i,(WmeanVec > 0.65 & AmeanVec > 0.65)) = 9;
  
    for j=1:noAttractors
      % count time points for each state
      timeInEachAttractor(param,i,j) = sum(attractor(param,i,:)==j)/lengthOfSimulations;
      % record mean(w)-level in each attractor
      meanWLevelInAttractor(param,i,j) = mean(WmeanVec(attractor(param,i,:)==j));
      % record mean(w)-level in each attractor
      meanALevelInAttractor(param,i,j) = mean(AmeanVec(attractor(param,i,:)==j));
    end
  
    % identify switches (=changes in attractor)
    attractorChanges = squeeze(attractor(param,i,1:end-1)-attractor(param,i,2:end));
    switchIndeces = find(attractorChanges ~=0);
    totalNumberOfSwitches(param,i) = length(switchIndeces);
  
    %% record total time spent in each states/attractors
    % loop through switchIndeces and record length between switches
    for ind=1:length(switchIndeces)-1
      countCycleLength(param,i,switchIndeces(ind+1)-switchIndeces(ind)) = countCycleLength(param,i,switchIndeces(ind+1)-switchIndeces(ind))+1;
    end


    % hist-command uses too wide bins and bar-command uses too many
    % bins, therefore we need to collect our own statistic
    bins = {'<=10', '11-50','51-100','101-200','201-500','501-1000','>=1000'};
    countsInBins(param,i,1) = sum(countCycleLength(param,i,1:10));
    countsInBins(param,i,2) = sum(countCycleLength(param,i,11:50));
    countsInBins(param,i,3) = sum(countCycleLength(param,i,51:100));
    countsInBins(param,i,4) = sum(countCycleLength(param,i,101:200));
    countsInBins(param,i,5) = sum(countCycleLength(param,i,201:500));
    countsInBins(param,i,6) = sum(countCycleLength(param,i,501:1000));
    countsInBins(param,i,7) = sum(countCycleLength(param,i,1001:end));

    %% record time spent in each state without switch
    % initialize matrix, (i,j) says that dynamics stayed in state i
    % for j-times exactly (i,j)-times
    cycleLengthPerState = zeros(noAttractors,length(attractor));
    % first state (beginning of simulation)
    cycleLengthPerState(attractor(param,i,1),switchIndeces(1))=1;
    % all other states but last as we don't know how
    % long dynamics would have stayed in
    for k=2:length(switchIndeces)
      cycleLengthPerState(attractor(param,i,switchIndeces(k)),switchIndeces(k)-switchIndeces(k-1)) =cycleLengthPerState(attractor(param,i,switchIndeces(k)),switchIndeces(k)-switchIndeces(k-1))+1;
    end
    % find mean length of stay in each state
    for k=1:noAttractors
      % the following line multiplies the length of cycles
      % (find(cycleLengthPerState(k,:)~=0)) with how often they
      % occured (cycleLengthPerState(k,cycleLengthPerState(k,:)~=0))
      % and divides by the number of cycles
      % (sum(cycleLengthPerState(k,:) which is the same as length(switchIndeces))
      meanStayInState(param,i,k) = find(cycleLengthPerState(k,:)~=0)*cycleLengthPerState(k,cycleLengthPerState(k,:)~=0)'/sum(cycleLengthPerState(k,:));
    end

    % prepare to get transition probabilities between states
    attractorSwitches = nan(length(switchIndeces),2);
    for sw=1:length(switchIndeces)
      attractorSwitches(sw,1) = attractor(param,i,switchIndeces(sw));
      attractorSwitches(sw,2) = attractor(param,i,switchIndeces(sw)+1);
    end
  
    % count transitions
    for as=1:size(attractorSwitches,1)
      if sum(isnan(attractorSwitches(as,:)))==0 % ensure that
                                              % transitions are
                                              % between states not
                                              % to or from nan
	 countTransitionsBetweenStates(param,i,attractorSwitches(as,2),attractorSwitches(as,1)) = countTransitionsBetweenStates(param,i,attractorSwitches(as,2),attractorSwitches(as,1))+1;
      end
    end
  
  %% extract times to switch between certain states (here, we focus
  %% on 1 to 8 and back, and between 3 and 8 and back only)
  % extract entry times (first time in a state) and exit times
  % (last time in a state)
  entryTime1 = switchIndeces(find(attractorSwitches(:,2)==1))+1;
  exitTime1 = switchIndeces(find(attractorSwitches(:,1)==1));
  entryTime3 = switchIndeces(find(attractorSwitches(:,2)==3))+1;
  exitTime3 = switchIndeces(find(attractorSwitches(:,1)==3));
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
      timeForTransition1to8(param,i) = timeForTransition1to8(param,i) + entryTime8(j)-exitTime1(index);
      count1to8(param,i) = count1to8(param,i) + 1;
      % % for the first occurence record the path the dynamics took
      % if isnan(lastIndex)
      % 	path1to8_w(i,1:entryTime8(j)-exitTime1(index)+1) = WmeanVec(exitTime1(index):entryTime8(j));
      % 	path1to8_a(i,1:entryTime8(j)-exitTime1(index)+1) = AmeanVec(exitTime1(index):entryTime8(j));
      % end
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
      timeForTransition8to1(param,i) = timeForTransition8to1(param,i) + entryTime1(j)-exitTime8(index);
      count8to1(param,i) = count8to1(param,i) + 1;
      % % for the first occurence record the path the dynamics took
      % if isnan(lastIndex)
      % 	path8to1_w(i,1:entryTime1(j)-exitTime8(index)+1) = WmeanVec(exitTime8(index):entryTime1(j));
      % 	path8to1_a(i,1:entryTime1(j)-exitTime8(index)+1) = AmeanVec(exitTime8(index):entryTime1(j));
      % end
      lastIndex = index;
    end
  end
  % transition from 8 to 3
  lastIndex = nan;
  for j=1:length(entryTime3)
    index = max(find(exitTime8 < entryTime3(j)));
    % only count transitions between 8 and 3 but not those 8-3-3
    % (some transitions into 3 in-between) 
    if index ~= lastIndex
      timeForTransition8to3(param,i) = timeForTransition8to3(param,i) + entryTime3(j)-exitTime8(index);
      count8to3(param,i) = count8to3(param,i) + 1;
      % % for the first occurence record the path the dynamics took
      % if isnan(lastIndex)
      % 	path8to3_w(i,1:entryTime3(j)-exitTime8(index)+1) = WmeanVec(exitTime8(index):entryTime3(j));
      % 	path8to3_a(i,1:entryTime3(j)-exitTime8(index)+1) = AmeanVec(exitTime8(index):entryTime3(j));
      % end
      lastIndex = index;
    end
  end
  % transition from 3 to 8
  lastIndex = nan;
  for j=1:length(entryTime8)
    index = max(find(exitTime3 < entryTime8(j)));
    % only count transitions between 3 and 8 but not those 3-8-8
    % (some transitions into 8 in-between) 
    if index ~= lastIndex
      timeForTransition3to8(param,i) = timeForTransition3to8(param,i) + entryTime8(j)-exitTime3(index);
      count3to8(param,i) = count3to8(param,i) + 1;
      % % for the first occurence record the path the dynamics took
      % if isnan(lastIndex)
      % 	path3to8_w(i,1:entryTime8(j)-exitTime3(index)+1) = WmeanVec(exitTime3(index):entryTime8(j));
      % 	path3to8_a(i,1:entryTime8(j)-exitTime3(index)+1) = AmeanVec(exitTime3(index):entryTime8(j));
      % end
      lastIndex = index;
    end
  end

  if aportCond
    break;
  end
end
end 

  
%% save results
save([directory outputFilename],'noSimulationPerParameter','noIndividuals','lengthOfSimulations','noAttractors','timeInEachAttractor','meanWLevelInAttractor','meanALevelInAttractor','attractor','meanStayInState','countsInBins','bins','countCycleLength','countTransitionsBetweenStates','totalNumberOfSwitches','timeForTransition1to8','timeForTransition8to1','timeForTransition3to8','timeForTransition8to3','count1to8','count8to1','count3to8','count8to3','cmuArray','meanAttackForce','meanDefenceForce','meanWLevel','meanALevel');

