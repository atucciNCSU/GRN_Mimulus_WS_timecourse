require(igraph)
require(tidyverse)
require(rrvgo)
require(gt)

#Ran as script using Rscript ${R_SCRIPT_DIR}/graph_code.R ${PATH_TO_WORKING_DIR} ${PATH_TO_NETWORK_FILE} ${PATH_TO_ANNOT_DIR}
#Command line arguments include 1) working directory containing QuateXelero results 2) path to network file (space-separated text file 1st column source, 2nd column target) 3) annotation directory containing MguttatusTOL_551_v5.0.annotation_info.txt downloaded from JGI 
clargs <- commandArgs(trailingOnly = TRUE)

workdir <- clargs[1]
network_file <- clargs[2]
annotdir <- clargs[3]

bionet <- read.table(network_file, header = FALSE, sep = " ")
colnames(bionet) <- c("source","target")
biograph <- bionet %>% dplyr::select(source,target) %>% igraph::graph_from_data_frame(.)


motsize <- as.numeric(clargs[1])

adjmats_file <- file(paste(workdir,"/adjMatrix.txt", sep = ''), 'r')
adjmats <- readLines(adjmats_file)
close(adjmats_file)

score_file <- read.csv(paste(workdir,"/ZScore.csv", sep = '')) %>% dplyr::filter(MEAN_IN_RANDOM >0, ZSCORE > 3) %>% dplyr::arrange(desc(ZSCORE))

motif_example_file <- paste(workdir,"/motif_examples.txt", sep = '')

mgut_annot <- read_tsv(paste0(annotdir,"MguttatusTOL_551_v5.0.annotation_info.txt"))

GO_avail <- data.frame(locusName = character(), GO = character(), motif_id = character())
for(motif_ID in score_file$ID){
  id_string <- paste("ID:", as.character(motif_ID))
  loc_matid <- which(adjmats == id_string)
  write(id_string, file = motif_example_file, append = TRUE)
  
  cur_adjmat <- t(sapply(adjmats[seq(loc_matid-motsize, loc_matid-1)], function(x){unlist(as.numeric(str_split(x,"")[[1]]))}))
  colnames(cur_adjmat) = row.names(cur_adjmat) = LETTERS[1:motsize]
  
  adjgraph <- igraph::graph_from_adjacency_matrix(cur_adjmat)
  motexamps <- igraph::subgraph_isomorphisms(adjgraph, biograph, method = "lad", induced = T)
  
  sapply(motexamps,function(x){write(paste(names(x),collapse = ","), motif_example_file, append = TRUE)})
  write("", motif_example_file,append = TRUE)
  motadjacent <- bionet %>% dplyr::filter((source %in% names(unlist(motexamps))) | (target %in% names(unlist(motexamps)))) %>% 
    dplyr::select(source, target)
  motadjacent <- c(motadjacent$source, motadjacent$target)
  goterms <- mgut_annot %>% dplyr::filter(locusName %in% motadjacent, !is.na(GO)) %>% dplyr::select(locusName,GO)
  goterms$motif_id <- rep(id_string, dim(goterms)[1])
  GO_avail <- dplyr::bind_rows(GO_avail,goterms)
}
write.csv(GO_avail, file = paste(workdir,"/available_GO_terms.csv", sep = ''))
