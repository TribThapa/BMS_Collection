#Step 1: Load FSL.
module load fsl

#Step 2: Enter subjects IDs.
subID=$(</projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/SubjectIDs.txt)

for subID in $subID; do
			
	#Step 4: Define paths to directories.
	DataDir=/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest
	TimeSeriesDir=$DataDir/TimeSeries/$subID/TimeSeries
	
	rm $TimeSeriesDir/*.gz $TimeSeriesDir/*.mat

done


