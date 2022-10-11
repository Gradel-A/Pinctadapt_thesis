#!/usr/bin/env bash

#PBS -q sequentiel
#PBS -l walltime=01:00:00
#PBS -l mem=60gb
#PBS -N chipseq_data_processing
#PBS -o /home1/datawork/agradel/population_genetic/98_log_files/chipseq_data_processing.log

#declare variables used in the scripts
DATADIRECTORY=/home1/datawork/agradel/population_genetic
INPUT=$DATADIRECTORY/02_data/puce_final
PLINK="/appli/bioinfo/plink/1.9/plink"

#first we have to take only the individuals of our project
$PLINK --bfile $INPUT/batch_1_SNParray_70k_Pmarg_PINCTADAPT_NO_APK --keep-fam $DATADIRECTORY/01_info_files/family_list_pinctadapt.txt --make-bed --allow-extra-chr --out $SCRATCH/population_genetic/tmp

#secondly exclude individuals (1 scilly 47%) and SNPs (2273) with to much missing
$PLINK --bfile $SCRATCH/population_genetic/tmp --geno 0.2 --mind 0.1 --make-bed --allow-extra-chr --out $SCRATCH/population_genetic/tmp2

#now we will remove the SNPs with a minimum allele frequency under 0.05 like in litterature (11 238)
$PLINK --bfile $SCRATCH/population_genetic/tmp2 --maf 0.05 --make-bed --allow-extra-chr --out $SCRATCH/population_genetic/tmp3


#finaly make the vcf for the further analyses and remove tmp files
$PLINK --bfile $SCRATCH/population_genetic/tmp3 --recode vcf --allow-extra-chr --out $INPUT/chip_pinctadapt_data_cleaned

rm $SCRATCH/population_genetic/tmp*
rm $SCRATCH/population_genetic/tmp2*
rm $SCRATCH/population_genetic/tmp3*

#extract a population and the snps of a list
#$PLINK --bfile $INPUT/chipseq_pinctadapt_data --keep-fam $SCRATCH/JAPJuv.txt --extract /home1/scratch/agradel/snp_list.txt --make-bed --recode vcf --allow-extra-chr --out $SCRATCH/population_genetic/chipseq_jap