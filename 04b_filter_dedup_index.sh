#/usr/bin/bash

#Global variables
DATADIRECTORY=$DATAWORK/pinctadapt
DATAINPUT=$SCRATCH/04_mapped/bam_dedup
DATAOUTPUT=$SCRATCH/05_indexed
SCRIPT=$DATADIRECTORY/00_scripts/scripts_06_indexed
HEADER=$DATADIRECTORY/00_scripts/headerP.txt
SAMTOOLSENV=". /appli/bioinfo/samtools/latest/env.sh"
GATKENV=". /appli/bioinfo/gatk/latest/env.sh"
ASSEMBLY=/home1/datawork/agradel/pinctadapt/01_info_files/Pmarg_genome_Taikanapa.fasta
#load the name of your samples (file created for trimmomatic, cf trimmomatic code)
cd $DATADIRECTORY/00_scripts
NAME='cat base.txt'

#create output directory
mkdir -p $DATAOUTPUT
mkdir -p $SCRIPT

#start the loop
for FILE in $($NAME)
do
cp $HEADER $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "#PBS -N INDEX_${FILE##*/}" >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "#PBS -o $DATADIRECTORY/98_log_files/05_index_${FILE##*/}.log " >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "#Rebuilding cigar strings for freebayes" >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "$GATKENV" >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "gatk CreateSequenceDictionary -R $ASSEMBLY " >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "gatk SplitNCigarReads --tmp-dir $SCRATCH -R $ASSEMBLY -I $DATAINPUT/"$FILE"_sambamba.bam -O $DATAOUTPUT/"$FILE"_sambamba_split.bam ;" >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "#Indexing the bam files for freebayes input" >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "$SAMTOOLSENV" >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "samtools sort -T $SCRATCH $DATAOUTPUT/"$FILE"_sambamba_split.bam > $DATAOUTPUT/"$FILE"_sambamba_split_sorted.bam " >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "samtools index $DATAOUTPUT/"$FILE"_sambamba_split_sorted.bam > $DATAOUTPUT/"$FILE"_sambamba_split_sorted.bam.bai " >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "#Clean the old files we don't need anymore " >> $SCRIPT/INDEX_${FILE##*/}.sh ;
echo "rm $DATAOUTPUT/"$FILE"_sambamba_split.bam " >> $SCRIPT/INDEX_${FILE##*/}.sh ;
qsub $SCRIPT/INDEX_${FILE##*/}.sh;
done;

