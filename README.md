# CoevolutionOfFightingInvestment
Code to replicate study on the co-evolution of fighting investment and its allocation to attack versus defence.

There are threse steps needed for replication:

1) Run the computer simulations.
   For this use the java-files in the branch 'standardModel'. When replicating the findings regarding different parameter values, use the java-file in the branch 'standardModel' together with the parameter files in the branches named 'EffectParamter_<parameter name>'. The shell scripts provide an idea how to run them automatically. Note that you will have to adjust the names of directories in both java-files as well as in the script-files to run the simulations successfully on your computer. When running the simulations that scrutinize the effect of the home/surprise advantage, please use the java-files in the branch 'EffectParameter_homeAdvantage'.
  
2) Pool the data.
   Each simulation creates one output file. The matlab-scripts in the branch 'PoolingDataFromOutputFiles' open each output file and save relevant quantities into arrays. The scripts also calculate cumulative measures.
 
3) Visualize pooled data.
   To create the same figures as in the manuscript, please use the matlab-scripts in the branch 'VisualisationScripts'.
   
