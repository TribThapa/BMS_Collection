#!/bin/env bash

#Step 1: Define paths to directories
DIR=/home/ttha0011/kg98/Thapa/WinnieData

TEMPLATE_DIR=/home/ttha0011/kg98/Thapa/Scripts/brain_atlasas/mni_icbm152_nlin_asym_09c_nifti/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c.nii

#Step 2: Enter subID
#subID=103
subID=$(</projects/kg98/Thapa/WinnieData/Scripts/SubjectIDs.txt)

for subID in $subID; do

	OUT_DIR=${DIR}/7_Transformations/sub-${subID}

	TED_DN_OC=${OUT_DIR}/sub-${subID}_task-REST_dn_ts_OC.nii.gz

	OUTPUT_FILE=${OUT_DIR}/sub-${subID}_task-REST_dn_ts_OC_transformed.nii

	ANAT_TRANSFORM=${OUT_DIR}/sub-${subID}_from-T1w_to-MNI152NLin2009cAsym_mode-image_xfm.h5

	REF_IMAGE_TRANSFORM=${OUT_DIR}/sub-${subID}_task-REST_from-reference_to-T1w_mode-image_xfm.txt

	SDC_APPLIED=${OUT_DIR}/sub-${subID}_task-REST_sdc_warpfieldQwarp.nii.gz


	# Step 6: Load modules to apply antsTransform
	module purge
	module load ants
	module load fsl

	antsApplyTransforms \
	-v 1 \
	-d 3 \
	-f 0 \
	-e 3 \
	--float 1 \
	-i ${TED_DN_OC} \
	-o ${OUTPUT_FILE} \
	-r ${TEMPLATE_DIR} \
	-t ${ANAT_TRANSFORM} \
	-t ${REF_IMAGE_TRANSFORM} \
	-t ${SDC_APPLIED} \

done

