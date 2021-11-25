#!/bin/bash
#SBATCH --job-name=DiCER
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

#Step1: Load necessary modules.
module purge
module load afni
module load fsl/5.0.9
module load anaconda/5.0.1-Python2.7-gcc5

#Step 1: Define path to dicer directory.
dicer_dir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/ScriptsUsed/DiCER/

#Step 2: Define path to text files with subject IDs.
subID=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/SubjectIDs.txt)

for subID in $subID; do
	
	#Step 3: Enter conditions.
	cond=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/Conditions.txt)
		
		for cond in $cond; do
			
			#Step 4: Change directory to DiCER directory to run DiCER_lightweight.
			cd /home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/ScriptsUsed/DiCER

			#Step 5: Run DiCER_lightweight.
			sh DiCER_lightweight.sh -i $subID"_task-"$cond"_space-MNI152NLin2009cAsym_desc-smoothAROMAnonaggr_bold.nii.gz" -t $subID"_bold_space-MNI152NLin2009cAsym_dseg_old.nii.gz" -w "/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_RunDiCER/"$subID"/"$subID"_"$cond"_dicer_lite0.2/" -s $subID -p 12

		done 
done 
