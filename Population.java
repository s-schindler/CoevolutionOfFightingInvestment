/*
 * Author: Susanne Schindler
 * Date: 18.5.2018
 * Email: Susanne.Schindler2@web.de
 * Copyright Susanne Schindler
 */

import java.util.LinkedList;
import java.util.Iterator;
import java.util.Random;

/**
 * 
 */
public class Population {

    private LinkedList<Group> groups;

    private double meanW;
    private double meanA;
    private double meanWA;
    private double meanWD;
    private double SDW; // sample standart deviations
    private double SDA;
    private double meanFitness;
    private double sumFitness;
    private double SDfitness;

    static int noGroups;

    static Random randomGenerator;
    static double param_k;
    static double param_ca;
    static double param_cd;
    static double param_cm;
    static double param_mu;
    static double param_cmu;

    static final int defaultNoGroups=100;
    static final int noParameters = 6;

    /**
     * constructor
     * 
     */
    public Population () {
	initiateListOfGroups();
	finalizeInitialization();
    }

    public Population(LinkedList<Group> newListOfGroups){
	groups = new LinkedList<Group>(newListOfGroups);
	// remove random surplus elements
	while (groups.size() > noGroups)
	    groups.remove(randomGenerator.nextInt(groups.size()));
	// add missing elements by randomly cloning the elements
	while (groups.size() < noGroups)
	    groups.add(groups.get(randomGenerator.nextInt(groups.size())));

	finalizeInitialization();
    }


    static void initiateRandomGenerator(long seed){
	randomGenerator = new Random(seed);
    }


    private void initiateListOfGroups(){
	groups = new LinkedList<Group>();
	for(int i=0; i<noGroups; i++)
	    groups.add(new Group());
    }

    private void finalizeInitialization(){
	calc_meanAndSDW();
	calc_meanAndSDA();
	calc_meanWA();
	calc_meanWD();
	updateGroupWfandAf();
	updateFitness();
	calc_meanAndSDfitness();
    }

    static public void setNoGroups(int value){
	noGroups = value;
    }

    static public void setDefaultNoGroups(){
	noGroups = defaultNoGroups;
    }

    static public void setParameters(double[] paramArray){
	param_k = paramArray[0]; 
	param_ca = paramArray[1];
	param_cd = paramArray[2];
	param_cm = paramArray[3];
	param_mu = paramArray[4];
	param_cmu = paramArray[5];
    }
    
    private void calc_meanAndSDW(){
	// first mean
	double summe=0;
	for (Group group : groups)
	    summe = summe + group.getW();
	meanW =  summe/groups.size();

	// second sample standard deviation
	summe=0;
	for (Group group : groups)
	    summe = summe + Math.pow(group.getW()-meanW,2);
	SDW = Math.sqrt(summe/((groups.size()-1)));
    }
    
    private void calc_meanAndSDfitness(){
	// first mean
	double summe=0;
	for (Group group : groups)
	    summe = summe + group.getFitness();
	meanFitness =  summe/groups.size();
	sumFitness = summe;

	// second sample standard deviation
	summe=0;
	for (Group group : groups)
	    summe = summe + Math.pow(group.getFitness()-meanFitness,2);
	SDfitness = Math.sqrt(summe/((groups.size()-1)));
    }

    private void calc_meanAndSDA(){
	// first mean
	double summe=0;
	for (Group group : groups)
	    summe = summe + group.getA();
	meanA = summe/groups.size();

	// second sample standard deviation
	summe=0;
	for (Group group : groups)
	    summe = summe + Math.pow(group.getA()-meanA,2);
	SDA = Math.sqrt(summe/((groups.size()-1)));
    }


    private void calc_meanWA(){
	double summe=0;
	for (Group group : groups)
	    summe = summe + group.getW()*group.getA();
	meanWA = summe/groups.size();
    }


    private void calc_meanWD(){
	double summe=0;
	for (Group group : groups)
	    summe = summe + group.getW()*(1-group.getA());
	meanWD = summe/groups.size();
    }


    private void updateGroupWfandAf(){
	for(Group g : groups){
	    g.calcWf(meanW);
	    g.calcAf(meanA);
	    g.calcWAf(meanWA);
	    g.calcWDf(meanWD);
	}
    }

    private void updateFitness(){
	for(Group g : groups)
	    g.setFitness(calcFitness(g.getW(),g.getA(),g.getWf(),g.getAf(),g.getWAf(),g.getWDf()));
    }

    private double calcFitness(double w, double a, double wf, double af, double waf, double wdf){
	double defaultFitnessValue = -1;
	double survivalComponent = -1;
	double reproductiveComponent = -1;

	double probToWinForAttackers = 1/(1+Math.exp(-param_k*(w*a-wdf)));
	double probToWinForDefenders = 1/(1+Math.exp(-param_k*(w*(1-a)-waf)));
	double baselineSurvival = 1 - param_mu;
	double investmentCosts = w*(param_cmu + param_cm*a*w); 
	double engagementCostsForAttackers = (1-(w*a-wdf))*param_ca;
	double engagementCostsForDefenders = (1-(w*(1-a)-waf))*param_cd;
	double expectedResources = 1 + probToWinForAttackers*a*(1-af) - af*(1-a)*(1-probToWinForDefenders);


	// no investment, no engagement
	double survComp1 = baselineSurvival;
	// only investment, no engagement
	double survComp2 = baselineSurvival - investmentCosts;
	// investment and attack engagement
	double survComp3 = baselineSurvival - investmentCosts -engagementCostsForAttackers;
	// investment and defence engagement
	double survComp4 = baselineSurvival - investmentCosts -engagementCostsForDefenders;
	// investment and both engagement costs
	double survComp5 = baselineSurvival - investmentCosts -engagementCostsForAttackers -engagementCostsForDefenders;

	// winning none, loosing 1
	double reprComp0 = 0;
	// zero change in resources (either by no attack and defence or by circular swap (gaining one, loosing one)
	double reprComp1 = 1;
	// winning one, loosing none
	double reprComp2 = 2;
	// possibly winning one, losing none
	double reprComp3 = 1 + probToWinForAttackers;
	// gaining none, possibly losing one
	double reprComp4 = probToWinForDefenders;
	// possibly gaining one, possibly losing one
	double reprComp5 = probToWinForAttackers + probToWinForDefenders;
	// possibly gaining one, losing one
	double reprComp6 = probToWinForAttackers;
	// winning one, possibly losing one
	double reprComp7 = 1 + probToWinForDefenders;


	if(w == 0){
	    if(wf == 0){
		survivalComponent = survComp1;
		reproductiveComponent = reprComp1;
	    }
	    else{//w==0, wf>0
		if(waf==0 && wdf>0){
		    survivalComponent = survComp1;
		    reproductiveComponent = reprComp1;
		}
		if(waf>0 && wdf>0){
		    survivalComponent = survComp1;
		    reproductiveComponent = reprComp0;
		}
		if(waf>0 && wdf==0){
		    survivalComponent = survComp1;
		    reproductiveComponent = reprComp0;
		}
	    }
	}
	else{// w>0
	    if(a==0){
		if(wf == 0){
		    survivalComponent = survComp2;
		    reproductiveComponent = reprComp1;
		}
		else{//w>0, wf>0
		    if(waf==0 && wdf>0){
			survivalComponent = survComp2;
			reproductiveComponent = reprComp1;
		    }
		    if(waf>0 && wdf>0){
			survivalComponent = survComp4;
			reproductiveComponent = reprComp4;
		    }
		    if(waf>0 && wdf==0){
			survivalComponent = survComp4;
			reproductiveComponent = reprComp4;
		    }
		}
	    }
	    if(a>0 && a<1){
		if(wf == 0){
		    survivalComponent = survComp2;
		    reproductiveComponent = reprComp2;
		}
		else{//w>0, wf>0
		    if(waf==0 && wdf>0){
			survivalComponent = survComp3;
			reproductiveComponent = reprComp3;
		    }
		    if(waf>0 && wdf>0){
			survivalComponent = survComp5;
			reproductiveComponent = reprComp5;
		    }
		    if(waf>0 && wdf==0){
			survivalComponent = survComp4;
			reproductiveComponent = reprComp7;
		    }
		}
	    }
	    if(a==1){
		if(wf == 0){
		    survivalComponent = survComp2;
		    reproductiveComponent = reprComp2;
		}
		else{//w>0, wf>0
		    if(waf==0 && wdf>0){
			survivalComponent = survComp3;
			reproductiveComponent = reprComp3;
		    }
		    if(waf>0 && wdf>0){
			survivalComponent = survComp3;
			reproductiveComponent = reprComp6;
		    }
		    if(waf>0 && wdf==0){
			survivalComponent = survComp2;
			reproductiveComponent = reprComp1;
		    }
		}
	    }
	}
	return survivalComponent*reproductiveComponent;
    }


    public static int getNoGroups(){ return noGroups; }

    static public int getNoParameters(){ return noParameters; }

    public LinkedList<Group> getGroups(){ return groups; }

    public double getMeanW(){ return meanW; }

    public double getMeanA(){ return meanA; }

    public double getSDW(){ return SDW; }

    public double getSDA(){ return SDA; }

    public double getMeanWA(){ return meanWA; }

    public double getMeanWD(){ return meanWD; }

    public double getMeanFitness(){ return meanFitness; }

    public double getSumFitness(){ return sumFitness; }

    public double getSDfitness(){ return SDfitness; }

    //
    // TESTING ROUTINES
    //

    public void printPopulation(){
	int count =0;
	for (Group group : groups){
	    System.out.println(count+": w="+group.getW()+", a="+group.getA()+", wf="+group.getWf()+", af="+group.getAf()+", fitness="+group.getFitness()+", off="+group.getExpNoOffspring());
	    count++;
	}
	System.out.println("\n"+"meanW="+this.getMeanW()+", meanA="+this.getMeanA()+", sdW="+this.getSDW()+", sdA="+this.getSDA());
    }

}



