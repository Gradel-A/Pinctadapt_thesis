#!/bin/bash

#Global variables
DATADIRECTORY=$DATAWORK/pinctadapt
DATAINPUT=$SCRATCH/04_mapped
DATAOUTPUT=$SCRATCH/04_mapped/bam_dedup
SCRIPT=$DATADIRECTORY/00_scripts/scripts_03_bam_dedup
HEADER=$DATADIRECTORY/00_scripts/headerP.txt
SAMBAMBAENV=". /appli/bioinfo/sambamba/0.8.0/env.sh"
NCPU=28

#load the name of your samples (file created for trimmomatic, cf trimmomatic code)
cd $DATADIRECTORY/00_scripts
NAME='cat base.txt'

#create output directory
mkdir -p $DATAOUTPUT
mkdir -p $SCRIPT

#start the loop for generating individual bwa mapping files
for FILE in $($NAME)

do
cp $HEADER $SCRIPT/sambamba_${FILE##*/}.sh ;
echo "#PBS -N sambamba_raw_bwa_${FILE##*/}" >> $SCRIPT/sambamba_${FILE##*/}.sh ;
echo "#PBS -o $DATADIRECTORY/98_log_files/03_sambamba_raw_bwa_"$FILE".log" >> $SCRIPT/sambamba_${FILE##*/}.sh ;
echo "$SAMBAMBAENV"  >> $SCRIPT/sambamba_${FILE##*/}.sh ;
echo "sambamba markdup -r -t "$NCPU" --tmpdir $SCRATCH $DATAINPUT/"$FILE"_filtered_sorted.bam $DATAOUTPUT/"$FILE"_sambamba.bam" >> $SCRIPT/sambamba_${FILE##*/}.sh ;
qsub $SCRIPT/sambamba_${FILE##*/}.sh;
done;