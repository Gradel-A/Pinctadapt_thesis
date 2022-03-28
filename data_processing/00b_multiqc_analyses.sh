#!/usr/bin/env bash
#PBS -N multiQC
#PBS -q sequentiel
#PBS -l walltime=05:00:00
#PBS -l mem=40gb

# global variables
DATADIRECTORY=$DATAWORK/pinctadapt
MULTIQCENV=". /appli/bioinfo/multiqc/latest/env.sh"

cd $DATADIRECTORY
#doing the analyses
$MULTIQCENV

multiqc ./02_data/00_fastqc_raw -o $DATADIRECTORY/02_data