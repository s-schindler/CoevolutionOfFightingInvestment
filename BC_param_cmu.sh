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

for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_001_"$seed ; java StartSimulation param_cmu001 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_002_"$seed ; java StartSimulation param_cmu002 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_003_"$seed ; java StartSimulation param_cmu003 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_004_"$seed ; java StartSimulation param_cmu004 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_005_"$seed ; java StartSimulation param_cmu005 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_006_"$seed ; java StartSimulation param_cmu006 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_007_"$seed ; java StartSimulation param_cmu007 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_008_"$seed ; java StartSimulation param_cmu008 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_009_"$seed ; java StartSimulation param_cmu009 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="cmu_01_"$seed ; java StartSimulation param_cmu01 $seed $outputFilename ;done;
