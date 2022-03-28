#!/usr/bin/env bash
#PBS -q sequentiel
#PBS -l walltime=24:00:00
#PBS -l mem=115g
#PBS -N vt_complex
#PBS -o $DATAWORK/pinctadapt/98_log_files/12_complex_all.log


DATAINPUT=/home1/scratch/agradel/06_freebayes

#Even if we only kept biallelic SNPs, we can still have what is called a "complex" event (meaning that it is not a single nucleotide but a sequence that is the variant)
#Allelic variants that overlap but do not cover the same range are called complex variants.
#Whenever two independently called variant sets are joined, there is a chance of getting complex variants.
#Complex variants comprise 1.4% of variants called by Freebayes.
#The popular GATK haplotype caller also encounters this phenomenon.

#It is better to remove them

cd $DATAINPUT

#We will manipulate the VCF. In column 4, there should be only one variant if the locus is not a complex
grep "^#" bcf_vcf_all.vcf &> header.txt
awk '$4=="A"' bcf_vcf_all.vcf &> A.txt
awk '$4=="C"' bcf_vcf_all.vcf &> C.txt
awk '$4=="G"' bcf_vcf_all.vcf &> G.txt
awk '$4=="T"' bcf_vcf_all.vcf &> T.txt

#concatenate and remove the temp files
cat A.txt C.txt G.txt T.txt &> temp_bcf_vcf_all.vcf

rm A.txt
rm C.txt
rm G.txt
rm T.txt

# create a new column with the number of the scaffold and note a character and remove the tmp
awk -F"_" '$1=$1' OFS="\t" temp_bcf_vcf_all.vcf &> temp_split_bcf_vcf_all.vcf
sort -k3 -n temp_split_bcf_vcf_all.vcf &> sorted_temp_split_bcf_vcf_all_1.vcf
sort -k2 -n sorted_temp_split_bcf_vcf_all_1.vcf &> sorted_temp_split_bcf_vcf_all_2.vcf

rm temp_bcf_vcf_all.vcf
rm temp_split_bcf_vcf_all.vcf
rm sorted_temp_split_bcf_vcf_all_1.vcf

#now recreate the original column and remove the temp files
awk 'BEGIN{FS=OFS="\t"}{concat=$1"_"$2; $1=concat}{print $0}' sorted_temp_split_bcf_vcf_all_2.vcf &> sorted_temp_bcf_vcf_all.vcf
cut -f2 --complement sorted_temp_bcf_vcf_all.vcf &> sorted_cleaned.vcf

rm sorted_temp_split_bcf_vcf_all_2.vcf
rm sorted_temp_bcf_vcf_all.vcf

#and finaly create add the header to have a nice file for the analyses
cat header.txt sorted_cleaned.vcf &> clean_vcf_all.vcf

rm sorted_cleaned.vcf
rm header.txt






