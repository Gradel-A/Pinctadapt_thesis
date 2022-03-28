#!/usr/bin/bash

#declare variables used in the script
DATADIRECTORY=$DATAWORK/pinctadapt
DATAOUTPUT=$SCRATCH/03_trimmed
SCRIPT=$DATADIRECTORY/00_scripts/scripts_01_fastp_pe
HEADER=$DATADIRECTORY/00_scripts/headerP.txt
FASTPENV=". /appli/bioinfo/fastp/0.20.1/env.sh"
ADAPTERFILE=$DATADIRECTORY/00_scripts/adapters_pinctadapt.fasta
NCPU=28



#store the name of samples (file made before the analysis)  information into a new variable called NAME
NAME='cat /home1/datawork/agradel/pinctadapt/00_scripts/base.txt'

#redirect to the data directory
cd $DATADIRECTORY

#make the output directories
mkdir -p $SCRIPT
mkdir -p $DATAOUTPUT

#start the loop that will create the files
for file in $($NAME)
do
cp $HEADER $SCRIPT/fastp_pe_${file##*/}.sh ;
echo "#PBS -o $DATADIRECTORY/98_log_files/01_fastp_pe_${file##*/}.log" >> $SCRIPT/fastp_pe_${file##*/}.sh ;
echo "#PBS -N fastp_pe_${file##*/}" >> $SCRIPT/fastp_pe_${file##*/}.sh ;
echo "cd $DATADIRECTORY" >> $SCRIPT/fastp_pe_${file##*/}.sh ;
echo "$FASTPENV"  >> $SCRIPT/fastp_pe_${file##*/}.sh ;
echo "fastp -i $DATADIRECTORY/02_data/*"$file"_R1.fastq.gz \
-I $DATADIRECTORY/02_data/*"$file"_R2.fastq.gz \
-o $DATAOUTPUT/"$file"_R1.paired.fastq.gz \
-O $DATAOUTPUT/"$file"_R2.paired.fastq.gz \
--adapter_fasta "$ADAPTERFILE" \
--trim_poly_g \
--average_qual 28 \
--length_required 50 \
--thread "$NCPU" " >> $SCRIPT/fastp_pe_${file##*/}.sh ;
qsub $SCRIPT/fastp_pe_${file##*/}.sh ;
 
done ;

