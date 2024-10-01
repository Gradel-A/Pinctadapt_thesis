#!/usr/bin/env bash

#PBS -q sequentiel
#PBS -l mem=30gb
#PBS -l walltime=06:00:00
#PBS -o $DATAWORK/demographic_analyses/98_log_files/wall_genome_concatenation

cd wall_genome_vcf/vcftools
ls -d wall_genome_vcf/vcftools/*.vcf > wall_genome_vcf/vcftools_conc_files.txt

cd $SCRATCH/wall_genome_vcf
NAME='cat vcftools_conc_files.txt'

cp vcftools/header_vcf.txt allgenome_pop_filtered.vcf

for FILE in $($NAME)
do
	grep -v "#" ${FILE} &>> allgenome_pop_filtered.vcf;
done;

