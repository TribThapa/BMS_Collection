WHERESMYSCRIPT="/projects/kg98/Thapa/MBBP/Scripts/code"

source ${WHERESMYSCRIPT}/SetupEnv.sh


for ID in $SUBJIDS; do 

INPATHFWD="${PARENTDIR}/sub-MBBP${ID}/dwi/sub-MBBP${ID}_RLDWI"

OUTPATHFWD="${PARENTDIR}/sub-MBBP${ID}/dwi/forward.mif"

INPATHREV="${PARENTDIR}/sub-MBBP${ID}/fmap/sub-MBBP${ID}_LRDWI"

OUTPATHREV="${PARENTDIR}/sub-MBBP${ID}/dwi/reverse.mif"

#sbatch --job-name=${ID} --output="slurm-${ID}.out" ${WHERESMYSCRIPT}/PrepareDiffusionData_dicomextracted.sh $WHERESMYSCRIPT $FILESEP $SUBJECTID $INPATHFWD $OUTPATHFWD $INPATHREV $OUTPATHREV
${WHERESMYSCRIPT}/PrepareDiffusionData_dicomextracted.sh $WHERESMYSCRIPT $FILESEP $ID $INPATHFWD $OUTPATHFWD $INPATHREV $OUTPATHREV
done

