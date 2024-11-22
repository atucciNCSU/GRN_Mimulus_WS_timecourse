#!/bin/bash
#SBATCH --job-name=cufflinks-quantify
#SBATCH --output=slurm-quant.out
#
#SBATCH --mem-per-cpu=10G
#SBATCH --exclude=node[60-62]
#
#SBATCH --cpus-per-task=8



cuffquant -v -u \
	--library-type fr-firststrand \
	-p 8 \
	-o ${DATA_DIR}/quant_out \
	-b ${GENOME_DIR}/MguttatusTOL_551_v5.0.fa \
       	${DATA_DIR}/merged_out/merged.gtf \
	${DATA_DIR}/sams/0d_S1Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/0d_S10Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/0d_S15Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/0d_S17Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/0d_S19Aligned.sortedByCoord.out.sam \
	${DATA_DIR}/sams/2d_S11Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/2d_S16Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/2d_S18Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/2d_S20Aligned.sortedByCoord.out.sam \
	${DATA_DIR}/sams/4d_S4Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/4d_S7Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/4d_S12Aligned.sortedByCoord.out.sam \
	${DATA_DIR}/sams/6d_S2Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/6d_S5Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/6d_S8Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/6d_S13Aligned.sortedByCoord.out.sam \
	${DATA_DIR}/sams/7d_S21Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/7d_S22Aligned.sortedByCoord.out.sam \
	${DATA_DIR}/sams/8d_S3Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/8d_S6Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/8d_S9Aligned.sortedByCoord.out.sam,${DATA_DIR}/sams/8d_S14Aligned.sortedByCoord.out.sam
