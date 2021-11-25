#!/bin/bash

module load anaconda/5.0.1-Python2.7-gcc5

DataDir=/home/ttha0011/kg98
DiCERDir=/fs03/kg98/kristina/Projects/GenofCog/derivatives/dicer

subID=$(</projects/kg98/Thapa/GenOfCog/Scripts/SubIDs.txt)

for subID in $subID; do

	PreGSR_file=$DataDir/kristina/GenofCog/datadir/derivatives/$subID/prepro.feat/filtered_func_data_clean_mni.nii.gz
	GSR_file=$DataDir/kristina/GenofCog/datadir/derivatives/$subID/gsr/filtered_func_data_clean_gsr4_mni.nii.gz
	OutputDir=$DataDir/Thapa/GenOfCog/2_Tests/GenOfCog/3_CarpetPlots/GSR/
	ClusterOrder=$DiCERDir/$subID/$subID'_filtered_func_data_clean_mni_clusterorder.nii.gz'
	TimeSeries=$DiCERDir/$subID/$subID'_dtissue_func_dsFactor_4.nii.gz'


	python /home/ttha0011/kg98/Thapa/GenOfCog/Scripts/DiCER/carpetReport/tapestry.py -f $GSR_file \
	-fl '_GSR_CLUST' \
	-o $ClusterOrder \
	-l 'CLUST' \
	-s $subID \
	-d $OutputDir \
	-ts $TimeSeries
	
done



