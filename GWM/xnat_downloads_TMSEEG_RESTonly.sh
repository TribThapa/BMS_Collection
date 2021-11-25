#!/bin/bash

#Download TMS-EEG data_Genetics of Working Memory study 
PROJDIR=/projects/kg98/Thapa/GWM/RESTDATAonly
SCRIPTSDIR=/projects/kg98/Thapa/GWM/Scripts

#SUBJIDS=GWM012 #always change 'GWM005' acccording to participantID
SUBJIDS=$(<$SCRIPTSDIR/SubjectIDs.txt)

#create loop
for ID in $SUBJIDS; do 

#Set paths
	XNATDIR=$PROJDIR/xnatdata
	RAWDATADIR=$PROJDIR/1_Rawdata

	if [ ! -d $XNATDIR ]; then mkdir $XNATDIR; echo "making directory"; fi
	if [ ! -d $RAWDATADIR ]; then mkdir $RAWDATADIR; echo "making directory"; fi

#Study details
	STUDY=CLF025_
	SESSION=_EEG01


#Set condition to download
	#CONDITION_1=$SUBJID"_REST" #turn on for single subject dowload	
	CONDITION_1=$ID"_REST" #turn on for multiple subject download


#Load modules
	module purge;
	module load xnat-utils;


#Download from XNAT
cd $XNATDIR/; xnat-get $STUDY$ID$SESSION --scans $CONDITION_1;

#rename and move to rawdata dir

	if [ -d "${XNATDIR/*$CONDITION_1}" ]; then
		mv $XNATDIR/$STUDY$ID$SESSION/"$CONDITION_1-"$CONDITION_1 $RAWDATADIR/$CONDITION_1;
	else 
		echo "No REST data for $ID";
	fi

done 

#rm -rf $XNATDIR

  ################################################################################# END ########################################################################################

