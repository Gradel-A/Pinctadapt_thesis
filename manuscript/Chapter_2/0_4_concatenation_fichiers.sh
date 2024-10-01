#!/usr/bin/env bash

#PBS -q sequentiel
#PBS -l mem=30gb
#PBS -l walltime=06:00:00
#PBS -o $DATAWORK/demographic_analyses/98_log_files/wall_genome_concatenation

cd /home1/scratch/agradel/wall_genome_vcf/vcftools
ls -d /home1/scratch/agradel/wall_genome_vcf/vcftools/*.vcf > /home1/scratch/agradel/wall_genome_vcf/vcftools_conc_files.txt

cd $SCRATCH/wall_genome_vcf
NAME='cat /home1/scratch/agradel/wall_genome_vcf/vcftools_conc_files.txt'

cp $SCRATCH/wall_genome_vcf/vcftools/header_vcf.txt $SCRATCH/wall_genome_vcf/allgenome_pop_filtered.vcf

for FILE in $($NAME)
do
	grep -v "#" ${FILE} &>> $SCRATCH/wall_genome_vcf/allgenome_pop_filtered.vcf;
done;

