#!/usr/bin/env bash
#PBS -q sequentiel
#PBS -l walltime=03:00:00
#PBS -l mem=115g
#PBS -N pcadapt_screeplot
#PBS -o /home1/datawork/agradel/pinctadapt/98_log_files/a02_pcadapt_OO1.log

DIRECTORY=/home1/datawork/agradel/pinctadapt
SCRIPT=$DIRECTORY/00_scripts/analyses/02_pcadapt.R
CONDA=". /appli/anaconda/versions/4.8.3/etc/profile.d/conda.sh"
RENV=/home1/datahome/agradel/r_env


cd $DIRECTORY
$CONDA
conda activate r_env
R --no-save --file=$SCRIPT
conda deactivate
