#1 /usr/bin/env bash
#  create a folder of your raw reads

mkdir sample_data
# folder that has all your fastq files
cd  into folder
# checking quality using fastq
for file in *.fastqc
    do
    data_file=`basename $file`
    fastqc -t 5 ${data_file} -o /path/to/where/you/want/outputs
done

# trimmomatic using fastq files
for reads in *.fastq.
 do
   base=$(basename ${reads}.fastq.)
   trimmomatic PE ${reads} ${base}_2.fastq.gz \
                ${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz \
                ${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz \
                SLIDINGWINDOW:4:20  LEADING:3 TRAILING:3 MINLEN:20  
 done

#  work with proper file formats
# Change all file formarts
# select all foward and reverse reads
# peared end stitching using PEAR

for file in *.trimmed.fasta
do
    pear -f foward_file  -r reverse_file -o ouput_channel.fastq


# Uchime
# download the bacterial data from silva
# get the file ..with bacteria data
for file in * assembled.fastq
do
usearch -uchime2_ref $file.fastq -db {bacteria}.udb -uchimeout Dog1_out.fastq -strand plus -mode sensitive








