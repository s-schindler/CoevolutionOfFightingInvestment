#!/bin/bash

#! Requesting resource (processors and wall-clock time):
#PBS -l nodes=1:ppn=1,walltime=200:10:00

#! change the working directory (default is home directory)
cd $PBS_O_WORKDIR

#! Record some useful job details in the output file
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo PBS job ID is $PBS_JOBID
echo This jobs runs on the following nodes:
echo `cat $PBS_NODEFILE | uniq`

module add languages/java-jdk-1.7.0-40

for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_10_"$seed ; java StartSimulation param_noGroups10 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_20_"$seed ; java StartSimulation param_noGroups20 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_100_"$seed ; java StartSimulation param_noGroups100 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_200_"$seed ; java StartSimulation param_noGroups200 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_30_"$seed ; java StartSimulation param_noGroups30 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_300_"$seed ; java StartSimulation param_noGroups300 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_75_"$seed ; java StartSimulation param_noGroups75 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_500_"$seed ; java StartSimulation param_noGroups500 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_50_"$seed ; java StartSimulation param_noGroups50 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_400_"$seed ; java StartSimulation param_noGroups400 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="noGroups_40_"$seed ; java StartSimulation param_noGroups40 $seed $outputFilename ;done;
