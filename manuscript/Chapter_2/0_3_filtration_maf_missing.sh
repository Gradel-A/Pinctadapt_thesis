#!/usr/bin/bash

#declare variables used in the script
DATADIRECTORY=/home1/datawork/agradel/demographic_chapter
SCRIPT=$DATADIRECTORY/00_scripts/wall_genome/vcftools
HEADER=$DATADIRECTORY/00_scripts/headerP.txt
VCFTOOLS=". /appli/bioinfo/vcftools/0.1.16/env.sh"
DATAOUTPUT=/home1/scratch/agradel/wall_genome_vcf/vcftools

#create the output files
mkdir -p $SCRIPT
mkdir -p $DATAOUTPUT

MAF=0.05
MISSING=0.8

#go to the folder containing the data in your project folder
ls -d /home1/scratch/agradel/wall_genome_vcf/vcfilter/*.vcf > /home1/scratch/agradel/wall_genome_vcf/vcftools_file.txt

#list the file to filter
NAME='cat /home1/scratch/agradel/wall_genome_vcf/vcftools_file.txt'

#start the loop creating individual scripts for each VCF files located in the data folder
for FILE in $($NAME) #list all the files with the fna extension and store it in the variable FILE
do
        cp $HEADER $SCRIPT/maf-missing_${FILE##*/}.sh ; # copy the header file in a new script file called maf-missing_{genome_part}.sh
        echo "#PBS -N maf-missing_${FILE##*/}" >> $SCRIPT/maf-missing_${FILE##*/}.sh ;
        echo "wc -l ${FILE}" >> $SCRIPT/maf-missing_${FILE##*/}.sh ;
        echo "#PBS -o $DATADIRECTORY/98_log_files/0_2_maf-missing_${FILE##*/}.log" >> $SCRIPT/maf-missing_${FILE##*/}.sh ;
        echo "$VCFTOOLS" >> $SCRIPT/maf-missing_${FILE##*/}.sh ;
        echo "cd /home1/scratch/agradel/wall_genome_vcf" >> $SCRIPT/maf-missing_${FILE##*/}.sh ;
        echo "vcftools --temp $SCRATCH --maf $MAF --max-missing $MISSING --vcf ${FILE} --recode --out $DATAOUTPUT/maf_NA_${FILE##*/}" >> $SCRIPT/maf-missing_${FILE##*/}.sh ;
    #    echo "rm /home1/scratch/agradel/wall_genome_vcf/${FILE##*/}.vcf" >> $SCRIPT/maf-missing_${FILE##*/}.sh ;
        qsub $SCRIPT/maf-missing_${FILE##*/}.sh ; # append the echoed line in the script file (here we ask to submit our script to the PBS claculation nodes for execution)
done ; # we finish the loop 