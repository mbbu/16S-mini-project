#! /usr/bin/env bash
#  create a folder of your raw reads
mkdir sample_data
# folder that has all your fastq files
cd  sample_data
# checking quality using fastq
for file in *.fastqc
    do
    data_file=`basename $file`
    fastqc  *.fastq 
    mv *fastq * /results/
    cd results

    unzip  *.zip && mv *fastqc /qc_folder
# add summary of each file into one txt

done
# trimmomatic using fastq files
for reads in *.fastq
 do
   base=$(basename ${reads}.fastq.)
   trimmomatic PE ${reads} ${base}.fastq\
#    channel output and change the file names
                ${base}_R1_trim.fastq ${base}_1un_trim.fastq \
                ${base}_R2_trim.fastq ${base}_2un_trim.fastq \
                SLIDINGWINDOW:4:20  LEADING:3 TRAILING:3 MINLEN:20
 done


#  work with proper file formats
# Change all file formarts
# select all foward and reverse reads
# peared end stitching using PEAR
for file in *_trim.fastq
do
    pear -f *_R1_trim  -r *_R2_trim -o output_channel
done

# Uchime

for files in *assembled.fastq
do
# download the bacterial data from silva for bacteria data
wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip
unzip silva.bacteria.zip 
cd silva.bacteria
# get the file with bacteria data only.
mv silva.bacteria.fasta ../
cd ..
usearch -uchime2_ref $files.fastq -db silva.bacteria.fasta -uchimeout $files_out.fastq -strand plus -mode sensitive
done
# UPARSE
# Quality filter

for filname in * assembled.fastq
do

# Merge (assemble) paired reads
usearch -fastq_mergepairs $filename -fastqout merged.fastq
# Quality filter
usearch -fastq_filter merged.fastq -fastq_maxee 1.0 -relabel Filt -fastaout filtered.fastq

# Find unique read sequences and abundances
usearch -fastx_uniques filtered.fastq -sizeout -relabel Uniq -fastaout uniques.fastq

# Make 97% OTUs and filter chimeras
usearch -cluster_otus uniques.fastq -otus otus_output.fastq -relabel OTUS

# Denoise
usearch -unoise3 uniques.fastq -zotus zotus.fastq
done






