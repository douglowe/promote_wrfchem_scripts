#!/bin/bash

#
#  script for creating running directories for PROMOTE
#
#  this should be run: STEP1_create_run_dir.sh [global_settings_file] [directory_name]
#
#

## read in run information

if [ "$1" = "" ] || [ "$2" = "" ] ; then
	echo "This script sets up running directories for PROMOTE."
    echo "usage: STEP1_create_run_dir.sh [global settings file] [new directory name]"
    exit
fi




#### Constants - these should be read from the global settings file

source $1

# root directory for where we are storing all the data, executables, and inputs
# DATA_ROOT=/work/n02/n02/lowe/PROMOTE/
#
#
# TEMPLATE=${DATA_ROOT}run_directory_template/
#
# EXEC_DIR="${DATA_ROOT}exec/test_v3.8.1_code_new_CRI_VBS_controls_Mar2019/"
# BDY_DIR=${DATA_ROOT}input_files/body_files_for_april_may_2018/cri_mosaic_vbs_8bin_with_cesm_waccm_boundary_fresh_VBS_correct_Oxygen/
# BIO_DIR=${DATA_ROOT}input_files/biogenic_emissions/April_19_2018/

# ARVAR_DIR=${DATA_ROOT}namelists/
# ARVAR_FILE=add_remove_var.vbs_spc.operational.txt


# root directory for where we create the working directories
#WORK_ROOT=/work/n02/n02/lowe/PROMOTE/


#### Functions



#### Main



# copy template running directory
#cp -a ${TEMPLATE} ${WORK_ROOT}$1
cp -a ${TEMPLATE} $2

# enter running directory
#cd ${WORK_ROOT}$1
cd $2

# link to executables
ln -sf ${EXEC_DIR}*.exe .

# link to add_remove_var
ln -sf ${ARVAR_DIR}${ARVAR_FILE} add_remove_var.txt

# link to the lowinput and fdda inputs (as these are generic to all scenarios)
ln -sf ${BDY_DIR}wrflowinp_d0* .
ln -sf ${BDY_DIR}wrffdda_d0* .

# link to the biogenic emission files (as these should be for the standard start date)
ln -sf ${BIO_DIR}wrfbiochemi_d0* .

# link to the biomass burning emission files (for the whole simulation period)
ln -sf ${BBURN_DIR}wrffirechemi_d0* .
