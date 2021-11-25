#!/bin/env bash

# Set paths
PROJ_DIR=/home/ttha0011/kg98/Thapa/MBBP/All_Subs/3_MRIQC 
BIDS_DIR=$PROJ_DIR/rawdata
OUT_DIR=$PROJ_DIR/mriqc_indv_output
GROUP_DIR=$PROJ_DIR/mriqc_group_output

if [ ! -d $GROUP_DIR ]; then mkdir $GROUP_DIR; echo "making group directory"; fi

# Load MRIQC module
module purge
module load mriqc/0.14.2

# Run MRIQC group report
mriqc -v $BIDS_DIR $OUT_DIR group \

# Move group report to the group_output folder
mv $OUT_DIR/group_bold.html $GROUP_DIR

mv $OUT_DIR/group_bold.tsv $GROUP_DIR

mv $OUT_DIR/group_T1w.html $GROUP_DIR

mv $OUT_DIR/group_T1w.tsv $GROUP_DIR

 -----------------------------------------------------------------------------------------END------------------------------------------------------------------------------------------
