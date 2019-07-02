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

for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_1_"$seed ; java StartSimulation param_k1 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_3_"$seed ; java StartSimulation param_k3   $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_6_"$seed ; java StartSimulation param_k6   $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_12_"$seed ; java StartSimulation param_k12  $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_25_"$seed ; java StartSimulation param_k25  $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_50_"$seed ; java StartSimulation param_k50  $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_75_"$seed ; java StartSimulation param_k75  $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_100_"$seed ; java StartSimulation param_k100 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_200_"$seed ; java StartSimulation param_k200 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_300_"$seed ; java StartSimulation param_k300 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_500_"$seed ; java StartSimulation param_k500 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_700_"$seed ; java StartSimulation param_k700 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="k_1000_"$seed ; java StartSimulation param_k1000 $seed $outputFilename ;done;
