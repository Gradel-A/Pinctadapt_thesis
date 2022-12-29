#!/usr/bin/env bash
#PBS -N admixture
#PBS -q mpi_1
#PBS -l ncpus=28
#PBS -l mem=60gb
#PBS -l walltime=48:00:00
#PBS -o /home1/datawork/agradel/population_genetic/98_log_files/admixture.log

#Global variables
DATADIRECTORY=$DATAWORK/population_genetic
DATAINPUT=$DATADIRECTORY/02_data
DATAOUTPUT=$SCRATCH/population_genetic/admixture
ADMIXTURENV=". /appli/bioinfo/admixture/1.3.0/env.sh"
PLINK="/appli/bioinfo/plink/1.9/plink"
NCPU=28

mkdir -p $DATAOUTPUT

# first we will transforme the vcf file into the bed format require by admixture
cd $DATAINPUT
$PLINK --allow-extra-chr --vcf $DATAINPUT/chip_pinctadapt_data_cleaned.vcf --make-bed --out $DATAINPUT/chip_pinctadapt_data_cleaned

# ADMIXTURE does not accept chromosome names that are not human chromosomes. We will thus just exchange the first column by 0
awk '{$1="0";print $0}' chip_pinctadapt_data_cleaned.bim > chip_pinctadapt_data_cleaned.bim.tmp
mv chip_pinctadapt_data_cleaned.bim.tmp chip_pinctadapt_data_cleaned.bim


# Now perform the analyses from k=1 to k=10 with statistiques implement in the software
$ADMIXTURENV

cd $DATAOUTPUT
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 1 -j28 | tee log_1.log
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 2 -j28 | tee log_2.log
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 3 -j28 | tee log_3.log
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 4 -j28 | tee log_4.log
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 5 -j28 | tee log_5.log
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 6 -j28 | tee log_6.log
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 7 -j28 | tee log_7.log
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 8 -j28 | tee log_8.log
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 9 -j28 | tee log_9.log
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 10 -j28 | tee log_10.log


