#!/bin/env bash

#set paths
PROJ_DIR=/home/ttha0011/kg98/Thapa/MBBP/All_Subs/3_MRIQC 
BIDS_DIR=$PROJ_DIR/rawdata
OUT_DIR=$PROJ_DIR/mriqc_indv_output
WORK_DIR=$PROJ_DIR

SUBJIDS=MBBP206

#load MRIQC
module purge
module load mriqc/0.14.2

#RUN MRIQC for single subject analysis 

mriqc -v $BIDS_DIR $OUT_DIR participant \
--participant_label $SUBJIDS \
--n_procs 12 \
--n_cpus 6 \
--mem_gb 12 \
--hmc-fsl \
-m T1w bold \
--correct-slice-timing \
--work-dir $PROJ_DIR 

 -----------------------------------------------------------------------------------------END------------------------------------------------------------------------------------------
