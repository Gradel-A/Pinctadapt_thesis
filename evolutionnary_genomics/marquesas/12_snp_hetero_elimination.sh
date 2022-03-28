#!/usr/bin/env bash
#PBS -q mpi
#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=28:mem=115g
#PBS -o /home1/datawork/agradel/pincadapt/98_log_files/14snp_elemination.log
#PBS -N snp_elemination

INDIR=/home1/scratch/agradel/06_freebayes
VCFTOOLSENV=". /appli/bioinfo/vcftools/latest/env.sh"

$VCFTOOLSENV
#cd $INDIR

# first of all we collect the heterozygous statistics
#vcftools --vcf $INDIR/marquises_DP20_snp.vcf_maf0.02_miss_0.85_biallelic.recode_noComplex.vcf --hardy --out marquises_hetero

#then we use the statistics to collect the position of the loci with to many heterozygotes
#grep "/16/\|/17/\|/18/" /home1/scratch/agradel/06_freebayes/marquises_hetero.hwe > marquises_loci.txt
#awk '{print $1, $2}' OFS='\t' marquises_loci.txt > marquises_loci_elimination.txt

#to finish we delate the loci
vcftools --exclude-positions /home1/scratch/agradel/06_freebayes/marquises_loci_elimination.txt --vcf $INDIR/marquises_DP20_snp.vcf_maf0.02_miss_0.85_biallelic.recode_noComplex.vcf --recode --out $INDIR/marquises_genome_pipeline_trial.vcf

#rm marquises_hetero.hwe
#rm marquises_loci.txt
