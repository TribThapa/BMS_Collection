#Step 1: Load FSL.
module load fsl

#Step 2: Enter subjects IDs.
subID=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/1_CompareWhenToDenoise/3_DBScan_Output/ScriptsUsed/SubjectIDs.txt)

for subID in $subID; do
	
	#Step 3: Enter conditions.
	cond=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/1_CompareWhenToDenoise/3_DBScan_Output/ScriptsUsed/Conditions.txt)
		
		for cond in $cond; do
		
		#Step 4: Define paths to directories.
		DataDir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/1_CompareWhenToDenoise/3_DBScan_Output
		ImgDir=$DataDir/$subID/$subID'_'$cond'_dicer_lite0.2'
		MaskDir=$DataDir/ScriptsUsed/Schaefer2018_300Parcels_7Networks_order_FSLMNI152_dbscan.nii.gz
		TimeSeriesDir=$DataDir/$subID/'TimeSeries'
		RestrictiveMasksDir=$DataDir/$subID/'RestrictiveMasks'

		#Step 5: Use fslmeants, and the restrictive Schaefer2018 mask to extract the timeseries from the dbscan.nii.gz file.
		fslmeants -i $ImgDir/$subID'_task-'$cond'_space-MNI152NLin2009cAsym_desc-preproc_bold_dbscan.nii.gz' \
		-o $TimeSeriesDir/$subID'_task-'$cond'_ts.txt' \
		--label=$MaskDir \
		--transpose ;

	done 
done
