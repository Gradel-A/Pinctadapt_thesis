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

#first tree_polynesia file
#echo "JAPJuv" > $OUTPUT/family_removal.txt

#$PLINK --vcf $INPUT/chip_pinctadapt_data_cleaned_outgroup.vcf --allow-extra-chr --remove-fam $OUTPUT/family_removal.txt --make-bed --out $OUTPUT/tree_polynesia
#$PLINK --vcf $INPUT/chip_pinctadapt_data_cleaned_outgroup.vcf --allow-extra-chr --make-bed --out $OUTPUT/tree_polynesia

#just we have to manually rename the family in .fam in order to produce the three populations marquesas, indonesia and tuamotu
sed 's/AHE /Tuamotus AHE-/g' $OUTPUT/tree_polynesia.fam > tmp.fam
sed 's/ANA /Tuamotus ANA-/g' tmp.fam > tmp2.fam
sed 's/ARA /Tuamotus ARA-/g' tmp2.fam > tmp.fam
sed 's/AUQ /Marquesas AUQ-/g' tmp.fam > tmp2.fam
sed 's/GMBW /Gambier GMBW-/g' tmp2.fam > tmp.fam
sed 's/KAT /Tuamotus KAT-/g' tmp.fam > tmp2.fam
sed 's/KAU /Tuamotus KAU-/g' tmp2.fam > tmp.fam
sed 's/MAN /Tuamotus MAN-/g' tmp.fam > tmp2.fam
sed 's/MarSud /Gambier MarSud-/g' tmp2.fam > tmp.fam
sed 's/MG /Marquesas MG-/g' tmp.fam > tmp2.fam
sed 's/MOP /Society MOP-/g' tmp2.fam > tmp.fam
sed 's/MOR /Gambier MOR-/g' tmp.fam > tmp2.fam
sed 's/MOT /Tuamotus MOT-/g' tmp2.fam > tmp.fam
sed 's/MP /Marquesas MP-/g' tmp.fam > tmp2.fam
sed 's/RAR /Tuamotus RAR-/g' tmp2.fam > tmp.fam
sed 's/SCI /Society SCI-/g' tmp.fam > tmp2.fam
sed 's/TAH /Tuamotus TAH-/g' tmp2.fam > tmp.fam
sed 's/TAK /Tuamotus TAK-/g' tmp.fam > tmp2.fam
sed 's/TEA /Tuamotus TEA-/g' tmp2.fam > tmp.fam
sed 's/TKP /Tuamotus TKP-/g' tmp.fam > tmp2.fam
sed 's/UAH /Marquesas UAH-/g' tmp2.fam > tmp.fam
sed 's/WC1 /Gambier WC1-/g' tmp.fam > tmp2.fam
sed 's/WC2 /Gambier WC2-/g' tmp2.fam > tmp.fam
sed 's/WC3 /Gambier WC3-/g' tmp.fam > tmp2.fam
sed 's/WildJuvIndo /Indonesia WildJuvIndo-/g' tmp2.fam > $OUTPUT/tree_polynesia.fam

$PLINK --bfile $OUTPUT/tree_polynesia --allow-extra-chr --freq --missing --family --out $OUTPUT/tree_polynesia_plink
gzip -f $OUTPUT/tree_polynesia_plink.frq.strat
python2 $HOME/script_référence/plink2treemix.py $OUTPUT/tree_polynesia_plink.frq.strat.gz $OUTPUT/tree_polynesia.frq.gz


#and now the file for global treemix
$PLINK --vcf $INPUT/chip_pinctadapt_data_cleaned_outgroup.vcf --allow-extra-chr --freq --missing --family --out $OUTPUT/treemix_plink
gzip -f $OUTPUT/treemix_plink.frq.strat
python2 $HOME/script_référence/plink2treemix.py $OUTPUT/treemix_plink.frq.strat.gz $OUTPUT/treemix_all.frq.gz

#now we can do the analyses base on the files previously generated
$TREEMIX

##F3 stats first

#threepop -i $OUTPUT/tree_polynesia.frq.gz -k 500
#threepop -i $OUTPUT/tree_polynesia.frq.gz 

##and now treemix graphs
mkdir -p $TREERESULTS

mkdir -p $TREERESULTS/global
treemix -i $OUTPUT/treemix_all.frq.gz -o $TREERESULTS/global/treemix_results_global
treemix -i $OUTPUT/treemix_all.frq.gz -m 5 -o $TREERESULTS/global/treemix_results_global_migration


mkdir -p $TREERESULTS/polynesia_japan/migration_0
treemix -i $OUTPUT/tree_polynesia.frq.gz -o $TREERESULTS/polynesia_japan/migration_0/treemix_results_replicate1
treemix -i $OUTPUT/tree_polynesia.frq.gz -o $TREERESULTS/polynesia_japan/migration_0/treemix_results_replicate2
treemix -i $OUTPUT/tree_polynesia.frq.gz -o $TREERESULTS/polynesia_japan/migration_0/treemix_results_replicate3
treemix -i $OUTPUT/tree_polynesia.frq.gz -o $TREERESULTS/polynesia_japan/migration_0/treemix_results_replicate4
treemix -i $OUTPUT/tree_polynesia.frq.gz -o $TREERESULTS/polynesia_japan/migration_0/treemix_results_replicate5

mkdir -p $TREERESULTS/polynesia_japan/migration_1
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 1 -o $TREERESULTS/polynesia_japan/migration_1/treemix_results_replicate1
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 1 -o $TREERESULTS/polynesia_japan/migration_1/treemix_results_replicate2
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 1 -o $TREERESULTS/polynesia_japan/migration_1/treemix_results_replicate3
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 1 -o $TREERESULTS/polynesia_japan/migration_1/treemix_results_replicate4
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 1 -o $TREERESULTS/polynesia_japan/migration_1/treemix_results_replicate5

mkdir -p $TREERESULTS/polynesia_japan/migration_2
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 2 -o $TREERESULTS/polynesia_japan/migration_2/treemix_results_replicate1
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 2 -o $TREERESULTS/polynesia_japan/migration_2/treemix_results_replicate2
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 2 -o $TREERESULTS/polynesia_japan/migration_2/treemix_results_replicate3
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 2 -o $TREERESULTS/polynesia_japan/migration_2/treemix_results_replicate4
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 2 -o $TREERESULTS/polynesia_japan/migration_2/treemix_results_replicate5

mkdir -p $TREERESULTS/polynesia_japan/migration_3
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 3 -o $TREERESULTS/polynesia_japan/migration_3/treemix_results_replicate1
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 3 -o $TREERESULTS/polynesia_japan/migration_3/treemix_results_replicate2
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 3 -o $TREERESULTS/polynesia_japan/migration_3/treemix_results_replicate3
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 3 -o $TREERESULTS/polynesia_japan/migration_3/treemix_results_replicate4
treemix -i $OUTPUT/tree_polynesia.frq.gz -m 3 -o $TREERESULTS/polynesia_japan/migration_3/treemix_results_replicate5

#mkdir -p $TREERESULTS/root_indo
#treemix -i $OUTPUT/treemix_all.frq.gz -root WildJuvIndo -o $TREERESULTS/root_indo/treemix_results_indonesia

