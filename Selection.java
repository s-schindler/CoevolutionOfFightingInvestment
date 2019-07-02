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
public class Selection {
    static Random randomGenerator;

    /**
     * constructor
     * 
     */
    public Selection () {}

    static void initiateRandomGenerator(long seed){
	randomGenerator = new Random(seed);
    }


    // /**
    //  * Proportional selection for the groups above average fitness.
    //  */
    // public static LinkedList<Group> selectAndMutateGroups_truncatedSelection(Population pop, double meanFitness, double sumFitness){
    // 	// create list with groups with above average fitness
    // 	LinkedList<Group> aboveAvgFitGroups = getAboveAvgFitGroups(pop.getGroups(),meanFitness);

    // 	// calculate the expected number of offspring groups for each group with above average fitness
    // 	calc_expectedNoOffspringGroups(aboveAvgFitGroups);

    // 	// output current population to file
    // 	outputListOfGroups(pop);

    // 	// create list into which successful groups are cloned
    // 	LinkedList<Group> newListOfGroups = new LinkedList<Group>();

    // 	// get list of cumulating fitness values
    // 	double[] cumFitnessArray = calc_cumulativeFitnessArray(aboveAvgFitGroups);

    // 	// iterate through list
    //     for(int i=0; i< aboveAvgFitGroups.size(); i++){
    // 	    //get random number
    // 	    double rand = randomGenerator.nextDouble()*sumFitness;
    // 	    int count = -1;
    // 	    do{
    // 		count++;
    // 	    } while (cumFitnessArray[count]<rand && count<aboveAvgFitGroups.size()-1);
    // 	    //add two copies to make up for the fact that only half of the population reproduces
    // 	    newListOfGroups.add(new Group(pop.getGroups().get(count).getW(),pop.getGroups().get(count).getA()));
    // 	    newListOfGroups.add(new Group(pop.getGroups().get(count).getW(),pop.getGroups().get(count).getA()));
    // 	}

    // 	// mutate investment traits of some groups
    // 	Mutation.mutateGroups_incremental(newListOfGroups);
    // 	//Mutation.mutateGroups_random(newListOfGroups);

    // 	return newListOfGroups; // returned list might have more entries than Population.noGroups
    // }


    /**
     * Proportional selection as implemented in Jebari and Madiafi 2013 
     */
    public static LinkedList<Group> selectAndMutateGroups_proportionalSelection(Population pop, double sumFitness){
	// calculate the expected number of offspring groups for each group
	calc_expectedNoOffspringGroups(pop.getGroups());

	// output current population to file
	outputListOfGroups(pop);

	// create list into which successful groups are cloned
	LinkedList<Group> newListOfGroups = new LinkedList<Group>();

	// get list of cumulating fitness values
	double[] cumFitnessArray = calc_cumulativeFitnessArray(pop.getGroups());

	// iterate through list
        for(int i=0; i< pop.getNoGroups(); i++){
	    //get random number
	    double rand = randomGenerator.nextDouble()*sumFitness;
	    int count = -1;
	    do{
		count++;
	    } while (cumFitnessArray[count]<rand && count<pop.getNoGroups()-1);
	    newListOfGroups.add(new Group(pop.getGroups().get(count).getW(),pop.getGroups().get(count).getA()));
	}

	// mutate investment traits of some groups
	Mutation.mutateGroups_GaussianIncrement(newListOfGroups);

	return newListOfGroups; // returned list might have more entries than Population.noGroups
    }


    private static void calc_expectedNoOffspringGroups(LinkedList<Group> listOfGroups){
	double posSum = 0; // sum over positive fitness values 
	double totSum = 0; // sum over all fitness values 
	double min = Integer.MAX_VALUE; // absolute minimum in fitness values

	for(Group g : listOfGroups){
	    double fit = g.getFitness();
	    posSum = posSum + Math.max(0,fit);
	    totSum = totSum + fit;
	    if (fit < min) min = fit; // record minimal fitness value
	}

	// if posSum is zero, let groups reproduce according to their relative share
	if (posSum == 0 ){
	    if(totSum==0)
		// set offspring number to 1 -- no evolution
		for(Group g : listOfGroups) 
		    g.setExpNoOffspring(1);
	    else
		// shift fitness values, such that most negative group gets zero fitness and then set exp no offspring as their fraction on total fitness 
		for(Group g : listOfGroups) 
		    g.setExpNoOffspring((-min+g.getFitness())/(-totSum)*Population.getNoGroups());
	}
	// if sum is positive, then calculation proportion of noGroups that corresponds to proportion of totalFitness
	else 
	    for(Group g : listOfGroups) 
		g.setExpNoOffspring(Math.max(0,g.getFitness())/posSum*Population.getNoGroups());
    }





    private static LinkedList<Group>  getAboveAvgFitGroups(LinkedList<Group> list, double meanFitness){
	LinkedList<Group> listWithGroupsAboveAvgFit = new LinkedList<Group>();
	for(Group g : list)
	    if (g.getFitness()>=meanFitness)
		listWithGroupsAboveAvgFit.add(g);
	return listWithGroupsAboveAvgFit;
    }


    private static LinkedList<Group>  getBelowAvgFitGroups(LinkedList<Group> list, double meanFitness){
	LinkedList<Group> listWithGroupsBelowAvgFit = new LinkedList<Group>();
	for(Group g : list)
	    if (g.getFitness()<meanFitness)
		listWithGroupsBelowAvgFit.add(g);
	return listWithGroupsBelowAvgFit;
    }


    private static double[] calc_cumulativeFitnessArray(LinkedList<Group> listOfGroups){
	double[] cumArray = new double[listOfGroups.size()];
	int count = 0;
	for (Group g : listOfGroups){
	    if (count==0)
		cumArray[count] = g.getFitness();
	    else
		cumArray[count] = cumArray[count-1] + g.getFitness();
	    count++;
	}
	return cumArray;
    }



    private static void outputListOfGroups(Population pop){
	// create array for output
	int arraySize = 6*Population.getNoGroups()+4;
	double[] outputArray = new double[arraySize];
	//fill array
	int index = 0;
	for(Group g : pop.getGroups()){ 
	    // 1) w
	    outputArray[index] = g.getW();
	    // 2) a
	    outputArray[index+Population.getNoGroups()] = g.getA();
	    // 3) wf
	    outputArray[index+2*Population.getNoGroups()] = g.getWf();
	    // 4) af
	    outputArray[index+3*Population.getNoGroups()] = g.getAf();
	    // 5) fitness
	    outputArray[index+4*Population.getNoGroups()] = g.getFitness();
	    // 6) expected number of offspring
	    outputArray[index+5*Population.getNoGroups()] = g.getExpNoOffspring();
	    index++;
	}

	// add population means and standard deviations to output array
	outputArray[6*Population.getNoGroups()] = pop.getMeanW();
	outputArray[6*Population.getNoGroups()+1] = pop.getMeanA();
	outputArray[6*Population.getNoGroups()+2] = pop.getMeanWA();
	outputArray[6*Population.getNoGroups()+3] = pop.getMeanWD();

	// pass array on to write it into file
	StartSimulation.printToFile(arraySize,outputArray);
    }
}
