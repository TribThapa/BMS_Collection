#!/bin/env bash

#SBATCH --job-name=fmriprep_Winnie
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

SUBJECT_LIST="/home/ttha0011/kg98/Thapa/WinnieData/SubjectIDs.txt"

subject=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${SUBJECT_LIST})
echo -e "\t\t\t --------------------------- "
echo -e "\t\t\t ----- ${SLURM_ARRAY_TASK_ID} ${subject} ----- "
echo -e "\t\t\t --------------------------- \n"

# paths
workdir=/projects/kg98/Thapa/WinnieData/4b_fMRIPrepv_20_2_1/Temp/${subject} 
bidsdir=/home/ttha0011/kg98/Thapa/WinnieData/rawdata 
derivsdir=/home/ttha0011/kg98/Thapa/WinnieData/4b_fMRIPrepv_20_2_1/derivatives 
fslicense=/home/ttha0011/kg98/Thapa/Scripts/Preprocessing/fMRIPrep/license.txt 

#--output-spaces T1w MNI152NLin2009cAsym:res-2 MNI152NLin6Asym:res-2 \

# --------------------------------------------------------------------------------------------------
# MASSIVE modules
module purge
module load fmriprep/20.2.1
unset PYTHONPATH

# Run fmriprep
fmriprep \
--participant-label ${subject} \
--output-spaces MNI152NLin2009cAsym:res-2 MNI152NLin6Asym:res-2 T1w \
--ignore slicetiming \
--mem_mb 80000 \
--n_cpus 8 \
--use-aroma \
--fs-license-file ${fslicense} \
-w ${workdir} \
${bidsdir} \
${derivsdir} \
participant

# --------------------------------------------------------------------------------------------------

echo -e "\t\t\t ----- DONE ----- "

