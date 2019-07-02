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

for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca00125_cd00125_"$seed ; java StartSimulation param_cm0025_ca00125_cd00125 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca0025_cd00125_"$seed ; java StartSimulation param_cm0025_ca0025_cd00125 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca005_cd00125_"$seed ; java StartSimulation param_cm0025_ca005_cd00125 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca01_cd00125_"$seed ; java StartSimulation param_cm0025_ca01_cd00125 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca00125_cd0025_"$seed ; java StartSimulation param_cm0025_ca00125_cd0025 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca0025_cd0025_"$seed ; java StartSimulation param_cm0025_ca0025_cd0025 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca005_cd0025_"$seed ; java StartSimulation param_cm0025_ca005_cd0025 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca01_cd0025_"$seed ; java StartSimulation param_cm0025_ca01_cd0025 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca00125_cd005_"$seed ; java StartSimulation param_cm0025_ca00125_cd005 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca0025_cd005_"$seed ; java StartSimulation param_cm0025_ca0025_cd005 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca005_cd005_"$seed ; java StartSimulation param_cm0025_ca005_cd005 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca01_cd005_"$seed ; java StartSimulation param_cm0025_ca01_cd005 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca00125_cd01_"$seed ; java StartSimulation param_cm0025_ca00125_cd01 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca0025_cd01_"$seed ; java StartSimulation param_cm0025_ca0025_cd01 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca005_cd01_"$seed ; java StartSimulation param_cm0025_ca005_cd01 $seed $outputFilename ;done;
for i in {1..100}; do seed=$(awk NR==$i listOfRandomSeeds_100simulations) ; outputFilename="ca01_cd01_"$seed ; java StartSimulation param_cm0025_ca01_cd01 $seed $outputFilename ;done;
