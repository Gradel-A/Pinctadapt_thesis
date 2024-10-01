#!/usr/bin/bash

##### script from Adrien Tran Lu Y
######### change header depending of type of HPC you will use (SGE or slurm protocol)
######### im using pyenv (python environnement) environnement where dadi is installed but you can call the dadi version from module load or something else depending on your HPC
######### my pyenv is called "dadi_sim"
######### dadi v2.1 from https://gitlab.mbb.univ-montp2.fr/khalid/dadi/-/tree/master  see there to install dadi and pyenv to install it within a specific python3 environnement


FS='cat /home1/datawork/agradel/demographic_chapter/02_data/fs_files.txt' ###### Spectrum file
DATA=/home1/datawork/agradel/demographic_chapter/02_data
DADI=/home1/datahome/agradel/script_dadi
OUTPATH=$SCRATCH/dadi_simulation
MODEL='cat /home1/datawork/agradel/demographic_chapter/00_scripts/model_list.txt'
SCRIPT=/home1/datawork/agradel/demographic_chapter/00_scripts/simulations

cd $DATA
#ls -d /home1/datawork/agradel/demographic_chapter/02_data/*.sfs> /home1/datawork/agradel/demographic_chapter/02_data/fs_files.txt

mkdir -p $OUTPATH
mkdir -p $SCRIPT
#### set name of each model do you want to launch 
#### it will create a single bash file for each run (1 to 11) for each model and running it independently 
#### it check before if the iteration is already done within the folder (current folder /IM/IM_1.txt for exemple) and if it's already done it wont start the simulation. 
for fs in $($FS);
do
for model in $($MODEL);  
do

for i in `seq 12 20`;
do
echo ${i};

if [ -d "$model" ]; 
then
	if [ -f "${model}/${model}_${i}_.txt" ]; 
	then
		echo "already done"
	else
		printf "
#!/bin/bash
#PBS -N ${fs}_${model}_${i}_
#PBS -q sequentiel
#PBS -l walltime=48:00:00
#PBS -l mem=2gb
#PBS -o /home1/datawork/agradel/demographic_chapter/98_log_files/simulation_${fs##*/}_${model}_${i}_.log
. /appli/anaconda/latest/etc/profile.d/conda.sh
mkdir -p $OUTPATH/${fs##*/}
conda activate dadi
cd $DADI
python3 call_all_model_no_NA_change.py $model $fs $i $OUTPATH/${fs##*/} " > $SCRIPT/${fs##*/}_${model}_${i}_.sh; 
		qsub  $SCRIPT/${fs##*/}_${model}_${i}_.sh 
	fi
else
printf "
#!/bin/bash
#PBS -q sequentiel
#PBS -l walltime=48:00:00
#PBS -l mem=2gb
#PBS -o /home1/datawork/agradel/demographic_chapter/98_log_files/simulation_${fs##*/}_${model}_${i}_.log
. /appli/anaconda/latest/etc/profile.d/conda.sh
mkdir -p $OUTPATH/${fs##*/}
conda activate dadi
cd $DADI
python3 call_all_model_no_NA_change.py $model $fs $i $OUTPATH/${fs##*/} " >  $SCRIPT/${fs##*/}_${model}_${i}_.sh; 
qsub  $SCRIPT/${fs##*/}_${model}_${i}_.sh 
fi
done
done
done