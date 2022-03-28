#!/usr/bin/env bash
#PBS -q mpi_1
#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=28:mem=115g
#PBS -o /home1/datawork/agradel/pinctadapt/98_log_files
#PBS -N snpeff

SNPEFF=/home1/datahome/agradel/program/snpEff
DBNAME=P_margaritifera_PL
VCF=/home1/scratch/agradel/06_freebayes/snpeff_input_outliers.vcf
WORKDIR=/home1/datawork/agradel/pinctadapt
OUTDIR=$WORKDIR/07_SNPEFF

mkdir -p $OUTDIR
mkdir -p $OUTDIR/$DBNAME
i
cd $SNPEFF

#Do the test for the dataset with no missing data:
/appli/java/jre1.8.0_121/bin/java -Xmx115G -jar $SNPEFF/snpEff.jar $DBNAME $VCF > $OUTDIR/$DBNAME/marquises_comparison.ann.vcf &&
mv snpEff_summary.html $OUTDIR/$DBNAME/marquises_comparison_report.html
mv snpEff_genes.txt $OUTDIR/$DBNAME/marquises_comparison_summary.txt
