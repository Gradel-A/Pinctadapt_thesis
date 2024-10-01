#!/usr/bin/env bash

#PBS -q mpi_1
#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=28:mpiprocs=28:mem=30gb


#PBS -N 10percent_na_filtration
#PBS -o /home1/datawork/agradel/demographic_chapter/98_log_files/allgenome_pop_filtered_10percentNA.log


. /appli/bioinfo/vcftools/0.1.16/env.sh
cd /home1/scratch/agradel/wall_genome_vcf
vcftools --temp /home1/scratch/agradel --max-missing 0.9 --vcf /home1/scratch/agradel/wall_genome_vcf/allgenome_pop_filtered.vcf --recode --out /home1/scratch/agradel/wall_genome_vcf/allgenome_pop_filtered_10percent_NA.vcf
