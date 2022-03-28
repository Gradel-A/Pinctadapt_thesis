#!/usr/bin/bash

#declare variables used in the script
DATADIRECTORY=$DATAWORK/pinctadapt
DATAOUTPUT=$SCRATCH/06_freebayes/partial_bcftools
SCRIPT=$DATADIRECTORY/00_scripts/partial_filter/bcftools
HEADER=$DATADIRECTORY/00_scripts/headerS.txt
BCFTOOLSENV=". /appli/bioinfo/bcftools/latest/env.sh"


#create the output files
mkdir -p $SCRIPT
mkdir -p $DATAOUTPUT

#go to the folder containing the data in your project folder
cd $SCRATCH/06_freebayes/partial_filter
ls -d /home1/scratch/agradel/06_freebayes/partial_vctools/*.vcf> /home1/scratch/agradel/06_freebayes/bcftools_files.txt

#list the file to filter
NAME='cat /home1/scratch/agradel/06_freebayes/bcftools_files.txt'
NBALL=2



#start the loop creating individual scripts for each VCF files located in the data folder
for FILE in $($NAME) #list all the files with the fna extension and store it in the variable FILE
do
        cp $HEADER $SCRIPT/bcftools_${FILE##*/}.sh ; # copy the header file in a new script file called bcftools_{genome_part}.sh
        echo "#PBS -N bcftools_${FILE##*/}" >> $SCRIPT/bcftools_${FILE##*/}.sh ;
        echo "#PBS -o $DATADIRECTORY/98_log_files/08_bcftools_${FILE##*/}.log" >> $SCRIPT/bcftools_${FILE##*/}.sh ;
        echo "cd $SCRATCH/06_freebayes/partial_filter" >> $SCRIPT/bcftools_${FILE##*/}.sh ; # append the echoed line in the script file (we go to the data folder of our project)
        echo "$BCFTOOLSENV" >> $SCRIPT/bcftools_${FILE##*/}.sh ; # preparing the bcftools
        echo "bcftools view -m2 -M2 -v snps ${FILE} -o $DATAOUTPUT/bcftools_${FILE##*/}" >> $SCRIPT/bcftools_${FILE##*/}.sh ;
        #qsub $SCRIPT/bcftools_${FILE##*/}.sh ; # append the echoed line in the script file (here we ask to submit our script to the PBS claculation nodes for execution)
done ; # we finish the loop

