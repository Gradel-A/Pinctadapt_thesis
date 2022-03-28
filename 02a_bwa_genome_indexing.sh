#!/usr/bin/env bash
#PBS -q sequentiel
#PBS -l mem=10gb
#PBS -l walltime=01:00:00
#PBS -o $DATAWORK/pinctadapt/98_log_files/03a_bwa_index.txt

#Global variables
DATADIRECTORY=$DATAWORK/pinctadapt
HEADER=$DATADIRECTORY/00_scripts/headerS.txt
BWAENV=". /appli/bioinfo/bwa/latest/env.sh"
ASSEMBLY=$DATADIRECTORY/genome/Pinctada_margaritifera_genome_v2.scaff_oneliner.fna



#index the genome
$BWAENV

bwa index $ASSEMBLY
