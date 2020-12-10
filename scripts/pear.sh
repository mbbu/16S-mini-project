#! usr/bin/env/bash
#Do FastQc
fastqc *.fastq
mkdir fastqc_results
mv *.zip fastqc_results/ && mv *.html fastqc_results/
cd fastqc_results/
for zip in *.zip; do unzip $zip; done
cat */summary.txt >> fastqc_summary.txt
mv fastqc_summary.txt ../
cd ..
#Do Trimming with Prinseq
for i in `ls -1 *R1*.fastq | sed 's/\_R1.fastq//'`
do
prinseq-lite.pl -fastq $i\_R1.fastq -fastq2 $i\_R2.fastq -out_format 3
done
mkdir prinseq_results
mv *good* prinseq_results/
cd prinseq_results/
#Do quality check for prinseq results
fastqc *good*
mkdir prinseq_fastqc_results
mv *.zip prinseq_fastqc_results && mv *.html prinseq_fastqc_results
cd prinseq_fastqc_results
for zip in *.zip; do unzip $zip; done
cat */summary.txt >> prinseq_fastqc_summary.txt
mv prinseq_fastqc_summary.txt ../../
cd ..
#Merge the prinseq reads with pear
for file in *R1_prinseq*
do
pear -f ${file%%_*}_R1_prinseq* -r ${file%%_*}_R2_prinseq* -o pairedouputs
done

#Remove Chimeras with chimeraslayer

chimeraslayer --query_NAST pairedouputs.assembled.fastq