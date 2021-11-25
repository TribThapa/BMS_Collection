#!/bin/bash

#This script will reorder tissue_T1w to CSF=1, GM=2, WM=3 (note the alphabetical order to help remember). Currently, with the newer version of fMRIPrep, the tiusses are in this order: GM=1, WM=2, CSF=3.

#Step1: Load FSL.
module purge
module load fsl/5.0.9

#Step 2: Enter subID here or into a text file to loop over multiple subjects.
subID=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/SubjectIDs.txt)

for subID in $subID; do
	
	#Step 3: Enter conditions.
	cond=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/Conditions.txt)
		
		for cond in $cond; do
		
		#Step 4: Define paths to anat, func, and dicer directories.
		prepro_variant=smoothAROMAnonaggr
		space_variant=MNI152NLin2009cAsym
		fMRIPrep_dir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/2_fMRIPrep
		dseg=$fMRIPrep_dir/derivatives/fmriprep/$subID/anat/$subID"_space-"$space_variant"_dseg.nii.gz"
		sub_dicer_dir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/$subID
		dicer_dir=$sub_dicer_dir/$subID"_"$cond"_dicer_lite0.2"
		dseg_old=$dicer_dir/$subID"_space-"$space_variant"_dseg_old.nii.gz"

		#Step 5: Make directories if it doesn't exist.
		if [ ! -d $sub_dicer_dir ]; then mkdir $sub_dicer_dir; echo "$subID - making directory"; fi
		if [ ! -d $dicer_dir ]; then mkdir $dicer_dir; echo "$subID - making directory"; fi
		
		#Step 6: Copy dseg file and bold image to dicer_dir.
		cp $dseg $dicer_dir
		cp $fMRIPrep_dir/derivatives/fmriprep/$subID/func/$subID"_task-"$cond"_space-MNI152NLin2009cAsym_desc-smoothAROMAnonaggr_bold.nii.gz" $dicer_dir

		#Step 7: Rename the desg file (is the output from the new fMRIPrep version) to dseg_old.
		mv $dicer_dir/$subID"_space-"$space_variant"_dseg.nii.gz" $dicer_dir/$subID"_space-"$space_variant"_dseg_old.nii.gz" ; 
			
			#Step 8: Use fslmaths to threshold tissues.
			for s in {1..3} ; do 
				fslmaths $dseg_old -thr ${s} -uthr ${s} ${s}_temp_dtissue_T1w.nii ;
	 		done 
			
		#Step 9: Merge thresholded tissues in this order CSF=1, GM=2, WM=3 for DiCER.
		fslmaths 1_temp_dtissue_T1w -mul 2 1_temp_dtissue_T1w ; # GM=1 in fMRIPrep. Therefore, 1 x 2 = 2.
		fslmaths 2_temp_dtissue_T1w -div 2 -mul 3 2_temp_dtissue_T1w ; # WM=2 in fMRIPrep. Therefore, 2/2 = 1 x 3 = 3.
		fslmaths 3_temp_dtissue_T1w -div 3 3_temp_dtissue_T1w ; # CSF=3 in fMRIPrep. Therefore, 3/3 = 1.
		fslmaths 1_temp_dtissue_T1w -add 2_temp_dtissue_T1w -add 3_temp_dtissue_T1w $dseg_old.nii ; 
	
		done
done
