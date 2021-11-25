#!/bin/bash

#Step1: Load FSL.
module load fsl/5.0.9

#need to copy the tissue masks from the anat folder to the dicer lightweight output folder

#Step 2: Enter subID here or into a text file to loop over multiple subjects.
subID=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/SubjectIDs.txt)

for subID in $subID; do
	
	#Step 3: Enter conditions.
	cond=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/Conditions.txt)
		
		for cond in $cond; do
		
		#Step 4: Define paths to anat, func, and dicer directories.
		anat_dir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/2_fMRIPrep/derivatives/fmriprep/$subID/anat
		func_dir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/2_fMRIPrep/derivatives/fmriprep/$subID/func
		sub_dicer_dir=/home/ttha0011/kg98/Thapa//DiCER/1_ParametersProject/3_RunDiCER/$subID
		dicer_dir=$sub_dicer_dir/$subID"_"$cond"_dicer_lite0.2"

		#Step 5: Make directories if it doesn't exist.
		if [ ! -d $sub_dicer_dir ]; then mkdir $sub_dicer_dir; echo "$ID - making directory"; fi
		if [ ! -d $dicer_dir ]; then mkdir $dicer_dir; echo "$ID - making directory"; fi	

		#Step 6: Copy tissues segmentations from the anat folder, and AROMA-ed epi from the func folder to the dicer directory created in Step 5.
		cp $anat_dir/$subID"_space-MNI152NLin2009cAsym_label-CSF_probseg.nii.gz" $dicer_dir
		cp $anat_dir/$subID"_space-MNI152NLin2009cAsym_label-WM_probseg.nii.gz" $dicer_dir
		cp $anat_dir/$subID"_space-MNI152NLin2009cAsym_label-GM_probseg.nii.gz" $dicer_dir
		cp $anat_dir/$subID"_space-MNI152NLin2009cAsym_dseg.nii.gz" $dicer_dir
		cp $anat_dir/$subID"_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz" $dicer_dir
		cp $func_dir/$subID"_task-"$cond"_space-MNI152NLin2009cAsym_desc-smoothAROMAnonaggr_bold.nii.gz" $dicer_dir
		cp $func_dir/$subID"_task-"$cond"_space-MNI152NLin2009cAsym_desc-aseg_dseg.nii.gz" $dicer_dir
	
		#Step 7: Enter the name for time series and gray matter mask. These names will be used to save data in the steps below.
		mean_ts=$subID"_func_gm_meants.nii.gz"
		gm_mask_tmp=$subID"_gm_mask"

		#Step 8: Change directory to DiCER directory.
		cd $dicer_dir
		
		#Step 9: Use gray matter probability segmentation file from fMRIPrep to make gray matter probability mask, and save it as named in Step 7.
		fslmaths $subID"_space-MNI152NLin2009cAsym_label-GM_probseg.nii.gz" -thr 0.2 -bin $gm_mask_tmp
		
		#Step 10: Get a mean time-series from the AROMAed_bold.nii.gz file (i.e., the func image), and save it as named in Step 7.
		fslmaths $subID"_task-"$cond"_space-MNI152NLin2009cAsym_desc-smoothAROMAnonaggr_bold.nii.gz" -Tmean $mean_ts

		#Step 11: Use the gray matter mask from Step 9, and time series from Step Step 10 to create a gray matter probability tissue file.
		flirt -in $gm_mask_tmp -ref $mean_ts -out GM_probtissue -applyxfm -interp nearestneighbour -usesqform

		#Step 12: Use white matter probability file segmentation from fMRIPrep to make white matter probability tissue file.
		flirt -in $subID"_space-MNI152NLin2009cAsym_label-WM_probseg.nii.gz" -ref $mean_ts -out WM_probtissue -applyxfm -interp nearestneighbour -usesqform

		#Step 13: Use CSF probability segmentation file from fMRIPrep to make CSF probability tissue file.
		flirt -in $subID"_space-MNI152NLin2009cAsym_label-CSF_probseg.nii.gz" -ref $mean_ts -out CSF_probtissue -applyxfm -interp nearestneighbour -usesqform

		#Step 14: Use anatomical segmentation file from fMRIPrep to make segmentation file in bold space.
		flirt -in $subID"_space-MNI152NLin2009cAsym_dseg_old.nii.gz" -ref $mean_ts -out $subID"_bold_space-MNI152NLin2009cAsym_dseg_old.nii.gz" -applyxfm -interp nearestneighbour -usesqform

		fslmaths $mean_ts -mul GM_probtissue.nii.gz $mean_ts

		read min max <<< $(fslstats $mean_ts -r)

		#Step 17: Name a restrictive mask.
		gm_mask_restrictive=$subID"_mask_restrictive"

		#Step 18: Create a restrictive mask with the top 80% percent (determined from the -thr 0.2). 
		fslmaths $mean_ts -div $max -thr 0.2 -bin $gm_mask_restrictive 

		fslmaths $gm_mask_restrictive -mul GM_probtissue -mul 2 $gm_mask_restrictive

		# Now we have everything to work with and combine it all together now (fix up too many volumes)

		tissue_mask=$subID"_bold_space-MNI152NLin2009cAsym_dseg_old.nii.gz"

		fslmaths $tissue_mask -add $gm_mask_restrictive $tissue_mask

		echo $tissue_mask

		done
done


