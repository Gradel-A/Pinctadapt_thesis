#!/usr/bin/env bash
#PBS -q mpi_1
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=28:mem=115g
#PBS -o /home1/datawork/agradel/pinctadapt/98_log_files
#PBS -N a08snpeff

SNPEFF=/home1/datahome/agradel/program/snpEff
WORKDIR=/home1/datawork/agradel/pinctadapt
GFF=$WORKDIR/01_info_files/PL_annotation_PasaEx_54408.gff3
FASTA=$WORKDIR/01_info_files/Pmarg_genome_Taikanapa.fasta
DBNAME=P_margaritifera_PL

cd $SNPEFF

#create necessary directories for analysis in the SNPeff program folder: a directory "data" in wich two other directories is created:
mkdir -p data
mkdir -p data/$DBNAME
mkdir -p data/genomes


# Copy files where they need to be. GFF in the $DBNAME directory, fasta in the "genomes" directory
cp $GFF ./data/$DBNAME/genes.gff
cp $FASTA ./data/genomes/$DBNAME.fa


#Modify the config file in order to add the new genome
echo "# Genome of Pinctada margaritifera, Pmarg_genome_Taikanapa.fasta" >> snpEff.config
echo "$DBNAME.genome : $DBNAME" >> snpEff.config

/appli/java/jre1.8.0_121/bin/java -Xmx115G -jar $SNPEFF/snpEff.jar build -gff3 -v $DBNAME
