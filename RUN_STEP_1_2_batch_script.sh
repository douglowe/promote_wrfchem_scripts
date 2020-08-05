#!/bin/bash

#
#  Script for running Steps 1 & 2 of the running directory setup
#    for a list of scenarios (automating the command line actions).
#

# select global settings file, and load it
GLOBAL_SETTINGS_FILE=/work/n02/n02/lowe/PROMOTE/running_scripts_test_2domains/local_settings.txt

source $GLOBAL_SETTINGS_FILE

SCENARIOS=( 'run_WRF_test_june_2nd_domain' )

### imported from global settings file:
#
# WORK_ROOT=/work/n02/n02/lowe/PROMOTE/
#
# SCRIPT_ROOT=/work/n02/n02/lowe/PROMOTE/running_scripts/

for scen in ${SCENARIOS[@]}; do

	echo "creating run directory, and setting chemical details for scenario: "${scen}

	work_dir=${WORK_ROOT}${scen}

	${SCRIPT_ROOT}STEP1_create_run_dir.sh ${GLOBAL_SETTINGS_FILE} ${work_dir}

	${SCRIPT_ROOT}STEP2_chemistry_setup.sh ${GLOBAL_SETTINGS_FILE} ${work_dir} ${scen}

done

