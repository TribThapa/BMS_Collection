#!/bin/bash
# This script downloads dicoms from XNAT and convert them to nifti using dcm2niix for multi echo data
# Nifti files will be named and organised according to BIDS

# If you havent used xnat-utils before, please load module on your terminal
# It will ask for your log-in details
# Once you've logged on, the module will remember your credentials
# and will allow you to download scans at any time.
# If your password changes you must re-enter your details by loading xnat (module load xnat-utils)
# then enter an xnat function with your authcate username at the end ie. xnat-ls --user <authcate>
# You can then re-enter and save your password.

# BIDS file naming convention:
# t1: sub-000_T1w.nii.gz
# dwi: sub-000_dwi.nii.gz
# rs-fmri: sub-000_task-rest_bold.nii.gz 
# task fmri multiple runs: sub-000_task-nback_run-01_bold.nii.gz
# if you have controls/patients: sub-control000_task-rest_bold.nii.gz / sub-patient000_task-rest_bold.nii.gz
# Accompanying .json files will be created by dcm2niix

# Kristina Sabaroedin and Tribikram Thapa BMH, 2018

# Your project paths on your local machine/MASSIVE
PROJDIR=/projects/kg98/Thapa/MBBP/All_Subs
DICOMDIR=$PROJDIR/1_dicomdir
RAWDATADIR=$PROJDIR/2_rawdata


if [ ! -d $PROJDIR ]; then mkdir $PROJDIR; echo "making directory"; fi
if [ ! -d $DICOMDIR ]; then mkdir $DICOMDIR; echo "making directory"; fi
if [ ! -d $RAWDATADIR ]; then mkdir $RAWDATADIR; echo "making directory"; fi


# These variables are based on the name of your project and scans on XNAT
# Please edit them accordingly
# Often, scans are named differently on XNAT
# See "First level data cleaning on XNAT" in Evernote for instructions
# After running this script, please check whether all scans are there
# If they are missing, go back on XNAT and see if the scans are named differently

ANATOMICAL1=5000TR_t1_mp2rage_sag_p3_iso_INV1
ANATOMICAL2=5000TR_t1_mp2rage_sag_p3_iso_INV2
ANATOMICAL3=5000TR_t1_mp2rage_sag_p3_iso_UNI_Images
ANATOMICAL4=t1_mprage_sag_p3_iso_1_ADNI
CONDITION_1=REV_PE_L-R_mmb_4_4_cmrr_mbep2d_bold_TE_12.6_29.23_45.86_62.49
CONDITION_2=Peer_R-L_mmb_4_4_cmrr_mbep2d_bold_TE_12.6_29.23_45.86_62.49
CONDITION_3=Rest_R-L_mmb_4_4_cmrr_mbep2d_bold_TE_12.6_29.23_45.86_62.49
CONDITION_4=gre_field_mapping_3mm_gremag
CONDITION_5=gre_field_mapping_3mm_greph
CONDITION_6=SSRT_R-L_mmb_4_4_cmrr_mbep2d_bold_TE_12.6_29.23_45.86_62.49
CONDITION_7=Momentos_R-L_mmb_4_4_cmrr_mbep2d_bold_TE_12.6_29.23_45.86_62.49
CONDITION_8=t2_space_sag_p2_iso
CONDITION_9=Elevator_R-L_mmb_4_4_cmrr_mbep2d_bold_TE_12.6_29.23_45.86_62.49
CONDITION_10=R-L_ep2d_dti_2.5mm_iso_mrtrix_71_dx
CONDITION_11=L-R_ep2d_dti_2.5mm_iso_mrtrix_71_dx
STUDY=MRH106_
SESSION=_MR01 #can change to download different sessions

# Text file containing subject IDs
# These IDs just need to be the last three digits (zero padded) i.e. 007, 098, 231, etc
# Change to point to directory where text file is located
SUBJIDS=MBBP211
#SUBJIDS=$(</projects/kg98/yourdirectory/subjectlist.txt)

# load modules
module purge;
module load xnat-utils;
# Load the dcm2niix software
module load mricrogl/1.0.20170207
# Module toggles (on/off)
MODULE1=1 #dcm2niix

# create for loop to loop over IDs
for ID in $SUBJIDS; do 
	
	# Dynamic directories
	SUBDICOMDIR=$DICOMDIR/sub-$ID
	OUTDIR=$RAWDATADIR/sub-$ID;
	EPIOUTDIR=$OUTDIR/func;
	T1OUTDIR=$OUTDIR/anat;
	FMAPOUTDIR=$OUTDIR/fmap;
	DWIOUTDIR=$OUTDIR/dwi;

	# Create subject's DICOMS folders 
	mkdir -p $SUBDICOMDIR/

	# Download structural scans from XNAT
	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $ANATOMICAL1;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $ANATOMICAL2;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $ANATOMICAL3;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $ANATOMICAL4;

	# Download functional scans from XNAT
	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_1;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_2;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_3;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_4;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_5;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_6;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_7;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_8;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_9;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_10;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_11;

	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_12;

	# Delete intermediate folders
	mv $SUBDICOMDIR/$STUDY$ID$SESSION/* $SUBDICOMDIR

	rm -rf $SUBDICOMDIR/$STUDY$ID$SESSION

	# rename scan directories with more reasonable naming conventions

	# t1
	if [ -d "${SUBDICOMDIR/*$ANATOMICAL1}" ]; then 
		mv $SUBDICOMDIR/"14-"$ANATOMICAL1 $SUBDICOMDIR/T1INV1; 
	else 
		echo "No T1INV1 scan for $ID"; 
	fi


	if [ -d "${SUBDICOMDIR/*$ANATOMICAL2}" ]; then 
		mv $SUBDICOMDIR/"16-"$ANATOMICAL2 $SUBDICOMDIR/T1INV2; 
	else 
		echo "No T1INV2 scan for $ID"; 
	fi


	if [ -d "${SUBDICOMDIR/*$ANATOMICAL3}" ]; then 
		mv $SUBDICOMDIR/"15-"$ANATOMICAL3 $SUBDICOMDIR/UNI; 
	else 
		echo "No UNI scan for $ID"; 
	fi


	if [ -d "${SUBDICOMDIR/*$ANATOMICAL4}" ]; then 
		mv $SUBDICOMDIR/"2-"$ANATOMICAL4 $SUBDICOMDIR/T1; 
	else 
		echo "No T1 scan for $ID"; 
	fi

	# fMRI
	if [ -d "${SUBDICOMDIR/*$CONDITION_1}" ]; then 
		mv $SUBDICOMDIR/"3-"REV_PE_L_R_mmb_4_4_cmrr_mbep2d_bold_TE_12_6_29_23_45_86_62_49 $SUBDICOMDIR/REVPE; 
	else 
		echo "No REVPE scan for $ID"; 
	fi	

	if [ -d "${SUBDICOMDIR/*$CONDITION_2}" ]; then 
		mv $SUBDICOMDIR/"4-"Peer_R_L_mmb_4_4_cmrr_mbep2d_bold_TE_12_6_29_23_45_86_62_49 $SUBDICOMDIR/PEER;    
	else 
		echo "No PEER scan for $ID"; 
	fi	

	if [ -d "${SUBDICOMDIR/*$CONDITION_3}" ]; then 
		mv $SUBDICOMDIR/"5-"Rest_R_L_mmb_4_4_cmrr_mbep2d_bold_TE_12_6_29_23_45_86_62_49 $SUBDICOMDIR/REST; 
	else 
		echo "No REST scan for $ID"; 
	fi

	if [ -d "${SUBDICOMDIR/*$CONDITION_4}" ]; then 
		mv $SUBDICOMDIR/"6-"gre_field_mapping_3mm_gremag $SUBDICOMDIR/gremag;    
	else 
		echo "No gremag scan for $ID"; 
	fi	
	
	if [ -d "${SUBDICOMDIR/*$CONDITION_5}" ]; then 
		mv $SUBDICOMDIR/"7-"gre_field_mapping_3mm_greph $SUBDICOMDIR/greph;    
	else 
		echo "No greph scan for $ID"; 
	fi	

	if [ -d "${SUBDICOMDIR/*$CONDITION_6}" ]; then 
		mv $SUBDICOMDIR/"8-"SSRT_R_L_mmb_4_4_cmrr_mbep2d_bold_TE_12_6_29_23_45_86_62_49 $SUBDICOMDIR/SSRT;    
	else 
		echo "No SSRT scan for $ID"; 
	fi	

	if [ -d "${SUBDICOMDIR/*$CONDITION_7}" ]; then 
		mv $SUBDICOMDIR/"9-"Momentos_R_L_mmb_4_4_cmrr_mbep2d_bold_TE_12_6_29_23_45_86_62_49 $SUBDICOMDIR/Momentos; 
	else 
		echo "No Momentos scan for $ID"; 
	fi

	if [ -d "${SUBDICOMDIR/*$CONDITION_8}" ]; then 
		mv $SUBDICOMDIR/"10-"t2_space_sag_p2_iso $SUBDICOMDIR/T2;    
	else 
		echo "No T2 scan for $ID"; 
	fi	

	if [ -d "${SUBDICOMDIR/*$CONDITION_9}" ]; then 
		mv $SUBDICOMDIR/"11-"Elevator_R_L_mmb_4_4_cmrr_mbep2d_bold_TE_12_6_29_23_45_86_62_49 $SUBDICOMDIR/Elevator; 
	else 
		echo "No Elevator scan for $ID"; 
	fi	

	if [ -d "${SUBDICOMDIR/*$CONDITION_10}" ]; then 
		mv $SUBDICOMDIR/"12-"R_L_ep2d_dti_2_5mm_iso_mrtrix_71_dx $SUBDICOMDIR/RLDWI;    
	else 
		echo "No RLDWI scan for $ID"; 
	fi

	if [ -d "${SUBDICOMDIR/*$CONDITION_11}" ]; then 
		mv $SUBDICOMDIR/"13-"L_R_ep2d_dti_2_5mm_iso_mrtrix_71_dx $SUBDICOMDIR/LRDWI;    
	else 
		echo "No LRDWI scan for $ID"; 
	fi	

	
	# populate rawdata dir with subjects folders

	if [ ! -d $OUTDIR ]; then mkdir $OUTDIR; echo "$ID - making directory"; fi
	if [ ! -d $EPIOUTDIR ]; then mkdir $EPIOUTDIR; echo "$ID - making func directory"; fi
	if [ ! -d $T1OUTDIR ]; then mkdir $T1OUTDIR; echo "$ID - making anat directory"; fi
	if [ ! -d $FMAPOUTDIR ]; then mkdir $FMAPOUTDIR; echo "$ID - making fmap directory"; fi
	if [ ! -d $DWIOUTDIR ]; then mkdir $DWIOUTDIR; echo "$ID - making dwi directory"; fi

	################################ MODULE 1: dcm2niix convert #######################################
	
	if [ $MODULE1 = "1" ]; then
		
		echo -e "\nRunning MODULE 1: dcm2niix $ID \n"
		
		# t1
		dcm2niix -f "sub-"$ID"_T1w_INV1" -o $T1OUTDIR -b -m n -z y $SUBDICOMDIR"/T1INV1/"

		dcm2niix -f "sub-"$ID"_T1w_INV2" -o $T1OUTDIR -b -m n -z y $SUBDICOMDIR"/T1INV2/"

		dcm2niix -f "sub-"$ID"_T1w_UNI" -o $T1OUTDIR -b -m n -z y $SUBDICOMDIR"/UNI/"

		dcm2niix -f "sub-"$ID"_T1w" -o $T1OUTDIR -b -m n -z y $SUBDICOMDIR"/T1/"

		dcm2niix -f "sub-"$ID"_T2w" -o $T1OUTDIR -b -m n -z y $SUBDICOMDIR"/T2/"


		# fMRI epi
		dcm2niix -f "sub-"$ID"_task-REVPE_bold" -o $FMAPOUTDIR -b -m n -z y $SUBDICOMDIR"/REVPE/"
		
		mv $FMAPOUTDIR/"sub-"$ID"_task-REVPE_bold.nii.gz" $FMAPOUTDIR/"sub-"$ID"_dir-LRecho1_epi.nii.gz"

		mv $FMAPOUTDIR/"sub-"$ID"_task-REVPE_bold.json" $FMAPOUTDIR/"sub-"$ID"_dir-LRecho1_epi.json"

		mv $FMAPOUTDIR/"_e2sub-"$ID"_task-REVPE_bold.nii.gz" $FMAPOUTDIR/"sub-"$ID"_dir-LRecho2_epi.nii.gz"

		mv $FMAPOUTDIR/"_e2sub-"$ID"_task-REVPE_bold.json" $FMAPOUTDIR/"sub-"$ID"_dir-LRecho2_epi.json"

		mv $FMAPOUTDIR/"_e3sub-"$ID"_task-REVPE_bold.nii.gz" $FMAPOUTDIR/"sub-"$ID"_dir-LRecho3_epi.nii.gz"

		mv $FMAPOUTDIR/"_e3sub-"$ID"_task-REVPE_bold.json" $FMAPOUTDIR/"sub-"$ID"_dir-LRecho3_epi.json"
		
		mv $FMAPOUTDIR/"_e4sub-"$ID"_task-REVPE_bold.nii.gz" $FMAPOUTDIR/"sub-"$ID"_dir-LRecho4_epi.nii.gz"

		mv $FMAPOUTDIR/"_e4sub-"$ID"_task-REVPE_bold.json" $FMAPOUTDIR/"sub-"$ID"_dir-LRecho4_epi.json"


		
		dcm2niix -f "sub-"$ID"_task-PEER_bold" -o $EPIOUTDIR -b -m n -z y $SUBDICOMDIR"/PEER/"
		
		mv $EPIOUTDIR/"sub-"$ID"_task-PEER_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-PEER_echo-1_bold.nii.gz"

		mv $EPIOUTDIR/"sub-"$ID"_task-PEER_bold.json" $EPIOUTDIR/"sub-"$ID"_task-PEER_echo-1_bold.json"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-PEER_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-PEER_echo-2_bold.nii.gz"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-PEER_bold.json" $EPIOUTDIR/"sub-"$ID"_task-PEER_echo-2_bold.json"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-PEER_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-PEER_echo-3_bold.nii.gz"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-PEER_bold.json" $EPIOUTDIR/"sub-"$ID"_task-PEER_echo-3_bold.json"

		mv $EPIOUTDIR/"_e4sub-"$ID"_task-PEER_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-PEER_echo-4_bold.nii.gz"

		mv $EPIOUTDIR/"_e4sub-"$ID"_task-PEER_bold.json" $EPIOUTDIR/"sub-"$ID"_task-PEER_echo-4_bold.json"


		
		dcm2niix -f "sub-"$ID"_task-REST_bold" -o $EPIOUTDIR -b -m n -z y $SUBDICOMDIR"/REST/"
		
		mv $EPIOUTDIR/"sub-"$ID"_task-REST_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-REST_echo-1_bold.nii.gz"

		mv $EPIOUTDIR/"sub-"$ID"_task-REST_bold.json" $EPIOUTDIR/"sub-"$ID"_task-REST_echo-1_bold.json"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-REST_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-REST_echo-2_bold.nii.gz"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-REST_bold.json" $EPIOUTDIR/"sub-"$ID"_task-REST_echo-2_bold.json"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-REST_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-REST_echo-3_bold.nii.gz"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-REST_bold.json" $EPIOUTDIR/"sub-"$ID"_task-REST_echo-3_bold.json"
		
		mv $EPIOUTDIR/"_e4sub-"$ID"_task-REST_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-REST_echo-4_bold.nii.gz"

		mv $EPIOUTDIR/"_e4sub-"$ID"_task-REST_bold.json" $EPIOUTDIR/"sub-"$ID"_task-REST_echo-4_bold.json"


		#fmap_mag

		dcm2niix -f "sub-"$ID"_task-gremag_bold" -o $FMAPOUTDIR -b -m n -z y $SUBDICOMDIR"/gremag/"
		
		mv $FMAPOUTDIR/"sub-"$ID"_task-gremag_bold.nii.gz" $FMAPOUTDIR/"sub-"$ID"_acq-greph_magnitude1.nii.gz"

		mv $FMAPOUTDIR/"sub-"$ID"_task-gremag_bold.json" $FMAPOUTDIR/"sub-"$ID"_acq-greph_magnitude1.json"

		mv $FMAPOUTDIR/"_e2sub-"$ID"_task-gremag_bold.nii.gz" $FMAPOUTDIR/"sub-"$ID"_acq-greph_magnitude2.nii.gz"

		mv $FMAPOUTDIR/"_e2sub-"$ID"_task-gremag_bold.json" $FMAPOUTDIR/"sub-"$ID"_acq-greph_magnitude2.json"


		#fmap_phase

		dcm2niix -f "sub-"$ID"_task-greph_bold" -o $FMAPOUTDIR -b -m n -z y $SUBDICOMDIR"/greph/"

		#mv $FMAPOUTDIR/"sub-"$ID"_task-grephase_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_acq-grephase_phasediff.nii.gz"

		#mv $FMAPOUTDIR/"sub-"$ID"_task-grephase_bold.json" $EPIOUTDIR/"sub-"$ID"_acq-grephase_phasediff.json"
		
		mv $FMAPOUTDIR/"_e2sub-"$ID"_task-greph_bold.nii.gz" $FMAPOUTDIR/"sub-"$ID"_acq-greph_phasediff.nii.gz"

		mv $FMAPOUTDIR/"_e2sub-"$ID"_task-greph_bold.json" $FMAPOUTDIR/"sub-"$ID"_acq-greph_phasediff.json"


		
		dcm2niix -f "sub-"$ID"_task-SSRT_bold" -o $EPIOUTDIR -b -m n -z y $SUBDICOMDIR"/SSRT/"
		
		mv $EPIOUTDIR/"sub-"$ID"_task-SSRT_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-SSRT_echo-1_bold.nii.gz"

		mv $EPIOUTDIR/"sub-"$ID"_task-SSRT_bold.json" $EPIOUTDIR/"sub-"$ID"_task-SSRT_echo-1_bold.json"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-SSRT_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-SSRT_echo-2_bold.nii.gz"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-SSRT_bold.json" $EPIOUTDIR/"sub-"$ID"_task-SSRT_echo-2_bold.json"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-SSRT_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-SSRT_echo-3_bold.nii.gz"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-SSRT_bold.json" $EPIOUTDIR/"sub-"$ID"_task-SSRT_echo-3_bold.json"

		mv $EPIOUTDIR/"_e4sub-"$ID"_task-SSRT_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-SSRT_echo-4_bold.nii.gz"

		mv $EPIOUTDIR/"_e4sub-"$ID"_task-SSRT_bold.json" $EPIOUTDIR/"sub-"$ID"_task-SSRT_echo-4_bold.json"


		
		dcm2niix -f "sub-"$ID"_task-Momentos_bold" -o $EPIOUTDIR -b -m n -z y $SUBDICOMDIR"/Momentos/"
		
		mv $EPIOUTDIR/"sub-"$ID"_task-Momentos_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-Momentos_echo-1_bold.nii.gz"

		mv $EPIOUTDIR/"sub-"$ID"_task-Momentos_bold.json" $EPIOUTDIR/"sub-"$ID"_task-Momentos_echo-1_bold.json"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-Momentos_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-Momentos_echo-2_bold.nii.gz"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-Momentos_bold.json" $EPIOUTDIR/"sub-"$ID"_task-Momentos_echo-2_bold.json"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-Momentos_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-Momentos_echo-3_bold.nii.gz"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-Momentos_bold.json" $EPIOUTDIR/"sub-"$ID"_task-Momentos_echo-3_bold.json"
		
		mv $EPIOUTDIR/"_e4sub-"$ID"_task-Momentos_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-Momentos_echo-4_bold.nii.gz"

		mv $EPIOUTDIR/"_e4sub-"$ID"_task-Momentos_bold.json" $EPIOUTDIR/"sub-"$ID"_task-Momentos_echo-4_bold.json"



		dcm2niix -f "sub-"$ID"_task-Elevator_bold" -o $EPIOUTDIR -b -m n -z y $SUBDICOMDIR"/Elevator/"
		
		mv $EPIOUTDIR/"sub-"$ID"_task-Elevator_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-Elevator_echo-1_bold.nii.gz"

		mv $EPIOUTDIR/"sub-"$ID"_task-Elevator_bold.json" $EPIOUTDIR/"sub-"$ID"_task-Elevator_echo-1_bold.json"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-Elevator_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-Elevator_echo-2_bold.nii.gz"

		mv $EPIOUTDIR/"_e2sub-"$ID"_task-Elevator_bold.json" $EPIOUTDIR/"sub-"$ID"_task-Elevator_echo-2_bold.json"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-Elevator_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-Elevator_echo-3_bold.nii.gz"

		mv $EPIOUTDIR/"_e3sub-"$ID"_task-Elevator_bold.json" $EPIOUTDIR/"sub-"$ID"_task-Elevator_echo-3_bold.json"

		mv $EPIOUTDIR/"_e4sub-"$ID"_task-Elevator_bold.nii.gz" $EPIOUTDIR/"sub-"$ID"_task-Elevator_echo-4_bold.nii.gz"

		mv $EPIOUTDIR/"_e4sub-"$ID"_task-Elevator_bold.json" $EPIOUTDIR/"sub-"$ID"_task-Elevator_echo-4_bold.json"


		
		#DIFFUSION DATA_RL_DWI

		dcm2niix -f "sub-"$ID"_RLDWI_bold" -o $DWIOUTDIR -b -m n -z y $SUBDICOMDIR"/RLDWI/"
		
		mv $DWIOUTDIR/"sub-"$ID"_RLDWI_bold.nii.gz" $DWIOUTDIR/"sub-"$ID"_RLDWI_epi.nii.gz"

		mv $DWIOUTDIR/"sub-"$ID"_RLDWI_bold.json" $DWIOUTDIR/"sub-"$ID"_RLDWI_epi.json"

		

		#DIFFUSION DATA_RL_DWI_LR_DTI

		dcm2niix -f "sub-"$ID"_LRDWI_bold" -o $DWIOUTDIR -b -m n -z y $SUBDICOMDIR"/LRDWI/"

		mv $DWIOUTDIR/"sub-"$ID"_LRDWI_bold.nii.gz" $DWIOUTDIR/"sub-"$ID"_LRDWI_epi.nii.gz"

		mv $DWIOUTDIR/"sub-"$ID"_LRDWI_bold.json" $DWIOUTDIR/"sub-"$ID"_LRDWI_epi.json"
		
		
		echo -e "\nFinished MODULE 1: dcm2niix convert: $ID \n"
	else
		echo -e "\nSkipping MODULE 1: dcm2niix convert: $ID \n"
	fi
	###################################################################################################


done
