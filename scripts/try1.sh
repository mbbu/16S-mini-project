#! /usr/bin/env bash
#  create a folder of your raw reads
# Our assumption is that your data has been downloaded on this folder
# mkdir sample_data
# folder that has all your fastq files
# add all your fastq files here
# cd  sample_data
# 
# checking quality using fastq
# for file in *.fastq
# lopps through all files
    # do
    # checks quality for each file
    # data_file=`basename $file`
    fastqc  *.fastq 
# add summary of each file into one txt

# trimmomatic using fastq files
# for reads in *.fastq
#  do
#    base=$(basename ${reads}.fastq.)

#    base="${filename%*_*.fastq}"
#    trimmomatic PE ${reads} ${base}.fastq\
# #    channel output and change the file names
#                 ${base}_R1_trim.fastq ${base}_1un_trim.fastq \
#                 ${base}_R2_trim.fastq ${base}_2un_trim.fastq \
#                 SLIDINGWINDOW:4:20  LEADING:3 TRAILING:3 MINLEN:20
#  done


for file in *_R1.fastq
do
   base=$(basename ${file} _R1.fastq)
   trimmomatic PE ${file} ${base}_R2.fastq \
                ${base}_R1_trim.fastq ${base}_R1un_trim.fastq\
                ${base}_R2_trim.fastq ${base}_R2un_trim.fastq\
                SLIDINGWINDOW:4:20  LEADING:3 TRAILING:3 MINLEN:20
 done


#  work with proper file formats
# Change all file formats
# select all foward and reverse reads
# peared end stitching using PEAR
for file in *_trim.fastq
do
    pear -f *R1_trim.fastq -r *R2_trim.fastq -o output_channel.fastq
done

# Uchime

for files in *output_channel.fastq
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





qiime tools import --input-path otus.fastq --output-path otus.qza --type 'FeatureData[Sequence]'

# convert otutab.txt to hdf5 formart which is BIOM 

biom convert -i table.txt -o table.from_txt_hdf5.biom --table-type="OTU table" --to-hdf5
# Import the table to qiime as a feature table

  qiime tools import --input-path table.from_txt_hdf5.biom --type 'FeatureTable[Frequency]' --output-path otutable111.qza
#  core -metric diversity that does both alpha and beta
qiime tools import --input-path otus.fastq --output-path otus.qza --type 'FeatureData[Sequence]'

# convert otutab.txt to hdf5 formart which is BIOM 

biom convert -i table.txt -o table.from_txt_hdf5.biom --table-type="OTU table" --to-hdf5
# Import the table to qiime as a feature table

  qiime tools import --input-path table.from_txt_hdf5.biom --type 'FeatureTable[Frequency]' --output-path otutable111.qza
#  core -metric diversity that does both alpha and beta


qiime metadata tabulate --m-input-file practice.dataset1.metadata.tsv --o-visualization tabulated-sample-metadata.qzv