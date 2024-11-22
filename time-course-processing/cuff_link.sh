#!/bin/bash
#SBATCH --job-name=cufflinks-readcount
#SBATCH --output=slurm-cuff.out
#
#SBATCH --mem-per-cpu=10G
#SBATCH --exclude=node[17-20]
#
#SBATCH --cpus-per-task=8
#SBATCH --array=0-21


BAM_FILES=(${DATA_DIR}/bams/*)
OUT_DIRS=(${DATA_DIR}/link_out/*)

srun cufflinks -v -u --library-type fr-firststrand --max-bundle-frags 1000000000 --max-bundle-length 10000000 -p 8 -o ${OUT_DIRS[$SLURM_ARRAY_TASK_ID]} -G ${GENOME_DIR}/MguttatusTOL_551_v5.0.gtf -b ${GENOME_DIR}/MguttatusTOL_551_v5.0.fa ${BAM_FILES[$SLURM_ARRAY_TASK_ID]}

