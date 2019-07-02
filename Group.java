/*
 * Author: Susanne Schindler
 * Date: 18.5.2018
 * Email: Susanne.Schindler2@web.de
 * Copyright Susanne Schindler
 */

import java.util.Random;

/**
 * 
 */
public class Group {
    private double w;
    private double a;
    private double wf;
    private double af;
    private double waf;
    private double wdf;
    private double fitness;
    private double expNoOffspring;

    static Random randomGenerator;
    static Long randomSeed;

    static final int defaultW = -1;
    static final int defaultA = -1;
    static final int defaultWf = -1;
    static final int defaultAf = -1;
    static final int defaultWAf = -1;
    static final int defaultWDf = -1;
    static final int defaultFitness = -1;
    static final int defaultNoOffspring = -1;

    /**
     * constructor
     * 
     */
    public Group (double w, double a) {
	setInvestmentTraits(w,a);
        setDefaults();
    }

    /**
     * constructor
     * 
     */
    public Group () {
	double randW = randomGenerator.nextDouble();
	double randA = randomGenerator.nextDouble();
	setInvestmentTraits(randW,randA);
        setDefaults();
    }

    private static void setRandomSeed(long seed){
	randomSeed = seed;
    }

    static void initiateRandomGenerator(long seed){
	setRandomSeed(seed);
	randomGenerator = new Random(randomSeed);
    }

    private void setDefaults(){
	wf = defaultWf;
	af = defaultAf;
	waf = defaultWAf;
	wdf = defaultWDf;
	fitness = defaultFitness;
	expNoOffspring = defaultNoOffspring;
    }

    private void setInvestmentTraits(double newW, double newA){
	setW(newW);
	setA(newA);
    }

    private void setW(double newW){
	if (checkValueBetween0and1(newW))
	    w = newW;
	else{
	    w = defaultW;
	    System.out.println("Error in Group.java: setW: Invalid value of w, "+newW+". Set to " + defaultW +".");
	}
    }

    private void setA(double newA){
	if (checkValueBetween0and1(newA))
	    a = newA;
	else{
	    // if newA is very close but above 1 or very close but below 0 take new values.
	    if (checkValueBetween0and1(newA-0.000000001) || checkValueBetween0and1(newA+0.000000001))
		a=Math.round(newA);
	    else{
		a = defaultA;
		System.out.println("Error in Group.java: setA: Invalid value of a, "+newA+". Set to " + defaultA +".");
	    }
	}
    }

    public void mutateW(double newW){ setW(newW);}

    public void mutateA(double newA){ setA(newA);}

    public void setFitness(double fitValue){
	fitness = fitValue;
    }

    public void setExpNoOffspring(double number){
	expNoOffspring = number;
    }

    public void calcWf(double popMean){
	double candWf = (popMean*Population.getNoGroups()-w)/(Population.getNoGroups()-1);
	if (checkValueBetween0and1(candWf-0.02) || checkValueBetween0and1(candWf+0.02))
	    wf = candWf;
	else{
	    wf = defaultWf;
	    System.out.println("Error in Group.java: calcWf: Invalid value of wf, "+candWf+". Set to " + defaultWf +".");
	}
    }

    public void calcAf(double popMean){
	double candAf = (popMean*Population.getNoGroups()-a)/(Population.getNoGroups()-1);
	if (checkValueBetween0and1(candAf))
	    af = candAf;
	else{
	    if (checkValueBetween0and1(candAf-0.02) || checkValueBetween0and1(candAf+0.02))
		af=Math.round(candAf);
	    else{
		af = defaultAf;
		System.out.println("Error in Group.java: calcAf: Invalid value of af, "+candAf+". Set to " + defaultA +".");
	    }
	}
    }

    public void calcWAf(double popMean){
	double candWAf = (popMean*Population.getNoGroups()-w*a)/(Population.getNoGroups()-1);
	if (checkValueBetween0and1(candWAf))
	    waf = candWAf;
	else{
	    if (checkValueBetween0and1(candWAf-0.02) || checkValueBetween0and1(candWAf+0.02))
		waf=Math.round(candWAf);
	    else{
		waf = defaultWAf;
		System.out.println("Error in Group.java: calcWAf: Invalid value of (wa)f, "+candWAf+". Set to " + defaultWAf +".");
	    }
	}
    }



    public void calcWDf(double popMean){
	double candWDf = (popMean*Population.getNoGroups()-w*(1-a))/(Population.getNoGroups()-1);
	if (checkValueBetween0and1(candWDf))
	    wdf = candWDf;
	else{
	    if (checkValueBetween0and1(candWDf-0.02) || checkValueBetween0and1(candWDf+0.02))
		wdf=Math.round(candWDf);
	    else{
		wdf = defaultWDf;
		System.out.println("Error in Group.java: calcWDf: Invalid value of (w(1-a))f, "+candWDf+". Set to " + defaultWDf +".");
	    }
	}
    }


     private Boolean checkValueBetween0and1(double value){
	if (value>=0 && value <=1)
	    return Boolean.TRUE;
	else
	    return Boolean.FALSE;
    }


    public double getW(){ return w;}

    public double getA(){ return a;}

    public double getWf(){ return wf;}

    public double getAf(){ return af;}

    public double getWAf(){ return waf;}

    public double getWDf(){ return wdf;}

    public double getFitness(){ return fitness;}

    public double getExpNoOffspring(){ return expNoOffspring;}

}



