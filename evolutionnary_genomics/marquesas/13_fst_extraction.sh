#!/usr/bin/env bash
#PBS -q mpi
#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=28:mem=115g
#PBS -o /home1/datawork/agradel/pinctadapt/98_log_files/15fst_calc.log
#PBS -N fst_calc

INDIR=/home1/scratch/agradel/06_freebayes
DATA=/home1/datawork/agradel/pinctadapt/00_scripts
VCFTOOLSENV=". /appli/bioinfo/vcftools/latest/env.sh"

cd $INDIR
$VCFTOOLSENV

#first with only one file
vcftools --vcf $INDIR/marquises_genome_pipeline_trial.vcf.recode.vcf --weir-fst-pop $DATA/MG_pop.txt --out marq_1file

#the with the two files
vcftools --vcf $INDIR/marquises_genome_pipeline_trial.vcf.recode.vcf --weir-fst-pop $DATA/MG_pop.txt --weir-fst-pop $DATA/MP_pop.txt --out marq_2files

