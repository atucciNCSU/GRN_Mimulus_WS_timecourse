#!/bin/bash
#SBATCH --job-name=kbtf_motif_finder
#SBATCH --output=slurm-kbtf-motfind.out
#
#SBATCH --mem-per-cpu=2G
#
#SBATCH --cpus-per-task=4
#SBATCH --array=3-5

ml purge
ml add R

srun Rscript ${R_DIR}/graph_code.R $SLURM_ARRAY_TASK_ID
