% Author: Susanne Schindler
% Date: 19.7.2018
% Copyright: Susanne Schindler (susanne.schindler2@web.de)

function makeFigure_probOfWinning

%% parameter values
kArray = [ 1 3 6 12 25 50 75 100 200 300 500 700 1000];
kToPlot = [6 50];
kIndeces = [find(kArray==kToPlot(1)) find(kArray==kToPlot(2))]; 
xVal = -1:0.01:1; % as substitute for w*a
indexX0 = find(xVal==0);
indexX1 = find(xVal==1);
hArray = -1:0.1:1;
hToPlot = [-0.3 0.3];
epsilon = 0.0000001;
hIndeces = [find(abs(hArray-hToPlot(1))<epsilon) find(abs(hArray-hToPlot(2))<epsilon)]; 

winningProbForAttackers = @(k,x) 1./(1+exp(-k*x));
winningProbForDefenders = @(k,x) 1./(1+exp(-k*x));
winningProbForAttackers_withH = @(k,attackForce,defenceForce,h) 1./(1+exp(-k*(attackForce-(defenceForce+h))));
winningProbForDefenders_withH = @(k,attackForce,defenceForce,h) 1./(1+exp(-k*(defenceForce+h-attackForce)));

% initialize arrays
winAttack = nan(length(kArray),length(xVal));
winDefence = nan(length(kArray),length(xVal));
winAttack_h = nan(length(xVal),length(xVal),length(hArray));
winDefence_h = nan(length(xVal),length(xVal),length(hArray));
winAttack_h_k6 = nan(length(xVal),length(xVal),length(hArray));
winDefence_h_k6 = nan(length(xVal),length(xVal),length(hArray));

for k=1:length(kArray)
  winAttack(k,:) = winningProbForAttackers(kArray(k),xVal);
  winDefence(k,:) = winningProbForDefenders(kArray(k),xVal);
end

for a=1:length(xVal)
  for d=1:length(xVal)
    for h=1:length(hArray)
      winAttack_h(a,d,h) = winningProbForAttackers_withH(50,xVal(a),xVal(d),hArray(h));
      winDefence_h(a,d,h) = winningProbForDefenders_withH(50,xVal(a),xVal(d),hArray(h));
      winAttack_h_k6(a,d,h) = winningProbForAttackers_withH(6,xVal(a),xVal(d),hArray(h));
      winDefence_h_k6(a,d,h) = winningProbForDefenders_withH(6,xVal(a),xVal(d),hArray(h));
    end
  end
end



% visualisation
h=figure;
subplot(1,2,1);
  plot(xVal,winAttack(kIndeces(1),:),'LineWidth',2,'Color',[0.5 0.5 0.5]);
  hold on;
  plot(xVal,winAttack(kIndeces(2),:),'LineWidth',2,'Color',[0 0 0]);
  hold off;
  set(gca,'FontSize',18);
  legend(strread(['k=' num2str(kArray(kIndeces))],'%s'),'Box','off','Location','NorthWest');
  xlabel('Difference to opponents forces')
  ylabel('Probability of winning');
  text(-1.2,1.05,'a','FontWeight','bold','FontSize',18);
subplot(1,2,2);
  plot(xVal,[fliplr(winAttack_h_k6(indexX0,indexX0:indexX1,hIndeces(1))) fliplr(winAttack_h_k6(indexX1,indexX0:indexX1-1,hIndeces(1)))],'LineWidth',2,'Color',[0.5 0.5 0.5],'LineStyle','--');
  hold on;
  plot(xVal,[fliplr(winAttack_h_k6(indexX0,indexX0:indexX1,hIndeces(2))) fliplr(winAttack_h_k6(indexX1,indexX0:indexX1-1,hIndeces(2)))],'LineWidth',2,'Color',[0.5 0.5 0.5],'LineStyle',':');
  plot(xVal,[fliplr(winAttack_h(indexX0,indexX0:indexX1,hIndeces(1))) fliplr(winAttack_h(indexX1,indexX0:indexX1-1,hIndeces(1)))],'LineWidth',2,'Color',[0 0 0],'LineStyle','--');
  plot(xVal,[fliplr(winAttack_h(indexX0,indexX0:indexX1,hIndeces(2))) fliplr(winAttack_h(indexX1,indexX0:indexX1-1,hIndeces(2)))],'LineWidth',2,'Color',[0 0 0],'LineStyle',':');
  hold off;
  set(gca,'FontSize',18);
  xlabel('Attackers minus defenders forces')
  ylabel('Probability to win an attack');
  text(-1.15,1.05,'b','FontWeight','bold','FontSize',18);
  

