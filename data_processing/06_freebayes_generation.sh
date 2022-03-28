#!/usr/bin/bash

#declare variables used in the script
DATADIRECTORY=$DATAWORK/pinctadapt
DATAOUTPUT=$SCRATCH/06_freebayes/partial
SCRIPT=$DATADIRECTORY/00_scripts/partial_freebayes
HEADER=$DATADIRECTORY/00_scripts/headerP.txt
FREEBAYESENV=". /appli/bioinfo/freebayes/latest/env.sh"
SAMTOOLSENV=". /appli/bioinfo/samtools/latest/env.sh"


#create the output files
mkdir -p $SCRIPT
mkdir -p $DATAOUTPUT

#go to the folder containing the data in your project folder
cd $DATADIRECTORY/genome

#list the file of the sample genome
ls -d /home1/scratch/agradel/04_mapped/bam_dedup/*.bam > $SCRATCH/bam_files_freebayes.txt
BAM=$SCRATCH/bam_files_freebayes.txt
#start the loop creating individual scripts for each fastq files located in the data folder
for FILE in $(ls Pinctada_margaritifera_genome_v2.scaff_oneliner_1-250_*) #list all the files with the fna extension and store it in the variable FILE
do
        cp $HEADER $SCRIPT/indexing_${FILE##*/}.sh ; # copy the header file in a new script file called freebayes_{genome_part}.sh
        cp $HEADER $SCRIPT/freebayes_${FILE##*/}.sh ;
        echo "#PBS -N indexing_${FILE##*/}" >> $SCRIPT/indexing_${FILE##*/}.sh ;
        echo "#PBS -o $DATADIRECTORY/98_log_files/06a_indexing_pe_${FILE##*/}.log" >> $SCRIPT/indexing_${FILE##*/}.sh ;
        echo "#PBS -N freebayes_${FILE##*/}" >> $SCRIPT/freebayes_${FILE##*/}.sh ;
        echo "#PBS -o $DATADIRECTORY/98_log_files/06b_freebayes_pe_${FILE##*/}.log" >> $SCRIPT/freebayes_${FILE##*/}.sh ;
        echo "cd $SCRATCH" >> $SCRIPT/indexing_${FILE##*/}.sh ; # append the echoed line in the script file (we go to the data folder of our project)
        echo "cd $SCRATCH" >> $SCRIPT/freebayes_${FILE##*/}.sh ; # append the echoed line in the script file (we go to the data folder of our project)
        echo "export TMPDIR=$SCRATCH" >> $SCRIPT/freebayes_${FILE##*/}.sh ;
        echo "export TEMPDIR=$SCRATCH" >> $SCRIPT/freebayes_${FILE##*/}.sh ;
        echo "export TMP=$SCRATCH" >> $SCRIPT/freebayes_${FILE##*/}.sh ;
        echo "$SAMTOOLSENV" >> $SCRIPT/indexing_${FILE##*/}.sh ; # preparing the indexing
        echo "samtools faidx /home1/datawork/agradel/pinctadapt/genome/$FILE -o /home1/datawork/agradel/pinctadapt/genome/$FILE.fai" >> $SCRIPT/indexing_${FILE##*/}.sh ;
        echo "$FREEBAYESENV"  >> $SCRIPT/freebayes_${FILE##*/}.sh ; # append the echoed line in the script file (here we load the freebayes environment)
        echo "cd $SCRATCH" >> $SCRIPT/freebayes_${FILE##*/}.sh ;
        echo "freebayes-parallel <(fasta_generate_regions.py /home1/datawork/agradel/pinctadapt/genome/${FILE}.fai 100000) 28 -f /home1/datawork/agradel/pinctadapt/genome/${FILE} --use-best-n-alleles 2 -L $BAM > /home1/scratch/agradel/06_freebayes/partial/vcf_part_${FILE##*/}.vcf 2> $SCRATCH/freebayes_error_part_${FILE##*/}.err " >> $SCRIPT/freebayes_${FILE##*/}.sh ;
        qsub $SCRIPT/indexing_${FILE##*/}.sh ; # append the echoed line in the script file (here we ask to submit our script to the PBS claculation nodes for execution)
        qsub $SCRIPT/freebayes_${FILE##*/}.sh ; # append the echoed line in the script file (here we ask to submit our script to the PBS claculation nodes for execution)
done ; # we finish the loop

