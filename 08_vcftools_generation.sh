#!/usr/bin/bash

#declare variables used in the script
DATADIRECTORY=$DATAWORK/pinctadapt
DATAOUTPUT=$SCRATCH/06_freebayes/partial_vctools
SCRIPT=$DATADIRECTORY/00_scripts/partial_filter/vcftools
HEADER=$DATADIRECTORY/00_scripts/headerS.txt
VCFTOOLSENV=". /appli/bioinfo/vcftools/latest/env.sh"


#create the output files
mkdir -p $SCRIPT
mkdir -p $DATAOUTPUT

#go to the folder containing the data in your project folder
cd $SCRATCH/06_freebayes/partial_filter
ls -d /home1/scratch/agradel/06_freebayes/partial_filter/*.vcf> /home1/scratch/agradel/06_freebayes/vcftools_files.txt

#list the file to filter
NAME='cat /home1/scratch/agradel/06_freebayes/vcftools_files.txt'
MAF=0.05
MISSING=0.8


#start the loop creating individual scripts for each VCF files located in the data folder
for FILE in $($NAME) #list all the files with the fna extension and store it in the variable FILE
do
        cp $HEADER $SCRIPT/vcftools_${FILE##*/}.sh ; # copy the header file in a new script file called vcftools_{genome_part}.sh
        echo "#PBS -N vcftools_${FILE##*/}" >> $SCRIPT/vcftools_${FILE##*/}.sh ;
        echo "#PBS -o $DATADIRECTORY/98_log_files/08_vcftools_${FILE##*/}.log" >> $SCRIPT/vcftools_${FILE##*/}.sh ;
        echo "cd $SCRATCH/06_freebayes/partial_filter" >> $SCRIPT/vcftools_${FILE##*/}.sh ; # append the echoed line in the script file (we go to the data folder of our project)
        echo "$VCFTOOLSENV" >> $SCRIPT/vcftools_${FILE##*/}.sh ; # preparing the vcftools
        echo "vcftools --temp $SCRATCH --maf $MAF --max-missing $MISSING --vcf ${FILE} --recode --out $DATAOUTPUT/filter_maf_NA_${FILE##*/}" >> $SCRIPT/vcftools_${FILE##*/}.sh ;
        #qsub $SCRIPT/vcftools_${FILE##*/}.sh ; # append the echoed line in the script file (here we ask to submit our script to the PBS claculation nodes for execution)
done ; # we finish the loop

