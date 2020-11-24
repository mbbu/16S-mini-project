#! usr/bin/env/bash

#fastqc the data

fastqc *.fastq

mkdir fastqc_results
mv *.zip results/ && mv *.html results/
rm -r *.zip
rm -r *.html

#for file in *_fastqc
#do
#cat $file/summary.txt >> fastqc_summary.txt

#done

#cd ..

#trim the reads with trimmomatic

for i in `ls -1 *R1*.fastq | sed 's/\_R1.fastq//'`
do
trimmomatic PE -phred33 $i\_R1.fastq $i\_R2.fastq $i\_R1_paired.fastq $i\_R1_unpaired.fastq $i\_R2_paired.fastq $i\_R2_unpaired.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

done

mkdir trimmomatic_results
mv *paired* trimmomatic_results/
cd trimmomatic_results/

#check to see maximum and minimum read lengths
mkdir -p merge_test
usearch -fastq_mergepairs *_R1_paired.fastq -fastq_merge_maxee 1 -relabel @ -report merge_test/merge_test.log

#merge your reads
mkdir -p usearch_merge
usearch -fastq_mergepairs *_R1_paired.fastq -fastq_minmergelen 75 -fastq_maxmergelen 265 -relabel @ -report usearch_merge/merge.log -fastqout usearch_merge/merged.fastq -tabbedout usearch_merge/detail_pairs.log

# move merge test logfile into usearch

mv merge_test usearch_merge/
mv usearch_merge/ ../
cd ..

#chimera detection
#download the database to be used
wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip
unzip silva.bacteria.zip
cd silva.bacteria
mv silva.bacteria.fasta ../
cd ..

#chimera detection
usearch -uchime2_ref usearch_merge/merged.fastq -db silva.bacteria.fasta -uchimeout chimera_out.fastq -strand plus -mode sensitive
