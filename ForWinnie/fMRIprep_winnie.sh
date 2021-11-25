#!/bin/env bash

#SBATCH --job-name=fmriprep
#SBATCH --account=dq13
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1-00:00:00
# SBATCH --mail-user=tribikram.thapa@monash.edu
# SBATCH --mail-type=FAIL
# SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=8000
#SBATCH --qos=normal
#SBATCH -A dq13

subject=$s #104 	 #$s

# paths
bidsdir=/home/winnieo/dq13/Winnie/NAPPY/data/rawdata # path to a valid BIDS dataset
fslicense=/home/winnieo/dq13/Winnie/NAPPY/scripts/license.txt # path and freesurfer licence .txt file. Download your own from freesurfer website and store.
workdir=/home/winnieo/dq13/Winnie/NAPPY/scripts/work/${subject} # this is a temp directory where intermediate outputs/files from fmriprep are dumped. Must be subject specific
derivsdir=/home/winnieo/dq13/Winnie/NAPPY/data/derivatives/fmriprep # path to whether derivatives will go. This can be anywhere

# other things to consider below:
# 1) -t flag. I have it set to rest but you might want to change this depending on your needs.
# 2) --use-syn-sdc \ This is a map-free distortion correction method. i.e., this flag ignores existing fieldmaps and performs distortion correction using fieldmapless approach# 3) this variant of the code runs freesurfer.
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
--output-spaces T1w MNI152NLin2009cAsym:res-2 MNI152NLin6Asym:res-2 \
--use-aroma	\
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

