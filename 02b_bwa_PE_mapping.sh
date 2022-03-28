#!/bin/bash

#Global variables
DATADIRECTORY=$DATAWORK/pinctadapt
DATAINPUT=$SCRATCH/03_trimmed
DATAOUTPUT=$SCRATCH/04_mapped
SCRIPT=$DATADIRECTORY/00_scripts/scripts_02_bwa_scripts
HEADER=$DATADIRECTORY/00_scripts/headerP.txt
BWAENV=". /appli/bioinfo/bwa/latest/env.sh"
SAMTOOLSENV=". /appli/bioinfo/samtools/latest/env.sh"
ASSEMBLY=$DATADIRECTORY/genome/Pinctada_margaritifera_genome_v2.scaff_oneliner.fna
NCPU=28

#load the name of your samples (file created for trimmomatic, cf trimmomatic code)
cd $DATADIRECTORY/00_scripts
NAME='cat base.txt'

#create output directory
mkdir -p $DATAOUTPUT
mkdir -p $SCRIPT

#start the loop for generating individual bwa mapping files
for FILE in $($NAME)
do
cp $HEADER $SCRIPT/bwa_${FILE##*/}.sh ;
echo "#PBS -N 02_bwa_"$FILE"" >> $SCRIPT/bwa_${FILE##*/}.sh ;
echo "#PBS -o $DATADIRECTORY/98_log_files/02_bwa_"$FILE".log" >> $SCRIPT/bwa_${FILE##*/}.sh ;
echo "$BWAENV"  >> $SCRIPT/bwa_${FILE##*/}.sh ;
echo "bwa mem -t $NCPU -R '@RG\tID:$FILE\tSM:$FILE\tPL:illumina\tLB:lib1\tPU:unit1' -M $ASSEMBLY $DATAINPUT/"$FILE"_R1.paired.fastq.gz $DATAINPUT/"$FILE"_R2.paired.fastq.gz > $DATAOUTPUT/"$FILE".sam" >> $SCRIPT/bwa_${FILE##*/}.sh ;
echo "$SAMTOOLSENV" >> $SCRIPT/bwa_${FILE##*/}.sh ;
echo "samtools view -F 4 -F 256 -q 5 -f2 -b $DATAOUTPUT/"$FILE".sam > $DATAOUTPUT/"$FILE"_filtered.bam " >> $SCRIPT/bwa_${FILE##*/}.sh ;
echo "samtools sort -T $SCRATCH $DATAOUTPUT/"$FILE"_filtered.bam > $DATAOUTPUT/"$FILE"_filtered_sorted.bam " >> $SCRIPT/bwa_${FILE##*/}.sh ;
echo "rm $DATAOUTPUT/"$FILE".sam" >> $SCRIPT/bwa_${FILE##*/}.sh ;
echo "rm $DATAOUTPUT/"$FILE"_filtered.bam" >> $SCRIPT/bwa_${FILE##*/}.sh ;
qsub $SCRIPT/bwa_${FILE##*/}.sh;
done;
