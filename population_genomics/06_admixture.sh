#!/usr/bin/env bash
#PBS -N admixture
#PBS -q mpi_1
#PBS -l ncpus=28
#PBS -l mem=60gb
#PBS -l walltime=48:00:00
#PBS -o $DATAWORK/pinctadapt/98_log_files/admixture.txt

#Global variables
DATADIRECTORY=$DATAWORK/population_genetic
DATAINPUT=$DATADIRECTORY/02_data
DATAOUTPUT=$SCRATCH/population_genetic/admixture
ADMIXTURENV=". /appli/bioinfo/admixture/1.3.0/env.sh"
PLINK="/appli/bioinfo/plink/1.9/plink"
NCPU=28

mkdir -p $DATAOUTPUT

# first we will transforme the vcf file into the bed format require by admixture
/appli/bioinfo/plink/1.9/plink --allow-extra-chr --vcf $DATAINPUT/chip_pinctadapt_data_cleaned.vcf --make-bed --out $DATAINPUT/chip_pinctadapt_data_cleaned

# Now perform the analyses from k=1 to k=10 with statistiques implement in the software
$ADMIXTURENV

cd $DATAOUTPUT
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 1 -B50 -j28 | tee log_1.out
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 2 -B50 -j28 | tee log_2.out
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 3 -B50 -j28 | tee log_3.out
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 4 -B50 -j28 | tee log_4.out
admixture --cv --seed=50 $DATAINPUT/chip_pinctadapt_data_cleaned.bed 5 -B50 -j28 | tee log_5.out
