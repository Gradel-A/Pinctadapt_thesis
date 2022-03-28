#!/usr/bin/env bash

#PBS -q sequentiel
#PBS -l mem=30gb
#PBS -l walltime=06:00:00
#PBS -o $DATAWORK/pinctadapt/98_log_files/06_freebayes_raw_vcf_assembling.txt

cd $SCRATCH/06_freebayes/partial_filter
ls -d /home1/scratch/agradel/06_freebayes/partial_bcftools/*.vcf > /home1/scratch/agradel/06_freebayes/conc_bcftools_files.txt

cd $SCRATCH/06_freebayes
NAME='cat /home1/scratch/agradel/06_freebayes/conc_bcftools_files.txt'

grep "^#" /home1/scratch/agradel/06_freebayes/partial_bcftools/bcftools_filter_maf_NA_DP15_DP150_snp_vcf_part_Pinctada_margaritifera_genome_v2.scaff_oneliner_1-250_1-25.fna.vcf.vcf.recode.vcf &> bcf_vcf_all.vcf

for FILE in $($NAME)
do
	grep -v "#" ${FILE} &>> bcf_vcf_all.vcf;
done;

