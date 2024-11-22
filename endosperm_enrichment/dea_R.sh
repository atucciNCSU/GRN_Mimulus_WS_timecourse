#!/bin/bash
#SBATCH --job-name=HE_WS_differential_expression
#SBATCH --output=slurm-dea.out
#
#SBATCH --mem-per-cpu=5G
#
#SBATCH --cpus-per-task=8


ml add R

Rscript ${PGM_DIR}/fc_edgeR_WS_HE_DEA.R 8
