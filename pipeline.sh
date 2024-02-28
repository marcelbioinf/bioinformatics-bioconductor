#!/bin/bash

echo "De novo assemblation pipeline"

echo "FastQC analysis"

/home/tools/FastQC/fastqc mapped.1.fastq
/home/tools/FastQC/fastqc mapped.2.fastq

echo "Adapter low-quality ends trimming

java -jar /home/tools/Trimmomatic-0.36/trimmomatic-0.36.jar PE mapped.1.fastq mapped.2.fastq 
trimmed/paired_trimmed_mapped.1.fastq trimmed/unpaired_trimmed_mapped.1.fastq 
trimmed/paired_trimmed_mapped.2.fastq trimmed/unpaired_trimmed_mapped.2.fastq 
ILLUMINACLIP:/home/tools/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:3:30:10 LEADING:3 TRAILING:3

echo "Deleteing spaces from files"

sed -i 's/ //g' trimmed/paired_trimmed_mapped.1.fastq
sed -i 's/ //g' trimmed/paired_trimmed_mapped.2.fastq

echo "Running trinity for de novo genome assemply"

time /home/tools/trinityrnaseq-Trinity-v2.4.0/Trinity --seqType fq --max_memory 50G --left 
trimmed/paired_trimmed_mapped.1.fastq --right trimmed/paired_trimmed_mapped.2.fastq --CPU 6

/home/tools/trinityrnaseq-Trinity-v2.4.0/util/TrinityStats.pl trinity_out_dir/Trinity.fasta > trinityStats_first.log

cat trinityStats_first.log

echo "Indexing reference genome"

/home/tools/STAR-2.5.3a/bin/Linux_x86_64/STAR --runMode genomeGenerate --genomeDir chr22_index 
--genomeFastaFiles ./Homo_sapiens.GRCh38.dna.chromosome.22.fa

echo "Running STAR for mapping reads to reference genome"

/home/tools/STAR-2.5.3a/bin/Linux_x86_64/STAR --genomeDir chr22_index --readFilesIn 
./trimmed/paired_trimmed_mapped.1.fastq ./trimmed/paired_trimmed_mapped.2.fastq --outSAMtype BAM 
SortedByCoordinate

/home/tools/samtools-0.1.19/samtools index Aligned.sortedByCoord.out.bam

echo "Running genome guided trinity for genome assemnly"

time /home/tools/trinityrnaseq-Trinity-v2.4.0/Trinity --genome_guided_bam Aligned.sortedByCoord.out.bam 
--max_memory 50G --CPU 6 --genome_guided_max_intron 10000

/home/tools/trinityrnaseq-Trinity-v2.4.0/util/TrinityStats.pl trinity_out_dir/Trinity-GG.fasta > trinityStats_second.log

cat trinityStats_second.log
