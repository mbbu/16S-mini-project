# #! usr/bin/env/bash

# #Do FastQc
# fastqc *.fastq
# mkdir fastqc_results
# mv *.zip fastqc_results/ && mv *.html fastqc_results/
# cd fastqc_results/
# for zip in *.zip; do unzip $zip; done
# cat */summary.txt >> fastqc_summary.txt
# mv fastqc_summary.txt ../
# cd ..
# #Do Trimmomatic for trimming
# for i in `ls -1 *R1*.fastq | sed 's/\_R1.fastq//'`
# do
# trimmomatic PE -phred33 $i\_R1.fastq $i\_R2.fastq $i\_R1_paired.fastq $i\_R1_unpaired.fastq $i\_R2_paired.fastq $i\_R2_unpaired.fastq LEADING:3  TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

# mkdir trimmomatic_results
# mv *paired* trimmomatic_results/
# cd trimmomatic_results/

# #Do quality check for trimmomatic results
# fastqc *_paired.fastq
# mkdir trimmomatic_fastqc_results
# mv *.zip trimmomatic_fastqc_results && mv *.html trimmomatic_fastqc_results
# cd trimmomatic_fastqc_results
# for zip in *.zip; do unzip $zip; done
# cat */summary.txt >> trimmomatic_fastqc_summary.txt
# mv trimmomatic_fastqc_summary.txt ../../
# cd ..

# for file in *R1_paired.fastq 
# do 
# pear -f ${file%%_*}_R1_paired.fastq -r ${file%%_*}_R2_paired.fastq -o pairedouputs;
# done



# # for file in *R1_paired.fastq; do echo "${r%%_*}_R1_paired.fastq ${r%%_*}_R2_paired.fastq"; done
