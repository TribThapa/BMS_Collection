#!/bin/env bash

#Step 1: Define paths to directories
DIR=/home/ttha0011/kg98/Thapa/MBBP/All_Subs

TEMPLATE_DIR=/home/ttha0011/kg98/Thapa/Scripts/brain_atlasas/mni_icbm152_nlin_asym_09c_nifti/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c.nii

#Step 2: Enter subID
subID=MBBP81

#Step 3: Enter condition
task=REST

#Step 4: Define output directory
OUT_DIR=${DIR}/7_Transformations/sub-${subID}/${task}
#echo ${OUT_DIR}

#Step 5: Define paths to files that you will use to apply the transformation
TED_DN_OC=${OUT_DIR}/sub-${subID}_task-${task}_dn_ts_OC.nii
#echo ${TED_DN_OC}

OUTPUT_FILE=${OUT_DIR}/sub-${subID}_task-${task}_dn_ts_OC_transformed.nii
#echo ${OUTPUT_FILE}

ANAT_TRANSFORM=${OUT_DIR}/sub-${subID}_from-T1w_to-MNI152NLin2009cAsym_mode-image_xfm.h5
#echo ${ANAT_TRANSFORM}

REF_IMAGE_TRANSFORM=${OUT_DIR}/sub-${subID}_task-${task}_from-reference_to-T1w_mode-image_xfm.txt
#echo ${REF_IMAGE_TRANSFORM}

SDC_APPLIED=${OUT_DIR}/sub-${subID}_task-${task}_sdc_warpfieldQwarp.nii.gz
#echo ${SDC_APPLIED}

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

