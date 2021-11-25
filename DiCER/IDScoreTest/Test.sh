#!/bin/sh

$CBIG_CODE_DIR/stable_projects/preprocessing/Li2019_GSR/KernelRidgeRegression/HCP/scripts/CBIG_LiGSR_KRR_workflowHCP.sh 

-subject_list xxx/subject_list_953.txt 

-RSFC_file xxx/cort+subcort_new_S1200_953_Fisher.mat 

-y_list xxx/Cognitive_unrestricted.txt 

-covariate_list xxx/covariates_58behaviors.txt 

-FD_file xxx/FD_regressor_953.txt

-DVARS_file xxx/DV_regressor_953.txt 

-outdir xxx/ref_output 

-seed 1
