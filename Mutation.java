/*
 * Author: Susanne Schindler
 * Date: 18.5.2018
 * Email: Susanne.Schindler2@web.de
 * Copyright Susanne Schindler
 */

import java.util.Random;
import java.util.LinkedList;
import java.util.Iterator;

/**
 * 
 */
public class Mutation {
    static Random randomGenerator;
    static double mutationRate;
    static double mutationIncr;
    static double SDforMutationIncr;

    static final double defaultMutationRate = 0.05;
    static final double defaultMutationIncr = 0.05;
    static final double defaultSDforMutationIncr = 0.05;

    /**
     * constructor
     * 
     */
    public Mutation () {
	setDefaults();
    }

    private static void setDefaults(){
	mutationRate = defaultMutationRate;
	mutationIncr = defaultMutationIncr;
	SDforMutationIncr = defaultSDforMutationIncr;
    }

    static void setDefaultMutationRate(){
	mutationRate = defaultMutationRate;
    }

    static void setDefaultMutationIncr(){
	mutationIncr = defaultMutationIncr;
    }

    static void setDefaultSDforMutationIncr(){
	SDforMutationIncr = defaultSDforMutationIncr;
    }

    static void initiateRandomGenerator(long seed){
	randomGenerator = new Random(seed);
    }

    static void mutateGroups_random(LinkedList<Group> listOfGroups){
	// loop through each group
	for(Group g : listOfGroups){
	    // check for each trait if mutation happens and mutate accordingly
	    if (randomGenerator.nextDouble() <= mutationRate)
		// mutate w
		g.mutateW(randomGenerator.nextDouble());
	    if (randomGenerator.nextDouble() <= mutationRate)
		// mutate a
		g.mutateA(randomGenerator.nextDouble());
	}
    }

    static void mutateGroups_incremental(LinkedList<Group> listOfGroups){
	double newW,newA;

	// loop through each group
	for(Group g : listOfGroups){
	    // check for each trait if mutation happens and mutate accordingly
	    if (randomGenerator.nextDouble() <= mutationRate){
		if (randomGenerator.nextDouble()<=0.5)
		    newW = Math.min(g.getW()+mutationIncr,1);
		else
		    newW = Math.max(g.getW()-mutationIncr,0);
		// mutate w
		g.mutateW(newW);
	    }
	    if (randomGenerator.nextDouble() <= mutationRate){
		if (randomGenerator.nextDouble()<=0.5)
		    newA = Math.min(g.getA()+mutationIncr,1);
		else
		    newA = Math.max(g.getA()-mutationIncr,0);
		// mutate a
		g.mutateA(newA);
	    }
	}
    }


    static void mutateGroups_GaussianIncrement(LinkedList<Group> listOfGroups){
	double newW,newA;

	// loop through each group
	for(Group g : listOfGroups){
	    // check for each trait if mutation happens and mutate accordingly
	    // first w-trait
	    if (randomGenerator.nextDouble() <= mutationRate){
		double increment = randomGenerator.nextGaussian()*SDforMutationIncr;
		if (increment > 0)
		    newW = Math.min(g.getW()+increment,1);
		else
		    newW = Math.max(g.getW()+increment,0);
		// mutate w
		g.mutateW(newW);
	    }
	    // second a-trait
	    if (randomGenerator.nextDouble() <= mutationRate){
		double increment = randomGenerator.nextGaussian()*SDforMutationIncr;
		if (increment > 0)
		    newA = Math.min(g.getA()+increment,1);
		else
		    newA = Math.max(g.getA()+increment,0);
		// mutate a
		g.mutateA(newA);
	    }
	}
    }




    public double getMutationRate(){ return mutationRate; }

}
