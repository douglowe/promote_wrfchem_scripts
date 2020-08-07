#!/bin/bash

#
#  Script for running Step 3 of the running directory setup
#    for a list of scenarios (automating the command line actions).
#

# select global settings file, and load it
GLOBAL_SETTINGS_FILE=/work/n02/n02/reyes/PROMOTE/running_scripts_2domains/local_settings.txt

source $GLOBAL_SETTINGS_FILE

SCENARIOS=('TRAIN001' 'TRAIN002' 'TRAIN003' 'TRAIN004' 'TRAIN005' \
'TRAIN006' 'TRAIN007' 'TRAIN008' 'TRAIN009' 'TRAIN010' \
'TRAIN011' 'TRAIN012' 'TRAIN013' 'TRAIN014' 'TRAIN015' \
'TRAIN016' 'TRAIN017' 'TRAIN018' 'TRAIN019' 'TRAIN020' \
'TRAIN021' 'TRAIN022' 'TRAIN023' 'TRAIN024' 'TRAIN025' \
'TRAIN026' 'TRAIN027' 'TRAIN028' 'TRAIN029' 'TRAIN030' \
'TRAIN031' 'TRAIN032' 'TRAIN033' 'TRAIN034' 'TRAIN035' \
'TRAIN036' 'TRAIN037' 'TRAIN038' 'TRAIN039' 'TRAIN040' \
'TRAIN041' 'TRAIN042' 'TRAIN043' 'TRAIN044' 'TRAIN045' \
'TRAIN046' 'TRAIN047' 'TRAIN048' 'TRAIN049' 'TRAIN050' \
'TRAIN051' 'TRAIN052' 'TRAIN053' 'TRAIN054' 'TRAIN055' \
'TRAIN056' 'TRAIN057' 'TRAIN058' 'TRAIN059' 'TRAIN000' )




#WORK_ROOT=/work/n02/n02/lowe/PROMOTE/

#SCRIPT_ROOT=/work/n02/n02/lowe/PROMOTE/running_scripts/

time_settings="time_prototype_a.txt"

for scen in ${SCENARIOS[@]}; do

	echo "(re)setting time period specific details for scenario: "${scen}

	work_dir=${WORK_ROOT}${scen}

	${SCRIPT_ROOT}STEP3_timeperiod_setup.sh ${GLOBAL_SETTINGS_FILE} ${work_dir} ${time_settings}

done

