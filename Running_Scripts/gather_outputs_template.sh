#!/bin/bash --login

#PBS -l select=serial=true:ncpus=1
#PBS -l walltime=12:00:00
#PBS -A n02-weat
#PBS -N promote-data-%%SCENNUM%%

#
#  script for gathering the outputs from multiple WRF runs (for PROMOTE)
#
#  this should not be run alone, but is called from STEP4_run_WRF_gather_outputs.sh
#

cd $PBS_O_WORKDIR

# load miniconda & activate NCL virtual environment
. ~/miniconda3.sh
conda activate ncl-6.6.2


#### Constants
SCRIPT_DIR=/work/n02/n02/reyes/PROMOTE/running_scripts_2domains/Data_Extraction_Scripts/

WORK_ROOT=/work/n02/n02/reyes/PROMOTE/

OUTPUT_ROOT=/work/n02/n02/reyes/PROMOTE/PROMOTE_data_outputs/

export WRF_NCL_ROOT=$SCRIPT_DIR

SCENARIO=%%SCEN%%

YEAR=%%YEAR%%
MONTH=%%MONTH%%
DAY=%%DAY%%

# settings to be passed to the ncl script
YEAR_STRING="year=(/\"${YEAR}\"/)"
MONTH_STRING="month=(/\"${MONTH}\"/)"
DAY_STRING="day=(/\"${DAY}\"/)"
HOUR_STRING='hour=(/"*"/)'

INDIR_STRING="input_root_directory=\"${WORK_ROOT}\""
OUTDIR_STRING="output_root_directory=\"${OUTPUT_ROOT}\""

DOMAINS=( 'd01' )
DOM_NUM=${#DOMAINS[@]}

SCEN_STRING="scenario=\"${SCENARIO}\""



#### Main



### create the storage directories (running them as background jobs)
for dom in ${DOMAINS[@]}; do
	OUTFILE_STRING="outfile_name=\"wrfdata_${dom}_${SCENARIO}_${YEAR}_${MONTH}_${DAY}.nc\""
	DOMAIN_STRING="domain=\"${dom}\""
	
	ncl $YEAR_STRING $MONTH_STRING \
		$DAY_STRING $HOUR_STRING \
		$INDIR_STRING $OUTDIR_STRING \
		$SCEN_STRING $DOMAIN_STRING $OUTFILE_STRING \
		${SCRIPT_DIR}CREATE_data_file.ncl > log_create_${dom}_${SCENARIO}_${YEAR}_${MONTH}_${DAY}.txt &
done

wait

# test to make sure we were successful
# exit if we were not
SUCCESS=0
for dom in ${DOMAINS[@]}; do
	LOG_TAIL=$( tail -1 log_create_${dom}_${SCENARIO}_${YEAR}_${MONTH}_${DAY}.txt 2>&1 )
	if [[ $LOG_TAIL == *"SUCCESS"* ]]; then
		let SUCCESS+=1
	fi
done
if [[ SUCCESS -ne $DOM_NUM ]]; then
	echo "failed to create data files, check logs!"
	exit
else
	echo "created data files, deleting log files"
	for dom in ${DOMAINS[@]}; do
		rm log_create_${dom}_${SCENARIO}_${YEAR}_${MONTH}_${DAY}.txt
	done
fi


### populate the storage directories (running them as background jobs)
for dom in ${DOMAINS[@]}; do
	OUTFILE_STRING="outfile_name=\"wrfdata_${dom}_${SCENARIO}_${YEAR}_${MONTH}_${DAY}.nc\""
	DOMAIN_STRING="domain=\"${dom}\""
	
	ncl $YEAR_STRING $MONTH_STRING \
		$DAY_STRING $HOUR_STRING \
		$INDIR_STRING $OUTDIR_STRING \
		$SCEN_STRING $DOMAIN_STRING $OUTFILE_STRING \
		${SCRIPT_DIR}EXTRACT_SAVE_2D_data.ncl > log_extract_${dom}_${SCENARIO}_${YEAR}_${MONTH}_${DAY}.txt &
done

wait

# test to make sure we were successful
# exit if we were not
SUCCESS=0
for dom in ${DOMAINS[@]}; do
	LOG_TAIL=$( tail -1 log_extract_${dom}_${SCENARIO}_${YEAR}_${MONTH}_${DAY}.txt 2>&1 )
	if [[ $LOG_TAIL == *"SUCCESS"* ]]; then
		let SUCCESS+=1
	fi
done
if [[ SUCCESS -ne $DOM_NUM ]]; then
	echo "failed to extract data, check logs!"
	exit
else
	echo "extracted data, deleting log files"
	for dom in ${DOMAINS[@]}; do
		rm log_extract_${dom}_${SCENARIO}_${YEAR}_${MONTH}_${DAY}.txt
	done
fi

# now delete the old data files!!!!!
cd ${WORK_ROOT}$SCENARIO
	echo "removing files:"
	ls wrfout_*_${YEAR}-${MONTH}-${DAY}_*
	rm wrfout_*_${YEAR}-${MONTH}-${DAY}_*
cd -


