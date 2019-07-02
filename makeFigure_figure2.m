% Author: Susanne Schindler
% Date: 28.03.2019
% Copyright: Susanne Schindler (susanne.schindler2@web.de)

function makeFigure_invasionWithHomeAdvantage

%% initialise symbolic variables and parameters
% symbolic variables -- note that waf and wdf are not needed
% because all residents have the same w and a values, that is
% bar{w(1-a)}f = bar{w}f * (1 - bar{a}f)
syms w a wf af epsilon h 
% symbolic parameters
syms k mu cmu cm ca c_d

% parameter values
meshpoints_wf = 0:0.05:1;
meshpoints_af = 0:0.05:1;
h_Array = [-0.5 -0.2 -0.1 0 0.1 0.2 0.5];
hToPlot = [1 4 7];
epsilon_val = 0.01; % [SS: update, don't think rest of line is true (less general)]has to be the same increment as meshpoints of wf and af
                    % note that only mutants with increasing traits
                    % are considered, so some combinations of
                    % residents and mutants do not occur
k_val = 50;
mu_val = 0.1;
cmu_val = 0.05;
cm_val  = 0.025;
ca_val = 0.025;
cd_val = 0.025;

%% winning probabilities
pwinA = 1/(1+exp(-k*(w*a-(wf*(1-af)+h))));
pwinD = 1/(1+exp(-k*(w*(1-a)+h-wf*af)));

%% fitness components
% survival
Fs_1 =  1-mu;
Fs_2 =  1-mu - w*(cmu + cm * a);
Fs_3 =  1-mu - w*(cmu + cm * a) - ca*(1-(w*a-(wf*(1-af)+h)));
Fs_4 =  1-mu - w*(cmu + cm * a) - c_d*(1-(w*(1-a)+h-wf*af));
Fs_5 =  1-mu - w*(cmu + cm * a) - ca*(1-(w*a-(wf*(1-af)+h))) - c_d*(1-(w*(1-a)+h-wf*af));
% resources/reproduction
Fr_0 = 0;
Fr_1 = 1;
Fr_2 = 2;
Fr_3 = 1 + pwinA;
Fr_4 = pwinD;
Fr_5 = pwinA + pwinD;
Fr_6 = pwinA;
Fr_7 = 1 + pwinD;

%% initialise
directionOfSelection_wf = nan(length(meshpoints_wf),length(meshpoints_af),length(h_Array)); 
directionOfSelection_af = nan(length(meshpoints_wf),length(meshpoints_af),length(h_Array)); 

%%% calculate fitness values for residents and mutants in specific areas
%% area 1 (wf=0, af \in [0,1])
residentFitness1 = Fs_1 * Fr_1;
% af=0 
mutantWFitness1a = Fs_2 * Fr_1;
mutantAFitness1a = Fs_1 * Fr_1;
% af in (0,1) 
mutantWFitness1b = Fs_2 * Fr_2;
mutantAFitness1b = Fs_1 * Fr_1;
% af=1 
mutantWFitness1c = Fs_2 * Fr_2;
mutantAFitness1c = Fs_1 * Fr_1;
% enter fixed traits of residents and mutant into differences in fitness
diff_mutantWFitness1a = subs(subs(subs(subs(mutantWFitness1a,w,wf+epsilon),a,af) - subs(subs(residentFitness1,w,wf),a,af),wf,0),af,0);% doesn't depend on wf or w, we do it for completeness...
diff_mutantAFitness1a = subs(subs(subs(subs(mutantAFitness1a,w,wf),a,af+epsilon) - subs(subs(residentFitness1,w,wf),a,af),wf,0),af,0);
diff_mutantWFitness1b = subs(subs(subs(mutantWFitness1b,w,wf+epsilon),a,af) - subs(subs(residentFitness1,w,wf),a,af),wf,0);
diff_mutantAFitness1b = subs(subs(subs(mutantAFitness1b,w,wf),a,af+epsilon) - subs(subs(residentFitness1,w,wf),a,af),wf,0);
diff_mutantWFitness1c = subs(subs(subs(subs(mutantWFitness1c,w,wf+epsilon),a,af) - subs(subs(residentFitness1,w,wf),a,af),wf,0),af,1);
diff_mutantAFitness1c = subs(subs(subs(subs(mutantAFitness1c,w,wf),a,af+epsilon) - subs(subs(residentFitness1,w,wf),a,af),wf,0),af,1);


%% area 2 (wf in (0,1], af=0)
residentFitness2 = Fs_2 * Fr_1;
% wf in (0,1)
mutantWFitness2a = Fs_2 * Fr_1;
mutantAFitness2a = Fs_3 * Fr_3;
% wf = 1
mutantWFitness2b = Fs_2 * Fr_1;
mutantAFitness2b = Fs_3 * Fr_3;
% enter fixed traits of residents and mutant into differences in fitness
diff_mutantWFitness2a = subs(subs(subs(mutantWFitness2a,w,wf+epsilon),a,af),af,0) - subs(subs(subs(residentFitness2,w,wf),a,af),af,0);
diff_mutantAFitness2a = subs(subs(subs(mutantAFitness2a,w,wf),a,af+epsilon),af,0) - subs(subs(subs(residentFitness2,w,wf),a,af),af,0);
diff_mutantWFitness2b = subs(subs(subs(subs(mutantWFitness2b,w,wf+epsilon),a,af),wf,1),af,0) - subs(subs(subs(subs(residentFitness2,w,wf),a,af),wf,1),af,0);
diff_mutantAFitness2b = subs(subs(subs(subs(mutantAFitness2b,w,wf),a,af+epsilon),wf,1),af,0) - subs(subs(subs(subs(residentFitness2,w,wf),a,af),wf,1),af,0);


%% area 3 (wf in (0,1], af in (0,1)
residentFitness3 = Fs_5 * Fr_5;
% wf in (0,1], af in (0,1)[changed](0,1-epsilon)
mutantWFitness3a = Fs_5 * Fr_5;
mutantAFitness3a = Fs_5 * Fr_5;
%% % wf in (0,1], af = 1-epsilon
%% mutantWFitness3b = Fs_5 * Fr_5;
%% mutantAFitness3b = Fs_3 * Fr_6;
% enter fixed traits of residents and mutant into differences in fitness
diff_mutantWFitness3a = subs(subs(mutantWFitness3a,w,wf+epsilon),a,af) - subs(subs(residentFitness3,w,wf),a,af);
diff_mutantAFitness3a = subs(subs(mutantAFitness3a,w,wf),a,af+epsilon) - subs(subs(residentFitness3,w,wf),a,af);
%%diff_mutantWFitness3b = subs(subs(subs(mutantWFitness3b,w,wf+epsilon),a,af),af,1-epsilon) - subs(subs(residentFitness3,w,wf),a,af);
%%diff_mutantAFitness3b = subs(subs(subs(mutantAFitness3b,w,wf),a,af+epsilon),af,1-epsilon) - subs(subs(residentFitness3,w,wf),a,af);



%% area 4 (wf in (0,1], af=1)
residentFitness4 = Fs_2 * Fr_1;
% wf in (0,1)
mutantWFitness4a = Fs_2 * Fr_1;
mutantAFitness4a = Fs_4 * Fr_7;
% wf = 1
mutantWFitness4b = Fs_2 * Fr_1;
mutantAFitness4b = Fs_4 * Fr_7;
% enter fixed traits of residents and mutant into differences in fitness
diff_mutantWFitness4a = subs(subs(subs(mutantWFitness4a,w,wf+epsilon),a,af),af,1) - subs(subs(subs(residentFitness4,w,wf),a,af),af,1);
diff_mutantAFitness4a = subs(subs(subs(mutantAFitness4a,w,wf),a,af+epsilon),af,1) - subs(subs(subs(residentFitness4,w,wf),a,af),af,1);
diff_mutantWFitness4b = subs(subs(subs(subs(mutantWFitness4b,w,wf+epsilon),a,af),wf,1),af,1) - subs(subs(subs(subs(residentFitness4,w,wf),a,af),wf,1),af,1);
diff_mutantAFitness4b = subs(subs(subs(subs(mutantAFitness4b,w,wf),a,af+epsilon),wf,1),af,1) - subs(subs(subs(subs(residentFitness4,w,wf),a,af),wf,1),af,1);


%% enter specific parameter values
% area 1 (wf=0, af \in [0,1])
num_diff_mutantW1a = subs(subs(subs(subs(subs(subs(subs(diff_mutantWFitness1a,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantA1a = subs(subs(subs(subs(subs(subs(subs(diff_mutantAFitness1a,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantW1b = subs(subs(subs(subs(subs(subs(subs(diff_mutantWFitness1b,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantA1b = subs(subs(subs(subs(subs(subs(subs(diff_mutantAFitness1b,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantW1c = subs(subs(subs(subs(subs(subs(subs(diff_mutantWFitness1c,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantA1c = subs(subs(subs(subs(subs(subs(subs(diff_mutantAFitness1c,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
% area 2 (wf in (0,1], af=0)
num_diff_mutantW2a = subs(subs(subs(subs(subs(subs(subs(diff_mutantWFitness2a,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantA2a = subs(subs(subs(subs(subs(subs(subs(diff_mutantAFitness2a,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantW2b = subs(subs(subs(subs(subs(subs(subs(diff_mutantWFitness2b,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantA2b = subs(subs(subs(subs(subs(subs(subs(diff_mutantAFitness2b,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
% area 3 (wf in (0,1], af in (0,1)
num_diff_mutantW3a = subs(subs(subs(subs(subs(subs(subs(diff_mutantWFitness3a,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantA3a = subs(subs(subs(subs(subs(subs(subs(diff_mutantAFitness3a,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
%%num_diff_mutantW3b = subs(subs(subs(subs(subs(subs(subs(diff_mutantWFitness3b,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
%%num_diff_mutantA3b = subs(subs(subs(subs(subs(subs(subs(diff_mutantAFitness3b,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
% area 4 (wf \in (0,1], af=1)
num_diff_mutantW4a = subs(subs(subs(subs(subs(subs(subs(diff_mutantWFitness4a,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantA4a = subs(subs(subs(subs(subs(subs(subs(diff_mutantAFitness4a,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantW4b = subs(subs(subs(subs(subs(subs(subs(diff_mutantWFitness4b,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);
num_diff_mutantA4b = subs(subs(subs(subs(subs(subs(subs(diff_mutantAFitness4b,k,k_val),ca,ca_val),c_d,cd_val),cmu,cmu_val),cm,cm_val),mu,mu_val),epsilon,epsilon_val);


%%% fill in specific h, af, and wf values
for h_ind=1:length(h_Array)
  %% area 1 (wf=0, af \in [0,1]) ... there's no h-dependence as there are no contests (especially no defences to be met by mutant)
  index_wf = 1;
  % a=0
  directionOfSelection_wf(index_wf,1,h_ind) = num_diff_mutantW1a;
  directionOfSelection_af(index_wf,1,h_ind) = num_diff_mutantA1a;
  % a \in (0,1)
  for i=2:length(meshpoints_af)-1
    directionOfSelection_wf(index_wf,i,h_ind) = subs(num_diff_mutantW1b,af,meshpoints_af(i));
    directionOfSelection_af(index_wf,i,h_ind) = num_diff_mutantA1b;
  end
  % a=1
  directionOfSelection_wf(index_wf,end,h_ind) = num_diff_mutantW1c;
  directionOfSelection_af(index_wf,end,h_ind) = num_diff_mutantA1c;

  %% area 2 (wf in (0,1], af=0)
  index_af = 1;
  % wf in (0,1)
  for i=2:length(meshpoints_wf)-1
    directionOfSelection_wf(i,index_af,h_ind) = subs(subs(num_diff_mutantW2a,wf,meshpoints_wf(i)),h,h_Array(h_ind));
    directionOfSelection_af(i,index_af,h_ind) = subs(subs(num_diff_mutantA2a,wf,meshpoints_wf(i)),h,h_Array(h_ind));
  end
  % wf = 1
  directionOfSelection_wf(end,index_af,h_ind) = num_diff_mutantW2b;
  directionOfSelection_af(end,index_af,h_ind) = subs(num_diff_mutantA2b,h,h_Array(h_ind));
    
  %% area 3 (wf in (0,1], af in (0,1)
  for i=2:length(meshpoints_wf)
    for j=2:length(meshpoints_af)-1
%%      if abs(meshpoints_af(j)-(1-epsilon_val))>0.0001
	 % region 3a: af in (0,1) [changed](0,1-epsilon)
         directionOfSelection_wf(i,j,h_ind) = subs(subs(subs(num_diff_mutantW3a,wf,meshpoints_wf(i)),af,meshpoints_af(j)),h,h_Array(h_ind));
         directionOfSelection_af(i,j,h_ind) = subs(subs(subs(num_diff_mutantA3a,wf,meshpoints_wf(i)),af,meshpoints_af(j)),h,h_Array(h_ind));
%%      else
%%  	 % region 3b: af = 1-epsilon
%%         directionOfSelection_wf(i,j,h_ind) = subs(subs(subs(num_diff_mutantW3b,wf,meshpoints_wf(i)),af,meshpoints_af(j)),h,h_Array(h_ind));
%%         directionOfSelection_af(i,j,h_ind) = subs(subs(subs(num_diff_mutantA3b,wf,meshpoints_wf(i)),af,meshpoints_af(j)),h,h_Array(h_ind));
%%      end
    end
  end

  %% area 4 (wf \in (0,1], af=1)
  % wf in (0,1)
  for i=2:length(meshpoints_wf)-1
    directionOfSelection_wf(i,end,h_ind) = subs(num_diff_mutantW4a,wf,meshpoints_wf(i));
    directionOfSelection_af(i,end,h_ind) = subs(subs(num_diff_mutantA4a,wf,meshpoints_wf(i)),h,h_Array(h_ind));
  end
  % wf = 1
  directionOfSelection_wf(end,end,h_ind) = num_diff_mutantW4b;
  directionOfSelection_af(end,end,h_ind) = subs(num_diff_mutantA4b,h,h_Array(h_ind));
end


%%% visualisation
%% make velocity plots with same-length and colorcoded arrows
% get colormap
cm = colormap('jet');
% set number of colors to differentiate
noColors = 10;
% get minmal and maximal arrow sizes
minArrowSize=min(min(min(abs(directionOfSelection_af(:,:,:)+directionOfSelection_wf(:,:,:)))));
maxArrowSize=max(max(max(abs(directionOfSelection_af(:,:,:)+directionOfSelection_wf(:,:,:)))));
% create spacing to check arrow length against (check that absolute arrow sizes fall between 1e-7 and 1e0!)
logSpacing = [logspace(-7,0,noColors)];
% create spacing for assigning arrow colors
colorSpacing = fliplr(size(cm,1):-round(size(cm,1)/noColors):1);
% calculate factors to bring all arrows to the same length
factorMat = 1./sqrt(directionOfSelection_af.^2 + directionOfSelection_wf.^2);
factorMat_af = 1./abs(directionOfSelection_af);
factorMat_wf = 1./abs(directionOfSelection_wf);
% record indices for arrows of specific lengths
indices = zeros([size(directionOfSelection_af) noColors]);
indices_af = zeros([size(directionOfSelection_af) noColors]);
indices_wf = zeros([size(directionOfSelection_af) noColors]);
for i=1:noColors
  indices(:,:,:,i) = abs(directionOfSelection_af + directionOfSelection_wf)<=logSpacing(i);
  indices_af(:,:,:,i) = abs(directionOfSelection_af)<=logSpacing(i);
  indices_wf(:,:,:,i) = abs(directionOfSelection_wf)<=logSpacing(i);
end
% create plot for h=0
figure;
  hold on;
  for i=noColors:-1:1
    q=quiver(meshpoints_af,meshpoints_wf,directionOfSelection_af(:,:,4).*indices(:,:,4,i).*factorMat(:,:,4),directionOfSelection_wf(:,:,4).*indices(:,:,4,i).*factorMat(:,:,4),'Color',cm(colorSpacing(i),:),'LineWidth',2,'autoscalefactor',0.5);
  end
  hold off;
  set(gca,'FontSize',18);
  colorbar('ytick',[0:2/noColors:1],'yTickLabel',logSpacing([1:2:end end]));
  colormap('jet');
  xlabel('a_f');
  ylabel('w_f');
  xlim([-0.05 1.05]);
  ylim([-0.05 1.05]);


%% make plot for selection pressure into wf- and af-direction separately (for h=0)
figure;
subplot(1,2,1);
  hold on;
  for i=noColors:-1:1
    q=quiver(meshpoints_af,meshpoints_wf,zeros(length(meshpoints_wf),length(meshpoints_af)),directionOfSelection_wf(:,:,4).*indices_wf(:,:,4,i).*factorMat_wf(:,:,4),'Color',cm(colorSpacing(i),:),'LineWidth',2,'autoscalefactor',0.45);
  end
  hold off;
  set(gca,'FontSize',18);
  %colorbar('ytick',[0:2/noColors:1],'yTickLabel',logSpacing([1:2:end end]));
  colormap('jet');
  xlabel('a_f');
  ylabel('w_f');
  xlim([-0.05 1.05]);
  ylim([-0.05 1.05]);
  title('Selection for increasing fighters')
subplot(1,2,2);
  hold on;
  for i=noColors:-1:1
    q=quiver(meshpoints_af,meshpoints_wf,directionOfSelection_af(:,:,4).*indices_af(:,:,4,i).*factorMat_af(:,:,4),zeros(length(meshpoints_wf),length(meshpoints_af)),'Color',cm(colorSpacing(i),:),'LineWidth',2,'autoscalefactor',0.45);
  end
  hold off;
  set(gca,'FontSize',18);
  colorbar('ytick',[0:2/noColors:1],'yTickLabel',logSpacing([1:2:end end]));
  colormap('jet');
  xlabel('a_f');
  ylabel('w_f');
  xlim([-0.05 1.05]);
  ylim([-0.05 1.05]);
  title('Selection for increasing attackers')



%% make subplots for all h-values -- with colored arrows
figure;
for hval=1:length(h_Array)
subplot(2,4,hval);
  hold on;
  for i=noColors:-1:1
    q=quiver(meshpoints_af,meshpoints_wf,directionOfSelection_af(:,:,hval).*indices(:,:,hval,i).*factorMat(:,:,hval),directionOfSelection_wf(:,:,hval).*indices(:,:,hval,i).*factorMat(:,:,hval),'Color',cm(colorSpacing(i),:),'LineWidth',2,'autoscalefactor',0.5);
  end
  hold off;
  if hval == length(h_Array)
    colorbar('ytick',[0:2/noColors:1],'yTickLabel',logSpacing([1:2:end end]));
    colormap('jet');
  end
  set(gca,'FontSize',18);
  xlabel('a_f');
  ylabel('w_f');
  title(['h= ' num2str(h_Array(hval))]);
end
