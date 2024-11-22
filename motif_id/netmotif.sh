#!/bin/bash
#SBATCH --job-name=quatexelero
#SBATCH --output=slurm-quatexelero.out
#
#SBATCH --mem-per-cpu=8G
#
#SBATCH --cpus-per-task=2
#SBATCH --array=3-5


srun ${QUATEXELERO_DIR}/QuateXelero -i ${NETWORKS_DIR}/networks/kb_alltf_net.txt -s ${SLURM_ARRAY_TASK_ID} -o ${RESULTS_DIR}/motsize_${SLURM_ARRAY_TASK_ID} -r 1000
