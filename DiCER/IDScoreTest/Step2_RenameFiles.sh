#!/bin/bash

#This script will reorder tissue_T1w to CSF=1, GM=2, WM=3 (note the alphabetical order to help remember). Currently, with the newer version of fMRIPrep, the tiusses are in this order: GM=1, WM=2, CSF=3.

#Step1: Load FSL.
module purge
module load fsl/5.0.9

#Step 2: Enter subID here or into a text file to loop over multiple subjects.
subID=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/SubjectIDs.txt)

for subID in $subID; do
	
	#Step 3: Enter conditions.
	cond=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/Conditions.txt)

		for cond in $cond; do
		
		#Step 4: Define paths to anat, func, and dicer directories.
		fmriprep_dir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/2_UCLA_Schaefer
		TimeSeries_dir=$fmriprep_dir/$subID/'TimeSeries'
		#TimeSeries_dir=$fmriprep_dir/$subID/

		#Step 7: Rename the desg file (is the output from the new fMRIPrep version) to dseg_old.
		#cp $TimeSeries_dir/$subID'_task-rest_variant-AROMAnonaggr_preproc+2P+GMR_detrended_hpf_Schaefer_ts.txt' $TimeSeries_dir/$subID'_GMR_Schaefer_ts.txt'
		#cp $TimeSeries_dir/$subID'_task-rest_variant-AROMAnonaggr_preproc+2P_detrended_hpf_Schaefer_ts.txt' $TimeSeries_dir/$subID'_2P_detrend_Schaefer_ts.txt'
		#cp $TimeSeries_dir/$subID'_task-rest_variant-AROMAnonaggr_preproc+2P+GSR_Schaefer_ts.txt' $TimeSeries_dir/$subID'_GSR_Schaefer_ts.txt'
		#cp $TimeSeries_dir/$subID'_task-rest_variant-AROMAnonaggr_preproc+2P_Schaefer_ts.txt' $TimeSeries_dir/$subID'_AROMA2P_Schaefer_ts.txt'
		#cp $TimeSeries_dir/$subID'_task-rest_variant-24P+8P_preproc_Schaefer_ts.txt' $TimeSeries_dir/$subID'_24P+8P_Schaefer_ts.txt'
		#cp $TimeSeries_dir/$subID'_task-rest_variant-AROMAnonaggr_preproc+2P_detrended_hpf_dbscan_Schaefer_ts.txt' $TimeSeries_dir/$subID'_DiCERfull_Schaefer_ts.txt'

		mv $TimeSeries_dir/$subID'AROMA+2P_Aparc_ts.txt' $TimeSeries_dir/$subID'_Arm2P_Aparc_ts.txt'
		mv $TimeSeries_dir/$subID'AROMA+2P+GMR_Aparc_ts.txt' $TimeSeries_dir/$subID'_GMR_Aparc_ts.txt'
		mv $TimeSeries_dir/$subID'AROMA+2P+DiCER_Aparc_ts.txt' $TimeSeries_dir/$subID'_DicFull_Aparc_ts.txt'

		#rm $TimeSeries_dir/*.json
		#rm $TimeSeries_dir/*nii.gz 
		#rm $TimeSeries_dir/*.mat 
		
		done
done
