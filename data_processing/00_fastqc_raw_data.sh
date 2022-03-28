#!/usr/bin/bash

#declare variables used in the script
DATADIRECTORY=$DATAWORK/pinctadapt
DATAOUTPUT=$DATADIRECTORY/02_data/00_fastqc_raw
SCRIPT=$DATADIRECTORY/00_scripts/fastqc_raw_scripts
HEADER=$DATADIRECTORY/00_scripts/headerS.txt
FASTQCENV=". /appli/bioinfo/fastqc/latest/env.sh"


#create the output files
mkdir -p $SCRIPT
mkdir -p $DATAOUTPUT

#go to the folder containing the data in your project folder
cd $DATADIRECTORY/02_data

#start the loop creating individual scripts for each fastq files located in the data folder
for FILE in $(ls *.fastq.gz) #list all the files with the fastq.gz extension and store it in the variable FILE
do
        cp $HEADER $SCRIPT/fastqc_${FILE##*/}.sh ; # copy the header file in a new script file called fastqc_{individual name of file}.sh
        echo "#PBS -N fastqc_${FILE##*/}" >> $SCRIPT/fastqc_${FILE##*/}.sh ;
        echo "#PBS -o $DATADIRECTORY/98_log_files/00_fastqc_pe_${file##*/}.log" >> $SCRIPT/fastqc_${FILE##*/}.sh ;
        echo "cd $DATADIRECTORY/02_data" >> $SCRIPT/fastqc_${FILE##*/}.sh ; # append the echoed line in the script file (we go to the data folder of our project)
        echo "$FASTQCENV"  >> $SCRIPT/fastqc_${FILE##*/}.sh ; # append the echoed line in the script file (here we load the fastqc environment)
        echo "fastqc $FILE -o $DATAOUTPUT" >> $SCRIPT/fastqc_${FILE##*/}.sh ; # append the echoed line in the script file (this is the command line of the program fastc)
        qsub $SCRIPT/fastqc_${FILE##*/}.sh ; # append the echoed line in the script file (here we ask to submit our script to the PBS claculation nodes for execution)
done ; # we finish the loop

