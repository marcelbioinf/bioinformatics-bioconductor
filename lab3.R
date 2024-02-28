library(ggplot2)
library(dplyr)
library(grid)
library(gridExtra)


######ZAD1######
data <- read.table("C:\\Users\\marce\\hakowanie\\programming_R\\bioconductor\\lab3\\Zbiorczo_final.txt", header = TRUE, sep = "\t")
head(data)
data = (data[1:60, 1:10])
head(data)

data$data = as.factor(data$data)

ggplot(data, aes(x= NG50, y=mis_total,label=data, color=data, shape=method))+ geom_point(size=2) +
scale_shape_manual(values = c(0, 15, 1, 16, 3, 4, 17, 6, 5, 8))+
theme_minimal() + scale_x_log10(labels = scales::trans_format("log10",scales::math_format(10^.x))) +
scale_y_log10(labels = scales::trans_format("log10",scales::math_format(10^.x)))

data[data == 0] <- 1

ggplot(data, aes(x= NG50, y=mis_total,label=data, color=data, shape=method))+ geom_point(size=3) +
scale_shape_manual(values = c(0, 15, 1, 16, 3, 4, 17, 6, 5, 8))+
theme_minimal() + scale_x_log10(labels = scales::trans_format("log10",scales::math_format(10^.x))) +
scale_y_log10(labels = scales::trans_format("log10",scales::math_format(10^.x))) +
theme(legend.position = "right", legend.text = element_text(size = 10))+
labs(x='NG50',shape='Algorithm', y="Total misassembly length", color = "Datasets" )+
labs(title = "Wynik dzia³ania asemblerów")+
theme(axis.text = element_text(size = 9), plot.title = element_text(size = 13))

set.seed(5)
data <- data %>% mutate(NG50_scuff = NG50 + as.integer(runif(60, min = 0, max = as.integer(NG50/2))))   #(data$NG50, na.rm = TRUE)
data <- data %>% mutate(mis_total_scuff = mis_total + as.integer(runif(60, min = 0, max = as.integer(mis_total/2))))
head(data)

p1 <- ggplot(data, aes(x= NG50, y=mis_total,label=data, color=data, shape=method))+ geom_point(size=3) +
  scale_shape_manual(values = c(0, 15, 1, 16, 3, 4, 17, 6, 5, 8))+
  theme_minimal() + scale_x_log10(labels = scales::trans_format("log10",scales::math_format(10^.x))) +
  scale_y_log10(labels = scales::trans_format("log10",scales::math_format(10^.x))) +
  theme(legend.position = "right", legend.text = element_text(size = 10))+
  labs(x='NG50',shape='Algorithm', y="Total misassembly length", color = "Datasets" )+
  labs(title = "Contigs")+
  theme(axis.text = element_text(size = 9), plot.title = element_text(size = 13))+
  theme(legend.position="none")

p2 <- ggplot(data, aes(x= NG50_scuff, y=mis_total_scuff,label=data, color=data, shape=method))+ geom_point(size=3) +
  scale_shape_manual(values = c(0, 15, 1, 16, 3, 4, 17, 6, 5, 8))+
  theme_minimal() + scale_x_log10(labels = scales::trans_format("log10",scales::math_format(10^.x))) +
  scale_y_log10(labels = scales::trans_format("log10",scales::math_format(10^.x))) +
  theme(legend.position = "right", legend.text = element_text(size = 10))+
  labs(x='NG50',shape='Algorithm', y="Total misassembly length", color = "Datasets" )+
  labs(title = "Scaffolds")+
  theme(axis.text = element_text(size = 9), plot.title = element_text(size = 13))


grid.arrange(p1, p2, widths = c(2, 2.7))
combined <- grid.arrange(p1, p2, widths = c(2, 2.7))
ggsave("combined.pdf", plot = combined, width = 11, height = 7, units = "in", dpi = 300)


###########ZAD2#########
install.packages("remotes")
remotes::install_github("datarootsio/artyfarty")
library("artyfarty")

data_2 <- read.table("C:\\Users\\marce\\hakowanie\\programming_R\\bioconductor\\lab3\\busco_res.txt", header = FALSE, sep = "\t")
colnames(data_2) <- c("Algorithm", "Reconstructed", 'Partialy')
data_2_cpy <- data_2
data_2 <- subset(data_2, select = -3)
data_2['Percentage'] = 'Fully reconstructed'
data_2_cpy <- subset(data_2_cpy, select = -2)
data_2_cpy$Partialy <- -(data_2_cpy$Partialy)
data_2_cpy['Percentage'] = 'Partialy reconstructed'

data_2
data_2_cpy
names(data_2)[names(data_2) == "Reconstructed"] <- "num_busco"
names(data_2_cpy)[names(data_2_cpy) == "Partialy"] <- "num_busco"
data_2_combined <- rbind(data_2, data_2_cpy)
data_2_combined['organism'] = 'A.thaliana'
data_2_combined

ggplot(data_2_combined, aes(x=num_busco, y=Algorithm, fill=Percentage))+
geom_bar(stat="identity",position="identity")+
xlab("Number of genes")+ylab("Alignments")+
scale_fill_manual(name="BUSCO genes",values = c("darkseagreen3", "darkslateblue"))+
ggtitle("Number of genes assembled using different algorithms")+
geom_hline(yintercept=0)+
theme_bw() +
theme(legend.position = "bottom")+
scale_x_continuous(limits = c(-2000,10000), breaks = seq(-1000, 9000, by = 1000))

data_2_homo <- data_2_combined
data_2_homo['organism'] = 'Human'
data_2_homo[data_2_homo$num_busco>0, 'num_busco'] = data_2_homo[data_2_homo$num_busco>0, 'num_busco'] * 1.5
data_2_homo[data_2_homo$num_busco<0, 'num_busco'] = data_2_homo[data_2_homo$num_busco<0, 'num_busco'] * 2.1
data_2_homo

data_2_carharias <- data_2_combined
data_2_carharias['organism'] = 'C. carharias'
data_2_carharias[data_2_carharias$num_busco>0, 'num_busco'] = data_2_carharias[data_2_carharias$num_busco>0, 'num_busco'] * 1.2
data_2_carharias[data_2_carharias$num_busco<0, 'num_busco'] = data_2_carharias[data_2_carharias$num_busco<0, 'num_busco'] * 1.2
data_2_carharias


p1 <- ggplot(data_2_combined, aes(x=num_busco, y=Algorithm, fill=Percentage))+
  geom_bar(stat="identity",position="identity")+
  xlab("Number of genes")+ylab("Alignments")+
  scale_fill_manual(name="BUSCO genes",values = c("darkseagreen3", "darkslateblue"))+
  ggtitle("Number of genes assembled using different algorithms")+
  geom_hline(yintercept=0)+
  theme_bw() +
  theme(legend.position = "bottom")+
  scale_x_continuous(limits = c(-2000,10000), breaks = seq(-1000, 9000, by = 1000))+
  theme(legend.position="none")+
  labs(subtitle = "A.thaliana")

p2 <- ggplot(data_2_homo, aes(x=num_busco, y=Algorithm, fill=Percentage))+
  geom_bar(stat="identity",position="identity")+
  xlab("Number of genes")+ylab("Alignments")+
  scale_fill_manual(name="BUSCO genes",values = c("darkseagreen3", "darkslateblue"))+
  geom_hline(yintercept=0)+
  theme_bw() +
  theme(legend.position = "bottom")+
  scale_x_continuous(limits = c(-2500,14000), breaks = seq(-2000, 12000, by = 2000))+
  theme(legend.position="none")+
  labs(subtitle = "Human")

p3 <- ggplot(data_2_carharias, aes(x=num_busco, y=Algorithm, fill=Percentage))+
  geom_bar(stat="identity",position="identity")+
  xlab("Number of genes")+ylab("Alignments")+
  scale_fill_manual(name="BUSCO genes",values = c("darkseagreen3", "darkslateblue"))+
  geom_hline(yintercept=0)+
  theme_bw() +
  theme(legend.position = "bottom")+
  scale_x_continuous(limits = c(-2500,14000), breaks = seq(-2000, 14000, by = 2000))+
  labs(subtitle = "C.carharis")


grid.arrange(p1, p2, p3, heights = c(2.1, 2, 2.4))



data_2_2 <- rbind(data_2_combined, data_2_homo)
data_2_final <- rbind(data_2_2, data_2_carharias)
data_2_final

ggplot(data_2_final, aes(x=num_busco, y=Algorithm, fill=Percentage))+
  geom_bar(stat="identity",position="identity")+
  facet_wrap(~organism)+xlab("Number of genes")+ylab("Alignments")+
  scale_fill_manual(name="BUSCO genes",values = c("darkseagreen3", "darkslateblue"))+
  geom_hline(yintercept=0)+
  scale_x_continuous(limits = c(-2500,14000), breaks = seq(-2000, 14000, by = 4000))+
  theme_scientific()+
  theme(strip.text.x = element_text(face = "bold"))




####ZAD3######
install.packages("devtools")
library(devtools)
devtools::install_github("timelyportfolio/parcoords")
library(parcoords)
library(remotes)
library(remotes)
install_url("https://cran.r-project.org/src/contrib/Archive/package_name/package_name_version.tar.gz")




