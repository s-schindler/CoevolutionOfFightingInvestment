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

for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_001_"$seed ; java StartSimulation param_cm001 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_002_"$seed ; java StartSimulation param_cm002 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_003_"$seed ; java StartSimulation param_cm003 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_004_"$seed ; java StartSimulation param_cm004 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_005_"$seed ; java StartSimulation param_cm005 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_006_"$seed ; java StartSimulation param_cm006 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_007_"$seed ; java StartSimulation param_cm007 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_008_"$seed ; java StartSimulation param_cm008 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_009_"$seed ; java StartSimulation param_cm009 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cm_01_"$seed ; java StartSimulation param_cm01 $seed $outputFilename ;done;
