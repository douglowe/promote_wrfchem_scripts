#  script for setting up the time dependent inputs, and start / end times for the given scenario and leg.
#
#  this should be run: STEP3_timeperiod_setup.sh [global settings file] [directory_name] [timeperiod setup file]
#
#

if [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ] ; then
	echo "This script sets up the time period specific inputs for PROMOTE."
    echo "usage: STEP3_timeperiod_setup.sh [global settings file] [running directory name] [timeperiod setup file]"
    exit
fi


#### Constants

source $1

# root directory for where we are storing all the data, executables, and inputs
#DATA_ROOT=/work/n02/n02/lowe/PROMOTE/

#SCEN_DIR=${DATA_ROOT}scenario_configurations/
#EMISS_DIR=${DATA_ROOT}input_files/anthro_emissions/IITM_CRI_HTAP/

#DOMAINS=( '01' '02' '03' '04' )


# root directory for where we create the working directories
#WORK_ROOT=/work/n02/n02/lowe/PROMOTE/


#### Functions



#### Main



# load the scenario setup file (which contains the variables used below)
source "$SCEN_DATE_DIR$3"

# enter running directory
#cd ${WORK_ROOT}$1
cd $2

# link to the anthropogenic emissions files for the month of interest 
#      (we don't force the user to use
#      the same year/month as the starting year/month because: (a) requirements might change; 
#      (b) our naming format requires MM, whereas the namelist doesn't require a leading
#      zero for a single digit month - for clarity we will make the distinction here, to
#      avoid possible user errors later).
echo "NOTE: any error message about missing wrfchemi_* files here can be safely ignored"
rm wrfchemi_*

for dom in ${DOMAINS[@]}; do

		e00name='wrfchemi_00z_d'$dom
		e12name='wrfchemi_12z_d'$dom

		ln -s ${EMISS_DIR}${e00name}_${EMISS_YEAR}_${EMISS_MONTH} ${e00name}
		ln -s ${EMISS_DIR}${e12name}_${EMISS_YEAR}_${EMISS_MONTH} ${e12name}

done




# copy namelist template, replacing the control strings for the time options as we do this
sed -e "s|%%ST_YEAR%%|${ST_YEAR}|g" \
	-e "s|%%ST_MONTH%%|${ST_MONTH}|g" \
	-e "s|%%ST_DAY%%|${ST_DAY}|g" \
	-e "s|%%END_YEAR%%|${END_YEAR}|g" \
	-e "s|%%END_MONTH%%|${END_MONTH}|g" \
	-e "s|%%END_DAY%%|${END_DAY}|g" \
	-e "s|%%RESTART%%|${RESTART}|g" \
	namelist.input.chem_template > namelist.input

