/*
 * Author: Susanne Schindler
 * Date: 18.5.2018
 * Email: Susanne.Schindler2@web.de
 * Copyright Susanne Schindler
 */


import java.io.File;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.Writer;
import java.io.FileInputStream;
import java.util.Properties;
import java.text.DecimalFormat;
import java.util.Random;


/**
 * main class to start a simulation
 */
public class StartSimulation {
 
    private static String inputFileName;
    private static String outputFileName;
    private static final String defaultOutputFileName = "Output/populationOverTime";
    private static final Long defaultRandomSeed1 = new Long(22021924);
    private static final Long defaultRandomSeed2 = new Long(22022022);
    private static final Long defaultRandomSeed3 = new Long(22021957);
    private static final Long defaultRandomSeed4 = new Long(22021918);
 
    /**
     * 
     * @param argv[]  one, two, or three Parameters can be set
     *        argv[0]...input file for parameters
     *        argv[1]...random seed
     *        argv[2]...addon to output filename
     */
    public static void main (String argv[]) {
        IterateModel m;

	Mutation.setDefaultMutationRate();
	Mutation.setDefaultMutationIncr();
	Mutation.setDefaultSDforMutationIncr();
	setInputFileName(argv[0]);
	Population.setNoGroups(readNoGroupsFromFile());
	Population.setParameters(readParametersFromFile());

        switch (argv.length) {
	case 1:
	    setOutputFileName(defaultOutputFileName);
	    createOutputFiles();
	    initiateRandomGenerators(); 
	    break;
	case 2:
	    setOutputFileName(defaultOutputFileName+"_"+argv[1]);
	    createOutputFiles();
	    initiateRandomGenerators(Long.parseLong(argv[1]));
	    break;
	case 3:
	    setOutputFileName(defaultOutputFileName+"_"+argv[2]);
	    createOutputFiles();
	    initiateRandomGenerators(Long.parseLong(argv[1]));
	    break;
	default:
	    System.out.println("StartSimulation: main: Incorrect number of parameters.");
        }
	m = new IterateModel();
	m.startIteration();
    }

    private static void initiateRandomGenerators(){
	Group.initiateRandomGenerator(defaultRandomSeed1);
	Selection.initiateRandomGenerator(defaultRandomSeed2);
	Mutation.initiateRandomGenerator(defaultRandomSeed3);
	Population.initiateRandomGenerator(defaultRandomSeed4);
    }

    private static void initiateRandomGenerators(long seed){
	Random randomGenerator = new Random(seed);
	Group.initiateRandomGenerator(randomGenerator.nextLong());
	Selection.initiateRandomGenerator(randomGenerator.nextLong());
	Mutation.initiateRandomGenerator(randomGenerator.nextLong());
	Population.initiateRandomGenerator(randomGenerator.nextLong());
    }

    private static void setInputFileName(String name){
	inputFileName = name;
    }

    private static void setOutputFileName(String name){
	outputFileName = name;
    }

    private static void createOutputFiles(){
	try {
	    File file1 = new File(outputFileName);
	    if(file1.exists())
		file1.delete(); // delete file to write to empty file
	    /* (re)create it  */
	    file1.createNewFile();
	}catch (Exception e) {
	    System.out.println("StartSimulation:createOutputFiles:"+e.getMessage());
	}
    }

    private static int readNoGroupsFromFile(){
	int noGroups=-1;
	try {
	    Properties prop = new Properties();
	    prop.load(new FileInputStream(inputFileName));

	    String propName = "noGroups";
	    noGroups = Integer.parseInt(prop.getProperty(propName));
	}        
	catch (Exception e) {
	    System.out.println("StartSimulation:readNoGroupsFromFile: " + e.getMessage());
	}
	return noGroups;
    }

    private static double[] readParametersFromFile(){
	double[] parameterArray = new double[Population.getNoParameters()];
	String propName;
	try {
	    Properties prop = new Properties();
	    prop.load(new FileInputStream(inputFileName));

	    propName = "k";
	    parameterArray[0] = Double.parseDouble(prop.getProperty(propName));
	    propName = "ca";
	    parameterArray[1] = Double.parseDouble(prop.getProperty(propName));
	    propName = "cd";
	    parameterArray[2] = Double.parseDouble(prop.getProperty(propName));
	    propName = "cm";
	    parameterArray[3] = Double.parseDouble(prop.getProperty(propName));
	    propName = "mu";
	    parameterArray[4] = Double.parseDouble(prop.getProperty(propName));
	    propName = "cmu";
	    parameterArray[5] = Double.parseDouble(prop.getProperty(propName));
	}        
	catch (Exception e) {
	    System.out.println("StartSimulation:readParametersFromFile: " + e.getMessage());
	}
	return parameterArray;
    }

    static void printToFile(int arraySize, double[] array){
	/* output to file */
	try {
	    printToStream(arraySize,array,new BufferedWriter(new FileWriter(new File(outputFileName),Boolean.TRUE)));
	} catch (Exception e) {
	    System.out.println("StartSimulation:printToFile:"+e.getMessage());
	}
    }

    private static void printToStream(int arraySize, double[] array, Writer bs){
	try{
	    DecimalFormat df = new DecimalFormat();
	    df.setMaximumFractionDigits(4);	
	    for (int i=0; i<arraySize; i++)
		bs.write(df.format(array[i])+"\t");

	    bs.write("\n");
	    bs.close();
	}catch (Exception e) {
	    System.out.println("StartSimulation:printToStream:"+e.getMessage());
	}
    }

}



