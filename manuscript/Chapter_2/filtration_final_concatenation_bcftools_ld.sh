#!/usr/bin/bash

#declare variables used in the script
DATADIRECTORY=$DATAWORK/pinctadapt
DATAOUTPUT=/home1/scratch/agradel/06_freebayes/concatenation


#create the output files
mkdir -p $DATAOUTPUT

#go to the folder containing the data in your project folder
cd $SCRATCH/06_freebayes/partial_bcftools_ld
ls -d /home1/scratch/agradel/06_freebayes/partial_bcftools_ld/*.vcf > /home1/scratch/agradel/06_freebayes/vcf_concatener.txt

NAME='cat /home1/scratch/agradel/06_freebayes/vcf_concatener.txt'

#grep ^# prunned*.vcf > header.txt

#start the loop creating individual scripts for each VCF files located in the data folder
cat /home1/scratch/agradel/06_freebayes/partial_bcftools_ld/header.txt > $DATAOUTPUT/dadi_data_superclean_20240918.vcf
for FILE in $($NAME) #list all the files with the fna extension and store it in the variable FILE
do
        grep -v "^#" $FILE > $DATAOUTPUT/genetic_info_${FILE##*/}.txt;
        cat $DATAOUTPUT/genetic_info_${FILE##*/}.txt >> $DATAOUTPUT/dadi_data_superclean_20240918.vcf
done ; # we finish the loop

