#!/usr/bin/env bash

#PBS -q mpi_1
#PBS -l mem=60gb
#PBS -l walltime=03:00:00
#PBS -o /home1/datawork/agradel/population_genetic/98_log_files/treemix_analyses.log

TREEMIX=". /appli/bioinfo/treemix/1.13/env.sh"
PLINK="/appli/bioinfo/plink/1.9/plink"
DIRECTORY=$DATAWORK/population_genetic
INPUT=$DIRECTORY/02_data/puce_final
OUTPUT=$SCRATCH/population_genetic/treemix
TREERESULTS=$OUTPUT/treemix_results

mkdir -p $OUTPUT

#first we will create the files required for the analyses in the good format

#first threepop file
echo "MG" > $OUTPUT/family_threepop.txt
echo "MP" >> $OUTPUT/family_threepop.txt
echo "UAH"  >> $OUTPUT/family_threepop.txt
echo "WildJuvIndo" >> $OUTPUT/family_threepop.txt
echo "AHE" >> $OUTPUT/family_threepop.txt
echo "TKP" >> $OUTPUT/family_threepop.txt

$PLINK --vcf $INPUT/chip_pinctadapt_data_cleaned_outgroup.vcf --allow-extra-chr --keep-fam $OUTPUT/family_threepop.txt --make-bed --out $OUTPUT/threepop_file
#just we have to manually rename the family in .fam in order to produce the three populations marquesas, indonesia and tuamotu
sed 's/MG /Marquesas MG-/g' $OUTPUT/threepop_file.fam | sed 's/UAH /Marquesas UAH-/g' | sed 's/MP /Marquesas MP-/g' > $OUTPUT/tmp.fam
sed 's/WildJuvIndo/Indonesia/g' $OUTPUT/tmp.fam > $OUTPUT/tmp2.fam
sed 's/AHE /Polynesia AHE-/g' $OUTPUT/tmp2.fam | sed 's/TKP /Polynesia TKP-/g' > $OUTPUT/threepop_file.fam


$PLINK --bfile $OUTPUT/threepop_file --allow-extra-chr --freq --missing --family --out $OUTPUT/threepop_plink
gzip -f $OUTPUT/threepop_plink.frq.strat
python2 $HOME/script_référence/plink2treemix.py $OUTPUT/threepop_plink.frq.strat.gz $OUTPUT/threepop.frq.gz


#and now the file for global treemix
$PLINK --vcf $INPUT/chip_pinctadapt_data_cleaned_outgroup.vcf --allow-extra-chr --freq --missing --family --out $OUTPUT/treemix_plink
gzip -f $OUTPUT/treemix_plink.frq.strat
python2 $HOME/script_référence/plink2treemix.py $OUTPUT/treemix_plink.frq.strat.gz $OUTPUT/treemix_all.frq.gz

#now we can do the analyses base on the files previously generated
$TREEMIX

##F3 stats first

threepop -i $OUTPUT/threepop.frq.gz -k 500
threepop -i $OUTPUT/threepop.frq.gz 

##and now treemix graphs
mkdir -p $TREERESULTS

mkdir -p $TREERESULTS/global
treemix -i $OUTPUT/treemix_all.frq.gz -o $TREERESULTS/global/treemix_results_global
treemix -i $OUTPUT/treemix_all.frq.gz -m 5 -o $TREERESULTS/global/treemix_results_global_migration


mkdir -p $TREERESULTS/migration_0
treemix -i $OUTPUT/threepop.frq.gz -o $TREERESULTS/migration_0/treemix_results_replicate1
treemix -i $OUTPUT/threepop.frq.gz -o $TREERESULTS/migration_0/treemix_results_replicate2
treemix -i $OUTPUT/threepop.frq.gz -o $TREERESULTS/migration_0/treemix_results_replicate3
treemix -i $OUTPUT/threepop.frq.gz -o $TREERESULTS/migration_0/treemix_results_replicate4
treemix -i $OUTPUT/threepop.frq.gz -o $TREERESULTS/migration_0/treemix_results_replicate5

mkdir -p $TREERESULTS/migration_1
treemix -i $OUTPUT/threepop.frq.gz -m 1 -o $TREERESULTS/migration_1/treemix_results_replicate1
treemix -i $OUTPUT/threepop.frq.gz -m 1 -o $TREERESULTS/migration_1/treemix_results_replicate2
treemix -i $OUTPUT/threepop.frq.gz -m 1 -o $TREERESULTS/migration_1/treemix_results_replicate3
treemix -i $OUTPUT/threepop.frq.gz -m 1 -o $TREERESULTS/migration_1/treemix_results_replicate4
treemix -i $OUTPUT/threepop.frq.gz -m 1 -o $TREERESULTS/migration_1/treemix_results_replicate5

mkdir -p $TREERESULTS/migration_2
treemix -i $OUTPUT/threepop.frq.gz -m 2 -o $TREERESULTS/migration_2/treemix_results_replicate1
treemix -i $OUTPUT/threepop.frq.gz -m 2 -o $TREERESULTS/migration_2/treemix_results_replicate2
treemix -i $OUTPUT/threepop.frq.gz -m 2 -o $TREERESULTS/migration_2/treemix_results_replicate3
treemix -i $OUTPUT/threepop.frq.gz -m 2 -o $TREERESULTS/migration_2/treemix_results_replicate4
treemix -i $OUTPUT/threepop.frq.gz -m 2 -o $TREERESULTS/migration_2/treemix_results_replicate5

mkdir -p $TREERESULTS/migration_3
treemix -i $OUTPUT/threepop.frq.gz -m 3 -o $TREERESULTS/migration_3/treemix_results_replicate1
treemix -i $OUTPUT/threepop.frq.gz -m 3 -o $TREERESULTS/migration_3/treemix_results_replicate2
treemix -i $OUTPUT/threepop.frq.gz -m 3 -o $TREERESULTS/migration_3/treemix_results_replicate3
treemix -i $OUTPUT/threepop.frq.gz -m 3 -o $TREERESULTS/migration_3/treemix_results_replicate4
treemix -i $OUTPUT/threepop.frq.gz -m 3 -o $TREERESULTS/migration_3/treemix_results_replicate5

mkdir -p $TREERESULTS/root_indo
treemix -i $OUTPUT/treemix_all.frq.gz -root WildJuvIndo -o $TREERESULTS/root_indo/treemix_results_indonesia

