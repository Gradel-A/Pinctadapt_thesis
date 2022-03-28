#!/usr/bin/env bash

#PBS -q sequentiel
#PBS -l mem=30gb
#PBS -l walltime=06:00:00
#PBS -o $DATAWORK/pinctadapt/98_log_files/06_freebayes_raw_vcf_assembling.txt

cd $SCRATCH/06_freebayes
NAME='cat sorted_vcf_to_concatenate.txt'

grep "^#" partial/vcf_part_Pinctada_margaritifera_genome_v2.scaff_oneliner.fna.vcf &> raw_vcf_all.vcf

for FILE in $($NAME)
do
	grep -v "#" ${FILE} &>> raw_vcf_all.vcf;
done;

