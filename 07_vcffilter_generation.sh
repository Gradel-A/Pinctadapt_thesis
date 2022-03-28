#!/usr/bin/bash

#declare variables used in the script
DATADIRECTORY=$DATAWORK/pinctadapt
DATAOUTPUT=$SCRATCH/06_freebayes/partial_filter
SCRIPT=$DATADIRECTORY/00_scripts/partial_filter
HEADER=$DATADIRECTORY/00_scripts/headerP.txt
VCFLIB=". /appli/bioinfo/vcflib/1.0.0_rc1/env.sh"


#create the output files
mkdir -p $SCRIPT
mkdir -p $DATAOUTPUT

#go to the folder containing the data in your project folder
cd $SCRATCH/06_freebayes/partial

#list the file to filter
NAME='cat /home1/scratch/agradel/06_freebayes/sorted_vcf_to_concatenate.txt'
DPMIN="DP > 15"
DPMAX="DP < 150"
TYPE="TYPE = snp"
#start the loop creating individual scripts for each VCF files located in the data folder
for FILE in $($NAME) #list all the files with the fna extension and store it in the variable FILE
do
        cp $HEADER $SCRIPT/vcffilter_${FILE##*/}.sh ; # copy the header file in a new script file called vcffilter_{genome_part}.sh
        echo "#PBS -N vcffilter_${FILE##*/}" >> $SCRIPT/vcffilter_${FILE##*/}.sh ;
        echo "#PBS -o $DATADIRECTORY/98_log_files/07_vcffilter_${FILE##*/}.log" >> $SCRIPT/vcffilter_${FILE##*/}.sh ;
        echo "cd $SCRATCH/06_freebayes/partial" >> $SCRIPT/vcffilter_${FILE##*/}.sh ; # append the echoed line in the script file (we go to the data folder of our project)
        echo "$VCFLIB" >> $SCRIPT/vcffilter_${FILE##*/}.sh ; # preparing the vcftools
        echo vcffilter -g \"$DPMIN\" -g \"$DPMAX\" -f \"$TYPE\" ${FILE} &> $DATAOUTPUT/DP15_DP150_snp_${FILE##*/}.vcf >> $SCRIPT/vcffilter_${FILE##*/}.sh ;
        qsub $SCRIPT/vcffilter_${FILE##*/}.sh ; # append the echoed line in the script file (here we ask to submit our script to the PBS claculation nodes for execution)
done ; # we finish the loop

