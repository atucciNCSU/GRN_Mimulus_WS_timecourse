require("Rsubread")
require("edgeR")
require("stringr")

clargs <- commandArgs(trailingOnly = T)

bam_directory <- "bams/"
guttatus_gtf <- "tol-star-genome/MguttatusTOL_551_v5.0.gtf"

bam_files <- paste(bam_directory,list.files(bam_directory),sep = "")

sample_type <- unlist(lapply(list.files(bam_directory),function(x){str_split(x,"_")[[1]][1]}))

sample_type[sample_type == "8d"] <- "WS"

group <- factor(sample_type, levels = c("WS","HE"))

file_prefixes <- unlist(lapply(list.files(bam_directory),function(x){str_split(x,"A")[[1]][1]}))

sample_df <- data.frame(file = bam_files, group = group, sample_id = file_prefixes)

featureCount_out <- featureCounts(sample_df$file, 
                    annot.ext = guttatus_gtf, 
                    isGTFAnnotationFile = TRUE, 
                    nthreads = clargs[1], 
                    isPairedEnd = TRUE,
                    countMultiMappingReads = FALSE,
		    verbose = TRUE)

dge_list <- DGEList(featureCount_out$counts, group = sample_df$group)

colnames(dge_list) <- sample_df$sample_id

kept_genes <- filterByExpr(dge_list)
dge_list <- dge_list[kept_genes, , keep.lib.sizes = FALSE]

dge_list <- calcNormFactors(dge_list)

png("count_statistics/mean-difference-plot.png", units = "in", height = 3.5, width = 4,res = 1200)
plotMD(cpm(dge_list,log=T), column = 1)
abline(h = 0, col = "red", lty=2,lwd=2)
dev.off()

png("count_statistics/MDS-plot.png", units = "in", height = 3.5, width = 4,res = 1200)
color_opts <- c("red","blue")
plotMDS(dge_list,col = color_opts[group])
legend("topleft", legend = levels(group), col = color_opts)
dev.off()


design_mat <- model.matrix(~ 0 + sample_df$group)
colnames(design_mat) <- levels(sample_df$group)


dge_list <- estimateDisp(dge_list, design_mat, robust = TRUE)

png("count_statistics/BCV-plot.png", units = "in", height = 3.5, width = 4,res = 1200)
plotBCV(dge_list)
dev.off()

QLfit <- glmQLFit(dge_list, design_mat, robust = TRUE)

png("count_statistics/QLdispersion-plot.png", units = "in", height = 3.5, width = 4,res = 1200)
plotQLDisp(QLfit)
dev.off()


he_ws_contrast <- makeContrasts(HE - WS, levels = design_mat)
qlf <- glmQLFTest(QLfit, contrast = he_ws_contrast)
fdr_adjusted <- p.adjust(qlf$table$PValue, method = "BH")


dea_results <- cbind.data.frame(qlf$table,fdr_adjusted)
dea_results$gene_name <- rownames(dea_results)

write.table(dea_results, file = "dea_results.tsv")
saveRDS(qlf, "quasi-likelihoodTestResults.rds")
