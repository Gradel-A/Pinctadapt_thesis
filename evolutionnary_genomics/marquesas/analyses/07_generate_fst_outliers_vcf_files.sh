#!/bin/bash
#PBS -q sequentiel
#PBS -l walltime=20:00:00
#PBS -l mem=60g
#PBS -N Sig_filtering_VCF

WORKDIR=$DATAWORK/pinctadapt
VCF=marquises_withoutNA_verif.recode.vcf
INDIR=/home1/scratch/agradel/06_freebayes
OUTLIERS=/home1/datawork/agradel/pinctadapt/results/id_fst_sup05.txt
#---------------------------------------------
#Step 0: create the outliers id file to clean the vcf

sed -i 's/"//g' $OUTLIERS
awk '{OFS = "_" ; print $1,$2}' $OUTLIERS > $INDIR/locus_id.txt

#---------------------------------------------
#Step 1: creation of all the necessary inputs

# We need to separate the header from the rest of the vcf file in order for the code to work:

cd $INDIR

grep -v "^#" $VCF > no_header_vcf.vcf
grep "^#" $VCF > header.txt

#---------------------------------------------------------------------------
#Step 2: creating a "single_ID" filed in the 1st column of no_header_vcf.vcf

awk '{OFS = "_" ; print $1,$2}' no_header_vcf.vcf | paste - no_header_vcf.vcf > single_ID_no_header_vcf.vcf


#-----------------------------------------------
#Step 3: keep only the SNPs that are significant:

#grep -f $SIG single_ID_no_header_vcf.vcf > single_ID_no_header_vcf_significant.vcf
awk 'FNR==NR {a[$1]=$0; next}; $1 in a {print a[$1]}' single_ID_no_header_vcf.vcf locus_id.txt > single_ID_no_header_vcf_significant.vcf

#----------------------------------------
#Step 4: reformat it so that it is a VCF:

#Remove first column (and the tabulation separating $1 and $2) and reattach the header
awk '{ $1=""; print $0 }' single_ID_no_header_vcf_significant.vcf | sed 's/^[ \t]+//g' - | sed 's#^[ ]##g' | sed 's# #\t#g' - | cat header.txt - > /home1/scratch/agradel/06_freebayes/snpeff_input_outliers.vcf

#-----------------------------
#Step 5: clean your workspace:

rm single_ID_no_header_vcf_significant.vcf
rm single_ID_no_header_vcf_significant.vcf
rm single_ID_no_header_vcf.vcf
rm no_header_vcf.vcf
rm locus_id.txt
rm header.txt