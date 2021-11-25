#!/bin/env bash

#SBATCH --job-name=fmriprep
#SBATCH --account=kg98
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1-00:00:00
#SBATCH --mail-user=tribikram.thapa@monash.edu
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=8000
#SBATCH --qos=normal
#SBATCH -A kg98
#SBATCH --array=1-2
#IMPORTANT! set the array range above to exactly the number of people in your SubjectIDs.txt file. e.g., if you have 90 subjects then array should be: --array=1-90

SUBJECT_LIST="/home/ttha0011/kg98/Thapa/MBBP/All_Subs/4_fMRIPrep/1_GRE/SubjectIDs.txt"

# comment out SLURM_ARRAY_TASK_ID=1 to run multiple subs
#SLURM_ARRAY_TASK_ID=1
subject=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${SUBJECT_LIST})
echo -e "\t\t\t --------------------------- "
echo -e "\t\t\t ----- ${SLURM_ARRAY_TASK_ID} ${subject} ----- "
echo -e "\t\t\t --------------------------- \n"

# paths
workdir=/projects/kg98/Thapa/MBBP/All_Subs/4_fMRIPrep/1_GRE/Temp/${subject} # this directory is just a temp directory where intermediate outputs/files from fmriprep are dumped. It must be subject specific though!
bidsdir=/home/ttha0011/kg98/Thapa/MBBP/All_Subs/4_fMRIPrep/1_GRE/rawdata # path to a valid BIDS dataset
derivsdir=/home/ttha0011/kg98/Thapa/MBBP/All_Subs/4_fMRIPrep/1_GRE/derivatives # path to whether derivatives will go. This can be anywhere
fslicense=/home/ttha0011/kg98/Thapa/Scripts/license.txt # path and freesurfer licence .txt file. Download your own from freesurfer website and store. Or just leave it and use mine!

# other things to consider below:
# 1) -t flag. I have it set to rest but you might want to change this depending on your needs.
# 2) --use-syn-sdc \ This is a map-free distortion correction method. In otherwords, this flag ignores existing fieldmaps and performs distortion correction using fieldmapless approach.
# 3) this variant of the code runs freesurfer.
# 4) --t2s-coreg \ T2*map is created to perform a T2*-driven co-registration t2s-coreg. Important when using ME-data. Otherwise the middle echo is used.
# 5) --fs-no-reconall \ disables Freesurfer surface preprocessing.
# 6) --ignore fieldmaps \ if you do not want to use fieldmaps.
# 7) --skip_bids_validation \ skips bids validation.

# --------------------------------------------------------------------------------------------------
# MASSIVE modules
module load fmriprep/1.4.0
unset PYTHONPATH

# Run fmriprep
fmriprep \
--participant-label ${subject} \
--output-spaces MNI152NLin2009cAsym T1w \
--t2s-coreg \
--mem_mb 80000 \
-n-cpus 8 \
--fs-license-file ${fslicense} \
-w ${workdir} \
${bidsdir} \
${derivsdir} \
participant

# --------------------------------------------------------------------------------------------------

echo -e "\t\t\t ----- DONE ----- "

