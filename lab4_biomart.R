library(biomaRt)

listMarts(host="https://plants.ensembl.org")
listMarts()


plantsdb <- useMart(biomart = "plants_mart", host="https://plants.ensembl.org")
listDatasets(plantsdb)
plantdb <- useDataset("athaliana_eg_gene", plantsdb)

mart2 <- useMart(biomart="ensembl", dataset ="hsapiens_gene_ensembl")

listFilters(mart2)
listAttributes(mart=mart2)
searchAttributes(mart = mart2, 'entrez|hgnc') 


##zad1
sond_ids = c('211550_at', '202431_s_at', '206044_s_at')
t1 <- getBM(attributes=c('hgnc_id', 'chromosome_name', 'start_position', 'end_position'), 
            filters='affy_hg_u133_plus_2', values=sond_ids, mart=mart2)
print(t1)


###zad2
sond_ids = c('211550_at', '202431_s_at', '206044_s_at')
t2 <- getBM(attributes=c('ensembl_gene_id','hgnc_id', 'go_id', 'name_1006'), 
            filters='affy_hg_u133_plus_2', values=sond_ids, mart=mart2)
print(t2)


###zad3
go_terms = c("GO:0000902", "GO:0000080", "GO:0000114", "GO:0004714")
chrs = c('9', '7', '20', 'Y')
t3 <- getBM(attributes=c('hgnc_id'),filters=c('chromosome_name', 'go'), values=list(chrs, go_terms), mart=mart2)
print(t3)


#zad4
searchAttributes(mart = mart2, 'mir') 
searchAttributes(mart = mart2, 'biot') 
searchFilters(mart = mart2, 'bio') 
filterType('biotype',mart2) 
filterType('chromosome_name',mart2) 

t4 <- getBM(attributes=c('mirbase_id', 'start_position', 'end_position'),filters=c('chromosome_name', 'biotype'), values=list('13', 'miRNA'), mart=mart2)
print(t4)

write.csv(t4, "zad4.csv")


#zad5
searchAttributes(mart = mart2, 'affy') 
searchAttributes(mart = mart2, 'ensembl') 
searchFilters(mart = mart2) 

t5 <- getBM(attributes=c('ensembl_gene_id', 'affy_hg_u133_plus_2'),
            filters=c('chromosome_name', 'start', 'end'),
            values=list('9', 3400000, 36500000), mart=mart2)
print(t5)


#zad6
library(ggplot2)
library(gridExtra)

searchAttributes(mart = mart2, 'gene') 
t5 <- getBM(attributes=c('ensembl_gene_id', 'transcript_length'), mart=mart2)
print(t5)

#view this to plan the scale
min(t5$transcript_length)
max(t5$transcript_length)
t6 <- t5[order(-t5$transcript_length), ]#reversed to see the longest transcripts

t5_long <- t5[t5$transcript_length > 30000, ]
t5_short <- t5[t5$transcript_length < 30000, ]

p1 <- ggplot(t5, aes(x = transcript_length)) +
  geom_histogram(binwidth = 20, fill = "blue", color = "black") +
  labs(title = "Genes 0-3000 bp long", x = "length (bp)", y = "Frequency") + xlim(40, 3000)

p2 <- ggplot(t5, aes(x = transcript_length)) +
  geom_histogram(binwidth = 40, fill = "green", color = "black") +
  labs(title = "Genes 3000-8000 bp long", x = "length (bp)", y = "Frequency") + xlim(3000, 8000)

p3 <- ggplot(t5, aes(x = transcript_length)) +
  geom_histogram(binwidth = 50, fill = "yellow", color = "black") +
  labs(title = "Genes 8000-14000 bp long", x = "length (bp)", y = "Frequency") + xlim(8000, 14000)

p4 <- ggplot(t5, aes(x = transcript_length)) +
  geom_histogram(binwidth = 50, fill = "red", color = "black") +
  labs(title = "Genes 14000-22000 bp long", x = "length (bp)", y = "Frequency") + xlim(14000, 20000)

p5 <- ggplot(t5, aes(x = transcript_length)) +
  geom_histogram(binwidth = 70, fill = "orange", color = "black") +
  labs(title = "Genes 20000-28000 bp long", x = "length (bp)", y = "Frequency") + xlim(20000, 28000)

p6 <- ggplot(t5, aes(x = transcript_length)) +
  geom_histogram(binwidth = 190, fill = "pink", color = "black") +
  labs(title = "Genes 28000-50000 bp long", x = "length (bp)", y = "Frequency") + xlim(28000, 50000)

p7 <- ggplot(t5, aes(x = transcript_length)) +
  geom_histogram(binwidth = 500, fill = "purple", color = "black") +
  labs(title = "Genes 50000-130000 bp long", x = "length (bp)", y = "Frequency") +
  scale_x_continuous(limits = c(50000, 130000), breaks = seq(50000, 130000, by = 20000), labels = seq(50000, 130000, by = 20000))

p8 <- ggplot(t5, aes(x = transcript_length)) +
  geom_histogram(binwidth = 1000, fill = "seagreen", color = "black") +
  labs(title = "Genes 190000-350000 bp long", x = "length (bp)", y = "Frequency") +
  scale_x_continuous(limits = c(190000, 350000), breaks = seq(190000, 350000, by = 50000), labels = seq(190000, 350000, by = 50000))

multiplot <- grid.arrange(
  p1, p2,
  p3, p4,
  p5, p6,
  p7, p8,
  ncol = 2
)






























