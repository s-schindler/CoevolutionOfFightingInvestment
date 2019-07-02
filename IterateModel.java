/*
 * Author: Susanne Schindler
 * Date: 18.5.2018
 * Email: Susanne.Schindler2@web.de
 * Copyright Susanne Schindler
 */


import java.util.LinkedList;

/**
 * 
 */
public class IterateModel {
    private int numberIterations;
    private Population currentPopulation;

    static final int defaultNoIterations=100000;
    static final double SDthresholdForStrongSelection = 10;
    /**
     * constructor
     * 
     */
    public IterateModel () {
	setDefaults();
	initializePopulation();
    }

    private void setDefaults(){numberIterations = defaultNoIterations; }

    private void initializePopulation(){
	currentPopulation = new Population();
    }

    public void startIteration(){
	LinkedList<Group> newGeneration;
	int countStrongSelectionOperator = 0;
	int countPropSelectionOperator = 0;

	System.out.println("Simulation starts.");
	for (int i=0; i<numberIterations; i++){
	    System.out.print("\r"+i);
	    // prepare for population replacement
	    newGeneration = Selection.selectAndMutateGroups_proportionalSelection(currentPopulation,currentPopulation.getSumFitness());
	    countPropSelectionOperator++;

	    // replace population with new set of groups
	    currentPopulation = new Population(newGeneration);
	}
	System.out.println("\n Simulation ended.");
    }


    //
    // TESTING ROUTINES
    //

    public void printList(LinkedList<Group> list){
	int count =0;
	for (Group group : list){
	    System.out.println(count+": w="+group.getW()+", a="+group.getA()+", wf="+group.getWf()+", af="+group.getAf()+", fitness="+group.getFitness()+", off="+group.getExpNoOffspring());
	    count++;
	}
    }

}



