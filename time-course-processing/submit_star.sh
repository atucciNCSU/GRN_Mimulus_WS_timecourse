#!/bin/bash
#SBATCH --job-name=star_align_pardalis
#SBATCH --output=slurm_star.out
#
#SBATCH --mem-per-cpu=10G
#
#SBATCH --cpus-per-task=8
#SBATCH --array=0-21%5

module purge
module add STAR
module add samtools
export PATH=${PGM_DIR}:${PATH}

FILE_PREFIXES=(${READ_DIR}/BR*R1_001.fastq.gz)

srun run_star ${FILE_PREFIXES[$SLURM_ARRAY_TASK_ID]}
