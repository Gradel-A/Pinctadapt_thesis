#!/usr/bin/bash

#declare variables used in the script
DATADIRECTORY=/home1/datawork/agradel/demographic_chapter
SCRIPT=$DATADIRECTORY/00_scripts/wall_genome/snp-depth
HEADER=$DATADIRECTORY/00_scripts/headerP.txt
VCFLIB=". /appli/bioinfo/vcflib/1.0.0_rc1/env.sh"
BCFTOOLS=". /appli/bioinfo/bcftools/1.17/env.sh"
DATAOUTPUT=/home1/scratch/agradel/wall_genome_vcf/vcfilter

#create the output files
mkdir -p $SCRIPT
mkdir -p $DATAOUTPUT

DPMIN="DP > 15"
DPMAX="DP < 150"
TYPE="TYPE = snp"

#go to the folder containing the data in your project folder
ls -d /home1/scratch/agradel/wall_genome_vcf/ind_selected* > /home1/scratch/agradel/wall_genome_vcf/vcfilter_file.txt

#list the file to filter
NAME='cat /home1/scratch/agradel/wall_genome_vcf/vcfilter_file.txt'

#start the loop creating individual scripts for each VCF files located in the data folder
for FILE in $($NAME) #list all the files with the fna extension and store it in the variable FILE
do
        cp $HEADER $SCRIPT/snp-depth_${FILE##*/}.sh ; # copy the header file in a new script file called snp-depth_{genome_part}.sh
        echo "#PBS -N snp-depth_${FILE##*/}" >> $SCRIPT/snp-depth_${FILE##*/}.sh ;
        echo "#PBS -o $DATADIRECTORY/98_log_files/0_2_snp-depth_${FILE##*/}.log" >> $SCRIPT/snp-depth_${FILE##*/}.sh ;
        echo "$BCFTOOLS" >> $SCRIPT/snp-depth_${FILE##*/}.sh ;
        echo "cd /home1/scratch/agradel/wall_genome_vcf" >> $SCRIPT/snp-depth_${FILE##*/}.sh ;
        echo "bcftools view ${FILE} -m2 -M2 -v snps --threads 25 -O v -o ${FILE##*/}.vcf" >> $SCRIPT/snp-depth_${FILE##*/}.sh ;
        echo "$VCFLIB" >> $SCRIPT/snp-depth_${FILE##*/}.sh;
        echo "cd $DATAOUTPUT" >> $SCRIPT/snp-depth_${FILE##*/}.sh ;
        echo "vcffilter -g \"$DPMIN\" -g \"$DPMAX\" /home1/scratch/agradel/wall_genome_vcf/${FILE##*/}.vcf &> $DATAOUTPUT/snp-depth${FILE##*/}.vcf" >> $SCRIPT/snp-depth_${FILE##*/}.sh ;
        echo "rm /home1/scratch/agradel/wall_genome_vcf/${FILE##*/}.vcf" >> $SCRIPT/snp-depth_${FILE##*/}.sh ;
        qsub $SCRIPT/snp-depth_${FILE##*/}.sh ; # append the echoed line in the script file (here we ask to submit our script to the PBS claculation nodes for execution)
done ; # we finish the loop 