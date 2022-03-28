#!/usr/bin/env bash
#PBS -q sequentiel
#PBS -l walltime=02:00:00
#PBS -l mem=115g
#PBS -N vcf_to_structure_format
#PBS -o /home1/datawork/agradel/population_genetic/98_log_files/structure/format_convertion.log

DIRECTORY=/home1/datawork/agradel/population_genetic
SCRIPT=$DIRECTORY/00_scripts/vcf_to_structure_format.R
CONDA=". /appli/anaconda/versions/4.8.3/etc/profile.d/conda.sh"
RENV=/home1/datahome/agradel/r_env
VCF=$DIRECTORY/02_data/Puce_ADN_289inds_10kSNPs.vcf

cd $DIRECTORY
grep "^#C" $VCF | cut -f 10- > $DIRECTORY/01_info_files/ordre_ind_vcf.txt

$CONDA
conda activate r_env
R --no-save --file=$SCRIPT
conda deactivate
