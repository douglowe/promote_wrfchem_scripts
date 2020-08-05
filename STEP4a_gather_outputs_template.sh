#!/bin/bash --login

#PBS -l select=serial=true:ncpus=%%CPUS%%
#PBS -l walltime=12:00:00
#PBS -A n02-weat
#PBS -N promote-data

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
SCRIPT_DIR=/home/n02/n02/lowe/WRFChem-Basic-Plotting/example_scripts/data_extraction_scripts/

WORK_ROOT=/work/n02/n02/lowe/PROMOTE/

OUTPUT_ROOT=/nerc/n02/n02/lowe/PROMOTE_data_files/test_scans/


SCENARIOS=( %%SCEN_LIST%% )
SCEN_NUM=${#SCENARIOS[@]}

YEAR=%%YEAR%%
MONTH=%%MONTH%%
DAY=%%DAY%%

# settings to be passed to the ncl script
YEAR_STRING='year=(/"%%YEAR%%"/)'
MONTH_STRING='month=(/"%%MONTH%%"/)'
DAY_STRING='day=(/"%%DAY%%"/)'
HOUR_STRING='hour=(/"*"/)'

INDIR_STRING="input_root_directory=\"${WORK_ROOT}\""
OUTDIR_STRING="output_root_directory=\"${OUTPUT_ROOT}\""
#SCEN_STRING
DOMAIN_STRING='domain="d01"'





#### Main



### create the storage directories (running them as background jobs)
for scen in ${SCENARIOS[@]}; do
	SCEN_STRING="scenario=\"$scen\""
	OUTFILE_STRING="outfile_name=\"wrfdata_${scen}_${YEAR}_${MONTH}_${DAY}.nc\""
	
	ncl $YEAR_STRING $MONTH_STRING \
		$DAY_STRING $HOUR_STRING \
		$INDIR_STRING $OUTDIR_STRING \
		$SCEN_STRING $DOMAIN_STRING $OUTFILE_STRING \
		${SCRIPT_DIR}CREATE_data_file.ncl > log_create_${scen}_${YEAR}_${MONTH}_${DAY}.txt &
done

wait

# test to make sure we were successful
# exit if we were not
SUCCESS=0
for scen in ${SCENARIOS[@]}; do
	LOG_TAIL=$( tail -1 log_create_${scen}_${YEAR}_${MONTH}_${DAY}.txt 2>&1 )
	if [[ $LOG_TAIL == *"SUCCESS"* ]]; then
		let SUCCESS+=1
	fi
done
if [[ SUCCESS -ne $SCEN_NUM ]]; then
	echo "failed to create data files, check logs!"
	exit
fi


### populate the storage directories (running them as background jobs)
for scen in ${SCENARIOS[@]}; do
	SCEN_STRING="scenario=\"$scen\""
	OUTFILE_STRING="outfile_name=\"wrfdata_${scen}_${YEAR}_${MONTH}_${DAY}.nc\""
	
	ncl $YEAR_STRING $MONTH_STRING \
		$DAY_STRING $HOUR_STRING \
		$INDIR_STRING $OUTDIR_STRING \
		$SCEN_STRING $DOMAIN_STRING $OUTFILE_STRING \
		${SCRIPT_DIR}EXTRACT_SAVE_2D_data.ncl > log_extract_${scen}_${YEAR}_${MONTH}_${DAY}.txt &
done

wait

# test to make sure we were successful
# exit if we were not
SUCCESS=0
for scen in ${SCENARIOS[@]}; do
	LOG_TAIL=$( tail -1 log_extract_${scen}_${YEAR}_${MONTH}_${DAY}.txt 2>&1 )
	if [[ $LOG_TAIL == *"SUCCESS"* ]]; then
		let SUCCESS+=1
	fi
done
if [[ SUCCESS -ne $SCEN_NUM ]]; then
	echo "failed to create extract data, check logs!"
	exit
fi

# now delete the old data files!!!!!
for scen in ${SCENARIOS[@]}; do
	cd ${WORK_ROOT}$scen
		rm wrfout_*_${YEAR}-${MONTH}-${DAY}_*
	cd -
done


