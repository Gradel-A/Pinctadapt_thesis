#!/bin/bash

#Global variables
DATADIRECTORY=$DATAWORK/pinctadapt
DATAINPUT=$SCRATCH/04_mapped/
DATAOUTPUT=$SCRATCH/05_deduplicated/flagstat_filtered_bwa
SCRIPT=$DATADIRECTORY/00_scripts/scripts_07_flagstat_filtered_bwa
HEADER=$DATADIRECTORY/00_scripts/headerS.txt
SAMTOOLSENV=". /appli/bioinfo/samtools/latest/env.sh"


#load the name of your samples (file created for trimmomatic, cf trimmomatic code)
cd $DATADIRECTORY/00_scripts
NAME='cat base.txt'

#create output directory
mkdir -p $DATAOUTPUT
mkdir -p $SCRIPT

#start the loop for generating individual bwa mapping files
for FILE in $($NAME)
do
cp $HEADER $SCRIPT/flagstat_${FILE##*/}.sh ;
echo " #PBS -N flagstat_filtered_bwa_${FILE##*/}" >> $SCRIPT/flagstat_${FILE##*/}.sh ;
echo " #PBS -o $DATADIRECTORY/98_log_files/05_flagstat_filtered_${FILE##*/}.log" >> $SCRIPT/flagstat_${FILE##*/}.sh ;
echo "$SAMTOOLSENV"  >> $SCRIPT/flagstat_${FILE##*/}.sh ;
echo "samtools flagstat $DATAINPUT/${FILE##*/}_filtered_sorted.bam > $DATAOUTPUT/${FILE##*/}_flagstat.txt" >> $SCRIPT/flagstat_${FILE##*/}.sh ;
qsub $SCRIPT/flagstat_${FILE##*/}.sh;
done;
