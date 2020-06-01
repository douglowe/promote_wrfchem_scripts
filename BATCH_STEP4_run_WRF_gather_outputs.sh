#!/bin/bash --login

#PBS -l select=4
#PBS -l walltime=48:00:00
#PBS -A n02-weat
#PBS -N promote-batch

#
#  script for running WRF, and gathering the outputs that we require
#
#  this should be run: qsub STEP4_run_WRF_gather_outputs.sh
#
#  
#

cd $PBS_O_WORKDIR


#### Constants

WORK_ROOT=/work/n02/n02/lowe/PROMOTE/

SCENARIOS=( 'run_WRF_test_june_2domains' )
SCEN_NUM=${#SCENARIOS[@]}
SCEN_STRING=${SCENARIOS[@]}    # needed to convert to a single plain string for the sed command later

JOB_CORES='81'
NODE_CORES='21'

FINISHED=0


#### Functions

determine_next_date () {
	next_year=$( date -d "$curr_year$curr_month$curr_day + 1 day" +%Y )
	next_month=$( date -d "$curr_year$curr_month$curr_day + 1 day" +%m )
	next_day=$( date -d "$curr_year$curr_month$curr_day + 1 day" +%d )
}


increment_dates () {
	curr_year=$next_year
	curr_month=$next_month
	curr_day=$next_day
	determine_next_date
}



#### Main


# start all model runs (running them as background jobs)
for scen in ${SCENARIOS[@]}; do
	cd ${WORK_ROOT}$scen
	aprun -n $JOB_CORES -N $NODE_CORES ./wrf.exe 2>&1 | tee WRF.log &
	cd -
done

# get the start dates for 1st run (we assume all runs are for the same period!!!!)
cd ${WORK_ROOT}${SCENARIOS[0]}
	curr_year=$( grep start_year namelist.input | sed -n "s/^.*=\s*\([0-9]*\).*$/\1/p" )
	curr_month=$( grep start_month namelist.input | sed -n "s/^.*=\s*\([0-9]*\).*$/\1/p" )
	curr_day=$( grep start_day namelist.input | sed -n "s/^.*=\s*\([0-9]*\).*$/\1/p" )
cd -
determine_next_date

echo "starting year, month, day are: "$curr_year" "$curr_month" "$curr_day
echo "next year, month, day are: "$next_year" "$next_month" "$next_day


while [[ $FINISHED -ne $SCEN_NUM ]]; do
	# wait for some model progress
		
	sleep 1800

	FINISHED=0
	NEXT_OUTPUT=0
	
	
	
	# tally up finished & next output counts
	for scen in ${SCENARIOS[@]}; do
		cd ${WORK_ROOT}$scen
		
		RSL_TAIL=$( tail -1 rsl.error.0000 2>&1 )
		# check for successful completion
		if [[ $RSL_TAIL == *"SUCCESS"* ]]; then
			let FINISHED+=1
		fi
		
		# list wrfout files that have been written, select last one, and record the day
		model_day=$( grep "Writing wrfout" rsl.error.0000 | tail -1 | sed -n "s/^.*-\([0-9]*\)_.*$/\1/p" )
		
		# check to see if this is the next day
		if [[ $next_day == $model_day ]]; then
			let NEXT_OUTPUT+=1
		fi
		
		cd -
	done


	# submit the next processing job and increment dates, if needed
	if [[ $NEXT_OUTPUT -eq $SCEN_NUM ]]; then
		# setup submission script
		sed -e "s|%%CPUS%%|$SCEN_NUM|g" \
			-e "s|%%YEAR%%|${curr_year}|g" \
			-e "s|%%MONTH%%|${curr_month}|g" \
			-e "s|%%DAY%%|${curr_day}|g" \
			-e "s|%%SCEN_LIST%%|$SCEN_STRING|g" \
			STEP4a_gather_outputs_template.sh > STEP4a_gather_outputs_${curr_year}_${curr_month}_${curr_day}.sh

		# submit it
#		qsub STEP4a_gather_outputs_${curr_year}_${curr_month}_${curr_day}.sh
		
		# increment the dates that we are looking for next
		increment_dates
		
		echo "submitted output processing scripts"
		echo "next year, month, day are: "$next_year" "$next_month" "$next_day
	fi
done

echo "successfully(?) finished running WRF"

# make sure that our script waits at the end, for all sub-processes to finish
wait

