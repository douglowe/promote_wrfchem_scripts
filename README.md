# promote_wrfchem_scripts
BASH scripts for setting up and running WRF-Chem for the PROMOTE project

Scripting requirements:
 * scenario configuration files:
  * chemical settings files
  * time period settings files
 * NCL scripts for post-processing

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
* edit BATCH_STEP4_run_WRF_gather_outputs.sh:
  * set the working directory
  * set the scenario names
* edit STEP4a_gather_outputs_template.sh:
  * set the script, work, and output directories
  * set the domain that you want to process
* submit the batch jobs:
  * qsub BATCH_STEP4_run_WRF_gather_outputs.sh
