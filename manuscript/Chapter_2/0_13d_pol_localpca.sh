#!/usr/bin/env bash

#PBS -q sequentiel
#PBS -l mem=240gb
#PBS -l walltime=24:00:00
#PBS -o /home1/datawork/agradel/demographic_chapter/98_log_files/pol_localpca.log

SCRIPT=/home1/datawork/agradel/demographic_chapter/00_scripts/pol_localpca.R
CONDA=". /appli/anaconda/versions/4.8.3/etc/profile.d/conda.sh"
RENV=/home1/datahome/agradel/dartr_env

cd $DIRECTORY

$CONDA
conda activate dartr_env
R --no-save --file=$SCRIPT
conda deactivate