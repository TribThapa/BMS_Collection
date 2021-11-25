#!/bin/bash
#SBATCH --job-name=ExtractTimeseries_GordonAtlas
#SBATCH --account=kg98
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1-00:00:00
#SBATCH --mail-user=tribikram.thapa@monash.edu
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=12000
#SBATCH --qos=normal
#SBATCH -A kg98

#Step 1: Load FSL.
module purge
module load fsl

#Step 2: Enter subjects IDs.
subID=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/SubjectIDs_Healthys.txt)

for subID in $subID; do
	
	#Step 3: Enter conditions.
	cond=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/Conditions.txt)

		for cond in $cond; do
		
		#Step 4: Define paths to directories.
		fmriprep_dir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/3_UCLA_dataset_GordonAtlas
		Anat_dir=$fmriprep_dir/$subID/'anat'
		TimeSeries_dir=$fmriprep_dir/$subID/'TimeSeries'
		MNI_template=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/mni_icbm152_t1_tal_nlin_asym_09c_2mm.nii
		Gordon_Atlas=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/GordonParcels_MNI_333.nii
		Out_dir=$fmriprep_dir/$subID/TimeSeries

		if [ ! -d $TimeSeriesDir ]; then mkdir $TimeSeriesDir; echo "making TimeSeries directory"; fi


		#Step 5: Get initial affine transform that maps T1 to MNI.
		echo -e "\nGetting affine transformation to map T1 to MNI space\n"
		flirt -ref $MNI_template \
		-in $Anat_dir/$subID'_T1w_space-MNI152NLin2009cAsym_preproc.nii.gz' \
		-omat $Out_dir/$subID'_task-rest_variant-'$cond'_affine_T1toMNI.mat'; 

		#Step 6: Use the affine transform to get warp coefficients to convert T1 to MNI space.
		echo -e "\nUsing affine transformation to get warp coefficients to convert T1 to MNI space\n"
		fnirt --ref=$MNI_template \
		--in=$Anat_dir/$subID'_T1w_space-MNI152NLin2009cAsym_preproc.nii.gz' \
		--aff=$Out_dir/$subID'_task-rest_variant-'$cond'_affine_T1toMNI.mat';

		#Step 7: Rename warpcoeffient file to subID and condition.
		echo -e "\nRenaming warpcoeff based upon subID and condition\n"
		mv $Anat_dir/$subID'_T1w_space-MNI152NLin2009cAsym_preproc_warpcoef.nii.gz' $Out_dir/$subID'_task-rest_variant-'$cond'_space-MNI152NLin2009cAsym_desc-preproc_T1_to_MNI_warpcoef.nii.gz'; 
		
		#Step 8: Inverse the T1_to_MNI warp coefficients to MNI_to_T1 warp. You can use this to convert the PFC sphere to T1 space, as it is currently in MNI space.
		echo -e "\nFlipping T1_to_MNI warp coefficients to MNI_to_T1 warp. You can use this to convert the Gordon's atlas to T1 space, as it is currently in MNI space\n"
		invwarp --ref=$Anat_dir/$subID'_T1w_space-MNI152NLin2009cAsym_preproc.nii.gz' \
		--warp=$Out_dir/$subID'_task-rest_variant-'$cond'_space-MNI152NLin2009cAsym_desc-preproc_T1_to_MNI_warpcoef.nii.gz' \
		--out=$Out_dir/$subID'_task-rest_variant-'$cond'_space-MNI152NLin2009cAsym_desc-preproc_MNI_to_T1_warpcoef.nii.gz';

		#Step 8: Apply the MNI_to_T1 warp to PFC sphere as the PFC sphere is in MNI space. So, we need to convert it to T1 space.
		echo -e "\nApply the MNI_to_T1 warp to PFC sphere as the PFC sphere is in MNI space. So, we need to convert it to T1 space\n"
		applywarp --ref=$Anat_dir/$subID'_T1w_space-MNI152NLin2009cAsym_preproc.nii.gz' \
		--in=$Gordon_Atlas \
		--warp=$Out_dir/$subID'_task-rest_variant-'$cond'_space-MNI152NLin2009cAsym_desc-preproc_MNI_to_T1_warpcoef.nii.gz' \
		--out=$Out_dir/$subID'_task-rest_variant-'$cond'_Gordon_space-T1' \
		--interp=nn;

		#Step 10: Get matrix to convert T1 to func space.
		echo -e "\nGetting matrix to convert T1 to functional image space\n"
		flirt -ref $fmriprep_dir/$subID/func/$subID'_task-rest_bold_space-MNI152NLin2009cAsym_variant-'$cond'.nii.gz' \
		-in $Anat_dir/$subID'_T1w_space-MNI152NLin2009cAsym_preproc.nii.gz' \
		-dof 6 \
		-omat $Out_dir/$subID'_task-rest_variant-'$cond'_T1_to_func.mat';

		#Step 11: Get PFC sphere that is in T1 space to func space.
		flirt -ref $fmriprep_dir/$subID/func/$subID'_task-rest_bold_space-MNI152NLin2009cAsym_variant-'$cond'.nii.gz' \
		-in $Out_dir/$subID'_task-rest_variant-'$cond'_Gordon_space-T1' \
		-init $Out_dir/$subID'_task-rest_variant-'$cond'_T1_to_func.mat' \
		-applyxfm \
		-interp nearestneighbour \
		-out $Out_dir/$subID'_task-rest_variant-'$cond'_Gordon_space-func.nii.gz';

		#Step 12: Use fslmeants, and the PFC sphere_space-func mask to extract the timeseries from the preproc_bold_smooth.nii file.
		fslmeants -i $fmriprep_dir/$subID/func/$subID'_task-rest_bold_space-MNI152NLin2009cAsym_variant-'$cond'.nii.gz' \
		-o $Out_dir/$subID'_task-rest_variant-'$cond'_Gordon_ts.txt' \
		--label=$Out_dir/$subID'_task-rest_variant-'$cond'_Gordon_space-func.nii.gz' \
		--transpose; 
	
		done
done
