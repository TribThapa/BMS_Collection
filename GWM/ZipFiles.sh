#!/bin/env bash

#SBATCH --job-name=ZipFiles_GWM
#SBATCH --account=kg98
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2-00:00:00
#SBATCH --mail-user=tribikram.thapa@monash.edu
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=8000
#SBATCH --qos=normal
#SBATCH -A kg98
#SBATCH --array=1

# paths
DirName=1_Rawdata

#path to directory you want to zip
Dir=/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/$DirName 

zip -r $Dir.zip $Dir
