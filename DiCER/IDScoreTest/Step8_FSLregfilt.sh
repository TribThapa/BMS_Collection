##!/bin/bash

#Step1: Load necessary modules.
module purge
module load fsl/5.0.9

#Step 1: Define path to dicer directory.
Data_dir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/2_UCLA_dataset

#Step 2: Define path to text files with subject IDs.
subID=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/SubjectIDs_Healthys.txt)

for subID in $subID; 
	
do

	#Step 4: Change directory to subject's folder.
	Input_dir=$Data_dir/$subID/dbscan
	Output_dir=$Data_dir/$subID/dbscan

	#if [ ! -d $Output_dir ]; then mkdir $Output_dir; echo "$ID - making directory"; fi

	#Step 5: Regress data.
	echo -e "\nRegressing out 1st DiCER component for $subID \n"

	fsl_regfilt -i $Input_dir/$subID'_task-rest_bold_space-MNI152NLin2009cAsym_variant-AROMAnonaggr_preproc+2P_detrended_hpf_dbscan.nii.gz' \
    -f '1' \
	-d $Input_dir/$subID'_dbscan_liberal_regressors.tsv' \
	-o $Output_dir/$subID'_task-rest_bold_space-MNI152NLin2009cAsym_variant-AROMAnonaggr_preproc+2P_detrended_hpf_1stRegRemoved_dbscan.nii.gz'

done	

#-f $(cut -f1 $Input_dir/$subID'_dbscan_liberal_regressors.tsv') \	
#-f $(cat $Input_dir/$subID'_dbscan_liberal_regressors.tsv') \
