#!/usr/bin/env bash
#PBS -q mpi
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=28:mem=115g
#PBS -o /home1/datawork/agradel/pincadapt/98_log_files/10a_vcftools_missInd.txt
#PBS -N vcftools_missing

INDIR=/home1/scratch/agradel/06_freebayes
VCFTOOLSENV=". /appli/bioinfo/vcftools/latest/env.sh"

$VCFTOOLSENV
cd $INDIR

vcftools --depth --vcf  clean_vcf_all.vcf --out  vcf_DP15nc_depth

vcftools --vcf $INDIR/clean_vcf_all.vcf  --missing-indv

sort -k 5 -nr out.imiss &> sorted_out_DP20nc.01.miss

#vcftools --remove /home1/datawork/agradel/pinctadapt/00_scripts/marquises_indiv_data_missing.txt --vcf $INDIR/marquises_DP20_snp.vcf_maf0.02_miss_0.85_biallelic.recode.vcf --recode --out $INDIR/marquises_genome_pipeline_trial.vcf

