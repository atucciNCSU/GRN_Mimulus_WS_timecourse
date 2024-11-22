#!/bin/bash
#SBATCH --job-name=cufflinks-DE
#SBATCH --output=slurm-diff.out
#
#SBATCH --mem-per-cpu=2G
#
#SBATCH --cpus-per-task=8



cuffdiff -v -T -u \
	--library-type fr-firststrand \
	-L day0,day2,day4,day6,day7,day8 \
	--no-update-check \
	-p 8 \
	-b ${GENOME_DIR}/MguttatusTOL_551_v5.0.fa \
	-o ${DATA_DIR}/diff_out \
       	${DATA_DIR}/merged_out/merged.gtf \
	${DATA_DIR}/bams/0d_S1Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/0d_S10Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/0d_S15Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/0d_S17Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/0d_S19Aligned.sortedByCoord.out.bam \
	${DATA_DIR}/bams/2d_S11Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/2d_S16Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/2d_S18Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/2d_S20Aligned.sortedByCoord.out.bam \
	${DATA_DIR}/bams/4d_S4Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/4d_S7Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/4d_S12Aligned.sortedByCoord.out.bam \
	${DATA_DIR}/bams/6d_S2Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/6d_S5Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/6d_S8Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/6d_S13Aligned.sortedByCoord.out.bam \
	${DATA_DIR}/bams/7d_S21Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/7d_S22Aligned.sortedByCoord.out.bam \
	${DATA_DIR}/bams/8d_S3Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/8d_S6Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/8d_S9Aligned.sortedByCoord.out.bam,${DATA_DIR}/bams/8d_S14Aligned.sortedByCoord.out.bam
