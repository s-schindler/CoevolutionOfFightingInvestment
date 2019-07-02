% Author: Susanne Schindler
% Date: 6.9.2018
% Copyright: Susanne Schindler (susanne.schindler2@web.de)


% filenames 
directory = '/panfs/panasas01/bisc/ss16191/Forschung/Programme/OutgroupConflict_FawcettRadford/Output/';
seedFilename = '../listOfRandomSeeds_100simulations';
filename = 'populationOverTime';
outputFilename = 'mergedResults_100longSimulations';

%% load list of seeds
fileID = fopen([directory seedFilename],'r');
seeds = textscan(fileID,'%s');
fclose(fileID);
noSimulations = length(seeds{1});

%% parameters
noAttractors = 9;
aportCond = false;

%% load initial file to extract parameters
resultMat = load([string(strcat(directory,filename,'_',seeds{1}(1)))]);
lengthOfSimulations = size(resultMat,1);
noIndividuals = (size(resultMat,2)-4)/6;

%% initialize matrices
attractor = nan(noSimulations,lengthOfSimulations);
attractor2 = nan(noSimulations,lengthOfSimulations); % partitioning
                                                     % on whether
                                                     % above or
                                                     % below w=0.5
timeInEachAttractor = nan(noSimulations,noAttractors);
attackForce = nan(noSimulations,lengthOfSimulations);
defenceForce = nan(noSimulations,lengthOfSimulations);
meanWLevelInAttractor = nan(noSimulations,noAttractors);
meanALevelInAttractor = nan(noSimulations,noAttractors);
% countCycleLength(1) counts 1-cycles
countCycleLength = zeros(noSimulations,lengthOfSimulations);
countsInBins = zeros(noSimulations,noAttractors);
meanStayInState = zeros(noSimulations,noAttractors);
countCyclesPerState = zeros(noSimulations,noAttractors);
countTransitionsBetweenStates = zeros(noSimulations,noAttractors,noAttractors);
transitions = zeros(noSimulations,noAttractors,noAttractors);
totalNumberOfSwitches = zeros(1,noSimulations);
timeForTransition1to8 = zeros(noSimulations,1);
timeForTransition8to1 = zeros(noSimulations,1);
timeForTransition3to8 = zeros(noSimulations,1);
timeForTransition8to3 = zeros(noSimulations,1);
count1to8 = zeros(noSimulations,1);
count8to1 = zeros(noSimulations,1);
count3to8 = zeros(noSimulations,1);
count8to3 = zeros(noSimulations,1);
path1to8_w = nan(noSimulations,lengthOfSimulations);
path1to8_a = nan(noSimulations,lengthOfSimulations);
path3to8_w = nan(noSimulations,lengthOfSimulations);
path3to8_a = nan(noSimulations,lengthOfSimulations);
path8to1_w = nan(noSimulations,lengthOfSimulations);
path8to1_a = nan(noSimulations,lengthOfSimulations);
path8to3_w = nan(noSimulations,lengthOfSimulations);
path8to3_a = nan(noSimulations,lengthOfSimulations);



%% loop through each output file and record mean(w) and mean(a)
for i=1:noSimulations
  disp(num2str(i));
  
  clear('resultMat');
  fn = string(strcat(directory,filename,'_',seeds{1}(i)));
  resultMat = load(fn);

  % check that simulation proceeded correctly to the end
  if lengthOfSimulations ~= size(resultMat,1)
    disp(['Simulation terminated unexpectantly.']);
    aportCond = true;
    break;
  end

  % extract mean(w) and mean(a)
  WmeanVec = resultMat(:,6*noIndividuals+1)';
  AmeanVec = resultMat(:,6*noIndividuals+2)';

  % extract attack and defence force
  attackForce(i,:) =  resultMat(:,6*noIndividuals+3);
  defenceForce(i,:) = resultMat(:,6*noIndividuals+4);
  
  % extract in which attractor (or rather state) population was at each time point
  % we chunk the w-a-plane up into 2 separate areas 
  % 1) w<=0.5 and 
  % 2) w> 0.5
  % then identify the periods in which the dynamics spends time in
  % each attractor 
  attractor2(i,(WmeanVec <= 0.5)) = 1;
  attractor2(i,(WmeanVec > 0.5)) = 2;

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
  attractor(i,(WmeanVec <= 0.35 & AmeanVec <= 0.35)) = 1;
  attractor(i,(WmeanVec <= 0.35 & (AmeanVec>0.35 & AmeanVec<=0.65))) = 2;
  attractor(i,(WmeanVec <= 0.35 &  AmeanVec>0.65)) = 3;
  attractor(i,((WmeanVec > 0.35 & WmeanVec <= 0.65) & AmeanVec <= 0.35))  =4 ;
  attractor(i,((WmeanVec > 0.35 & WmeanVec <= 0.65) & (AmeanVec>0.35 & AmeanVec<=0.65)))  =5;
  attractor(i,((WmeanVec > 0.35 & WmeanVec <= 0.65) & AmeanVec > 0.65))  =6 ;
  attractor(i,(WmeanVec > 0.65 & AmeanVec <= 0.35)) = 7;
  attractor(i,WmeanVec > 0.65 & (AmeanVec>0.35 & AmeanVec<=0.65)) = 8;
  attractor(i,(WmeanVec > 0.65 & AmeanVec > 0.65)) = 9;
  
  for j=1:noAttractors
    % count time points for each state
    timeInEachAttractor(i,j) = sum(attractor(i,:)==j)/lengthOfSimulations;
    % record mean(w)-level in each attractor
    meanWLevelInAttractor(i,j) = mean(WmeanVec(attractor(i,:)==j));
    % record mean(w)-level in each attractor
    meanALevelInAttractor(i,j) = mean(AmeanVec(attractor(i,:)==j));
  end
  
  % identify switches (=changes in attractor)
  attractorChanges = attractor(i,1:end-1)-attractor(i,2:end);
  switchIndeces = find(attractorChanges ~=0);
  totalNumberOfSwitches(i) = length(switchIndeces);
  
  %% record total time spent in each states/attractors
  % loop through switchIndeces and record length between switches
  for ind=1:length(switchIndeces)-1
    countCycleLength(i,switchIndeces(ind+1)-switchIndeces(ind)) = countCycleLength(i,switchIndeces(ind+1)-switchIndeces(ind))+1;
  end


  % hist-command uses too wide bins and bar-command uses too many
  % bins, therefore we need to collect our own statistic
  bins = {'<=10', '11-50','51-100','101-200','201-500','501-1000','>=1000'};
  countsInBins(i,1) = sum(countCycleLength(i,1:10),2);
  countsInBins(i,2) = sum(countCycleLength(i,11:50),2);
  countsInBins(i,3) = sum(countCycleLength(i,51:100),2);
  countsInBins(i,4) = sum(countCycleLength(i,101:200),2);
  countsInBins(i,5) = sum(countCycleLength(i,201:500),2);
  countsInBins(i,6) = sum(countCycleLength(i,501:1000),2);
  countsInBins(i,7) = sum(countCycleLength(i,1001:end),2);

  %% record time spent in each state without switch
  % initialize matrix, (i,j) says that dynamics stayed in state i
  % for j-times exactly (i,j)-times
  cycleLengthPerState = zeros(noAttractors,length(attractor));

  % first state (beginning of simulation)
  cycleLengthPerState(attractor(i,1),switchIndeces(1))=1;
  % all other states but last as we don't know how
  % long dynamics would have stayed in
  for k=2:length(switchIndeces)
    cycleLengthPerState(attractor(i,switchIndeces(k)),switchIndeces(k)-switchIndeces(k-1)) =cycleLengthPerState(attractor(i,switchIndeces(k)),switchIndeces(k)-switchIndeces(k-1))+1;
  end
  % find mean length of stay in each state
  for k=1:noAttractors
    % the following line multiplies the length of cycles
    % (find(cycleLengthPerState(k,:)~=0)) with how often they
    % occured (cycleLengthPerState(k,cycleLengthPerState(k,:)~=0))
    % and divides by the number of cycles
    % (sum(cycleLengthPerState(k,:) which is the same as length(switchIndeces))
    meanStayInState(i,k) = find(cycleLengthPerState(k,:)~=0)*cycleLengthPerState(k,cycleLengthPerState(k,:)~=0)'/sum(cycleLengthPerState(k,:));
    countCyclesPerState(i,k) = sum(cycleLengthPerState(k,:));
  end

  % prepare to get transition probabilities between states
  attractorSwitches = nan(length(switchIndeces),2);
  for sw=1:length(switchIndeces)
    attractorSwitches(sw,1) = attractor(i,switchIndeces(sw));
    attractorSwitches(sw,2) = attractor(i,switchIndeces(sw)+1);
  end
  
  % count transitions
  for as=1:size(attractorSwitches,1)
    if sum(isnan(attractorSwitches(as,:)))==0 % ensure that
                                              % transitions are
                                              % between states not
                                              % to or from nan
      countTransitionsBetweenStates(i,attractorSwitches(as,2),attractorSwitches(as,1)) = countTransitionsBetweenStates(i,attractorSwitches(as,2),attractorSwitches(as,1))+1;
    end
  end
  
  %% extract transistion probabilities for each time step
  % count transitions
  for j=1:length(attractor(i,:))-1
    if sum(isnan([attractor(i,j) attractor(i,j+1)]))==0
      transitions(i,attractor(i,j+1),attractor(i,j)) = transitions(i,attractor(i,j+1),attractor(i,j))+1;
    end
  end
  % convert counts into probabilities
  %transitions(i,:,:) = squeeze(transitions(i,:,:))./(sum(transitions(i,:,:),2)'*ones(1,noAttractors));

  
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
      timeForTransition1to8(i) = timeForTransition1to8(i) + entryTime8(j)-exitTime1(index);
      count1to8(i) = count1to8(i) + 1;
      % for the first occurence record the path the dynamics took
      if isnan(lastIndex)
	path1to8_w(i,1:entryTime8(j)-exitTime1(index)+1) = WmeanVec(exitTime1(index):entryTime8(j));
	path1to8_a(i,1:entryTime8(j)-exitTime1(index)+1) = AmeanVec(exitTime1(index):entryTime8(j));
      end
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
      timeForTransition8to1(i) = timeForTransition8to1(i) + entryTime1(j)-exitTime8(index);
      count8to1(i) = count8to1(i) + 1;
      % for the first occurence record the path the dynamics took
      if isnan(lastIndex)
	path8to1_w(i,1:entryTime1(j)-exitTime8(index)+1) = WmeanVec(exitTime8(index):entryTime1(j));
	path8to1_a(i,1:entryTime1(j)-exitTime8(index)+1) = AmeanVec(exitTime8(index):entryTime1(j));
      end
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
      timeForTransition8to3(i) = timeForTransition8to3(i) + entryTime3(j)-exitTime8(index);
      count8to3(i) = count8to3(i) + 1;
      % for the first occurence record the path the dynamics took
      if isnan(lastIndex)
	path8to3_w(i,1:entryTime3(j)-exitTime8(index)+1) = WmeanVec(exitTime8(index):entryTime3(j));
	path8to3_a(i,1:entryTime3(j)-exitTime8(index)+1) = AmeanVec(exitTime8(index):entryTime3(j));
      end
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
      timeForTransition3to8(i) = timeForTransition3to8(i) + entryTime8(j)-exitTime3(index);
      count3to8(i) = count3to8(i) + 1;
      % for the first occurence record the path the dynamics took
      if isnan(lastIndex)
	path3to8_w(i,1:entryTime8(j)-exitTime3(index)+1) = WmeanVec(exitTime3(index):entryTime8(j));
	path3to8_a(i,1:entryTime8(j)-exitTime3(index)+1) = AmeanVec(exitTime3(index):entryTime8(j));
      end
      lastIndex = index;
    end
  end
  
  if aportCond
    break;
  end
end
 
  
%% save results
save([directory outputFilename],'noSimulations','noIndividuals','lengthOfSimulations','noAttractors','timeInEachAttractor','meanWLevelInAttractor','meanALevelInAttractor','attractor','attractor2','meanStayInState','countsInBins','bins','countCycleLength','countTransitionsBetweenStates','totalNumberOfSwitches','countCyclesPerState','transitions','timeForTransition1to8','timeForTransition8to1','timeForTransition3to8','timeForTransition8to3','path1to8_w','path1to8_a','path3to8_w','path3to8_a','path8to1_w','path8to1_a','path8to3_w','path8to3_a','count1to8','count8to1','count3to8','count8to3','attackForce','defenceForce');