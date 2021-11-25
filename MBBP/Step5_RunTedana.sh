#!/bin/env bash

##Read this to correctly interpret outputs from Tedana: https://tedana.readthedocs.io/en/latest/outputs.html 

#Step 1: Activate virtual environment on Massive
source /home/ttha0011/kg98/Thapa/12/bin/activate 

#Step 2: Purge all existing modules, and load the anaconda module
module purge
module load anaconda 

#Step 3: Define paths to directories, subID(s), and task(s)
TedanaDir=/home/ttha0011/kg98/Thapa/MBBP/All_Subs/6_Tedana

subID=MBBP81

task=REST

TedanaInputDir=${TedanaDir}/sub-${subID}/${task}/Input
TedanaOutputDir=${TedanaDir}/sub-${subID}/${task}/Output
TransDir=/home/ttha0011/kg98/Thapa/MBBP/All_Subs/7_Transformations/sub-${subID}/${task}

#Step 4: Define individual echo files
echo1=${TedanaInputDir}/sub-${subID}_task-${task}_echo-1_space-native_desc-partialPreproc_bold.nii.gz
echo2=${TedanaInputDir}/sub-${subID}_task-${task}_echo-2_space-native_desc-partialPreproc_bold.nii.gz
echo3=${TedanaInputDir}/sub-${subID}_task-${task}_echo-3_space-native_desc-partialPreproc_bold.nii.gz
echo4=${TedanaInputDir}/sub-${subID}_task-${task}_echo-4_space-native_desc-partialPreproc_bold.nii.gz

#Step 5: Enter echo time in milliseconds corresponding to each file in Step 4
echoT1=0.0126
echoT2=0.02923
echoT3=0.04586
echoT4=0.06249

#Step 6: Run Tedana
tedana -d $echo1 $echo2 $echo3 $echo4 \
-e $echoT1 $echoT2 $echoT3 $echoT4 \
--out-dir $TedanaOutputDir \
--verbose \
--png 

cp ${TedanaOutputDir}/dn_ts_OC.nii ${TransDir}/"sub-${subID}_task-${task}_dn_ts_OC.nii"
 

