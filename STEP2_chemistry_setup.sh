#  script for setting up the chemical inputs & settings for the given scenario.
#
#  this should be run: STEP2_chemistry_setup.sh [global_settings_file] [directory_name] [scenario_file]
#
#

if [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ] ; then
	echo "This script sets up the chemistry scheme specific inputs for PROMOTE."
    echo "usage: STEP2_chemistry_setup.sh [global settings file] [running directory name] [scenario setup file]"
    exit
fi


#### Constants - these should be read from the global settings file

source $1

# root directory for where we are storing all the data, executables, and inputs
# DATA_ROOT=/work/n02/n02/lowe/PROMOTE/

# SCEN_DIR=${DATA_ROOT}scenario_configurations/

# NAME_DIR=${DATA_ROOT}namelists/CRI_VBS_namelists/new_vbs_controls/templates_with_spectral_nudging/

# BDY_DIR=${DATA_ROOT}input_files/body_files_for_april_may_2018/


#### Functions



#### Main


# load the scenario setup file (which contains the variables used below)
source "$SCEN_DIR$3.txt"

# enter running directory
cd $2

# link to the wrfinput and wrfbdy files (dependent on chemical boundary setup)
#ln -sf ${BDY_DIR}${CHEM_INIT_BOUND}/wrfinput* .
#ln -sf ${BDY_DIR}${CHEM_INIT_BOUND}/wrfbdy_d01 .
ln -sf ${BDY_DIR}wrfinput* .
ln -sf ${BDY_DIR}wrfbdy_d01 .


# copy across namelist, replacing the control strings for the chemical options as we do this
sed -e "s|%%BB_SCALE%%|${BB_VBS_SCALE}|g" \
	-e "s|%%AN_SCALE%%|${AN_VBS_SCALE}|g" \
	-e "s|%%BB_OXIDATE%%|${BB_VBS_OXIDATE}|g" \
	-e "s|%%AN_OXIDATE%%|${AN_VBS_OXIDATE}|g" \
	-e "s|%%BB_AGE%%|${BB_VBS_AGERATE}|g" \
	-e "s|%%AN_AGE%%|${AN_VBS_AGERATE}|g" \
	-e "s|%%BB_FRAC_1%%|${BB_VBS_FRAC_1}|g" \
	-e "s|%%BB_FRAC_2%%|${BB_VBS_FRAC_2}|g" \
	-e "s|%%BB_FRAC_3%%|${BB_VBS_FRAC_3}|g" \
	-e "s|%%BB_FRAC_4%%|${BB_VBS_FRAC_4}|g" \
	-e "s|%%BB_FRAC_5%%|${BB_VBS_FRAC_5}|g" \
	-e "s|%%BB_FRAC_6%%|${BB_VBS_FRAC_6}|g" \
	-e "s|%%BB_FRAC_7%%|${BB_VBS_FRAC_7}|g" \
	-e "s|%%BB_FRAC_8%%|${BB_VBS_FRAC_8}|g" \
	-e "s|%%BB_FRAC_9%%|${BB_VBS_FRAC_9}|g" \
	-e "s|%%AN_FRAC_1%%|${AN_VBS_FRAC_1}|g" \
	-e "s|%%AN_FRAC_2%%|${AN_VBS_FRAC_2}|g" \
	-e "s|%%AN_FRAC_3%%|${AN_VBS_FRAC_3}|g" \
	-e "s|%%AN_FRAC_4%%|${AN_VBS_FRAC_4}|g" \
	-e "s|%%AN_FRAC_5%%|${AN_VBS_FRAC_5}|g" \
	-e "s|%%AN_FRAC_6%%|${AN_VBS_FRAC_6}|g" \
	-e "s|%%AN_FRAC_7%%|${AN_VBS_FRAC_7}|g" \
	-e "s|%%AN_FRAC_8%%|${AN_VBS_FRAC_8}|g" \
	-e "s|%%AN_FRAC_9%%|${AN_VBS_FRAC_9}|g" \
	${NAME_DIR}${NAMEFILE} > namelist.input.chem_template

