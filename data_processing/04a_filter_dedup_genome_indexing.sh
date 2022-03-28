#!/usr/bin/env bash
#PBS -q sequentiel
#PBS -l mem=10gb
#PBS -l walltime=01:00:00
#PBS -o $DATAWORK/pinctadapt/98_log_files/04a__filter_dedup_genoe_indexing.txt

#Global variables
DATADIRECTORY=$DATAWORK/pinctadapt
DATAINPUT=$SCRATCH/04_mapped/bam_dedup
SAMTOOLSENV=". /appli/bioinfo/samtools/latest/env.sh"
ASSEMBLY=/home1/datawork/agradel/pinctadapt/genome/Pmarg_genome_Taikanapa_1001-2000.fasta

#do the genome indexing
$SAMTOOLSENV
samtools faidx $ASSEMBLY -o $ASSEMBLY.fai
