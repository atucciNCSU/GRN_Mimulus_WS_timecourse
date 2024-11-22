#!/bin/bash
#SBATCH --job-name=picard-diagnostics
#SBATCH --output=slurm-picard.out
#
#SBATCH --mem-per-cpu=5G
#SBATCH --exclude=node[18-20]
#
#SBATCH --cpus-per-task=8
#SBATCH --array=0-21

module purge
module add java/openjdk-8
module add picard

BAM_FILES=(${DATA_DIR}/bams/*)

srun java -jar $PICARD_JAR CollectAlignmentSummaryMetrics R=${GENOME_DIR}/MguttatusTOL_551_v5.0.fa I=${BAM_FILES[$SLURM_ARRAY_TASK_ID]} O=${BAM_FILES[$SLURM_ARRAY_TASK_ID]}.METRICS.txt

mv ${DATA_DIR}/bams/*.METRICS.txt ${DATA_DIR}/picard_metrics/
