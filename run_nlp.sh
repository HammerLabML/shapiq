#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of arguments!"
    exit -1
fi

# Command line arguments
ITERATION=$1

# Global Argument
GAMENAME="nlp_values"
N_PLAYER="14"
INTERACTION_INDEX="SII"
TOP_ORDER="True"
ORDER="4"
N_RUNS="5"
SINGLETON_RUN="True"

# Constants
MEMORY=1024

# Run Name
NAME="${GAMENAME}_${N_PLAYER}_${INTERACTION_INDEX}_${TOP_ORDER}_${ORDER}_${N_RUNS}_${SINGLETON_RUN}_${ITERATION}"
PROCESS_NAME="${NAME}"

# Paths
EXPERIMENT_ROOT_DIR="/dss/dsshome1/lxc04/ra93yex2/shapiq"
ROOT_DIR="${PWD}"
DATA_DIR="${ROOT_DIR}/results"
LOG_DIR="${DATA_DIR}/logs"

# Create directories
echo "Creating directory ${DATA_DIR}"
mkdir -p "${DATA_DIR}"
echo "Creating directory ${LOG_DIR}"
mkdir -p "${LOG_DIR}"

FILE="run_${NAME}.cmd"
PARAMETERS="${GAMENAME} ${N_PLAYER} ${INTERACTION_INDEX} ${TOP_ORDER} ${ORDER} ${N_RUNS} ${SINGLETON_RUN}"

echo "$FILE"
echo "#!/bin/bash" >> "$FILE"
echo "#SBATCH -J ${PROCESS_NAME}" >> "$FILE"
echo "#SBATCH -D ${DATA_DIR}" >> "$FILE"
echo "#SBATCH -o ${LOG_DIR}/logs.log" >> "$FILE"
echo "#SBATCH -e ${LOG_DIR}/logs.err" >> "$FILE"
echo "#SBATCH --get-user-env" >> "$FILE"
echo "#SBATCH --clusters=serial" >> "$FILE"
echo "#SBATCH --partition=serial_std" >> "$FILE"
echo "#SBATCH --export=NONE" >> "$FILE"
echo "#SBATCH --mail-user=Maximilian.Muschalik@ifi.lmu.de" >> "$FILE"
echo "#SBATCH --mail-type=NONE" >> "$FILE"
echo "#SBATCH --time 23:50:00" >> "$FILE"
echo "#SBATCH --mem=${MEMORY}mb" >> "$FILE"
echo "#SBATCH --cpus-per-task=1" >> "$FILE"
echo "module load slurm_setup" >> "$FILE"
echo "module load python" >> "$FILE"
echo "source ${EXPERIMENT_ROOT_DIR}/venv/bin/activate" >> "$FILE"
echo "python ${ROOT_DIR}/run_look_up.py ${PARAMETERS}" >> "$FILE"
echo "deactivate" >> "$FILE"

# Run SLURM jobs
sbatch "$FILE"
rm "$FILE"
echo "Started experiment with parameters ${PARAMETERS}"