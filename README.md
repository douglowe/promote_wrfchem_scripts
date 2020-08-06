# promote_wrfchem_scripts
BASH scripts for setting up and running WRF-Chem for the PROMOTE project

Scripting requirements:
 * scenario configuration files:
  * chemical settings files
  * time period settings files
 * NCL scripts for post-processing (https://github.com/douglowe/WRFChem-Basic-Plotting.git)

Once you've cloned the repository you will need to invoke te git submodule command to load
the required libraries:
```
git submodule init
git submodule update
```


Initial Scenario setup:
* edit local_settings.txt
* edit RUN_STEP_1_2_batch_script.sh
  * set the path to the local_settings.txt file:
  * set the scenario names
* setup running directories (Steps 1 & 2):
  * ./RUN_STEP_1_2_batch_script.sh

Running each time period:
* edit RUN_STEP_3_batch_script.sh
  * set the path to the local_settings.txt file:
  * set the scenario names
  * set the time setting file
* setup the time period information:
  * ./RUN_STEP_3_batch_script.sh
* edit Running\_Scripts/batch\_array\_promote.sh:
  * set the number of array jobs:
   * e.g. -J 1-4 (for 4 jobs)
  * set the walltime
  * set variables:
   * WORK\_ROOT
   * SCENARIOS (matching number of array jobs)
* edit Running\_Scripts/gather\_outputs\_templates.sh:
  * set the script, work, and output directories
* submit the batch jobs:
  * cd Running\_Scripts
  * qsub batch\_array\_promote.sh
