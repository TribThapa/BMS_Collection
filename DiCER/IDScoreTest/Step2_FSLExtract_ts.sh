#Step 1: Load FSL.
module load fsl

#Step 2: Enter subjects IDs.
subID=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/SubjectIDs.txt)

for subID in $subID; do
	
	#Step 3: Enter conditions.
	#Variant=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/Variant.txt)
		
		#for Variant in $Variant; do
		
		#Step 4: Define paths to directories.
		DataDir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest
		ImgDir=$DataDir/2_UCLA_dataset/$subID/func
		DBScanDir=$DataDir/2_UCLA_dataset/$subID/dbscan
		MaskDir=$DataDir/ScriptsUsed/Schaefer2018_300Parcels_7Networks_order_FSLMNI152_3mm.nii.gz
		TimeSeriesDir=$DataDir/2_UCLA_dataset/$subID/'TimeSeries'
		
		#rm -rf $TimeSeriesDir

		if [ ! -d $TimeSeriesDir ]; then mkdir $TimeSeriesDir; echo "making TimeSeries directory"; fi

		#Step 5: Use fslmeants, and the restrictive Schaefer2018 mask to extract the timeseries from the dbscan.nii.gz file.
		fslmeants -i $DBScanDir/$subID'_task-rest_bold_space-MNI152NLin2009cAsym_variant-AROMAnonaggr_preproc+2P_detrended_hpf.nii.gz' \
		-o $TimeSeriesDir/$subID'_task-rest_variant-AROMAnonaggr_preproc+2P_detrended_hpf_ts.txt' \
		--label=$MaskDir \
		--transpose ;

	#done 
done


