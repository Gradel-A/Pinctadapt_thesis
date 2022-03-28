#/usr/bin/bash

#Global variables
DATADIRECTORY=$DATAWORK/population_genetic
DATAINPUT=/home1/datawork/agradel/population_genetic/03_results/Puce_ADN_structure_format.txt
DATAOUTPUT=$SCRATCH/population_genetic/structure
SCRIPT=$DATADIRECTORY/00_scripts/scripts_structure
HEADER=$DATADIRECTORY/01_info_files/header.txt
STRUCTUREENV=". /appli/bioinfo/structure/2.3.4/env.sh"
MAINPARAMS=/home1/datawork/agradel/population_genetic/01_info_files/mainparams.txt
EXTRAPARAMS=/home1/datawork/agradel/population_genetic/01_info_files/extraparams.txt

cd $DATADIRECTORY/00_scripts
#choosing the maximum K
MAXPOP='seq 1 8'
#choosing the number of replicates
NBREP='seq 1 5'

#create output directory
mkdir -p $DATAOUTPUT
mkdir -p $SCRIPT

#start the loop
for POP in $($MAXPOP)
do
	for REP in $($NBREP)
	do
	cp $HEADER $SCRIPT/structure_K_${POP}_${REP}.sh ;
	echo "#PBS -N structure_${POP}_${REP}" >> $SCRIPT/structure_K_${POP}_${REP}.sh ;
	echo "#PBS -o $DATADIRECTORY/98_log_files/structure_K_${POP}_${REP}.log " >> $SCRIPT/structure_K_${POP}_${REP}.sh ;
	echo "#lauch the structure software" >> $SCRIPT/structure_K_${POP}_${REP}.sh ;
	echo "$STRUCTUREENV" >> $SCRIPT/structure_K_${POP}_${REP}.sh ;
	echo "structure -m $MAINPARAMS -e $EXTRAPARAMS -K $POP -i $DATAINPUT -o $DATAOUTPUT/run_${POP}_${REP} " >> $SCRIPT/structure_K_${POP}_${REP}.sh ;

	qsub $SCRIPT/structure_K_${POP}_${REP}.sh;
done;
done;


