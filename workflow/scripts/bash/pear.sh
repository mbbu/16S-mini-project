##!/usr/bin/env bash


# The perform_fastqc function below does the FastQc operation on a sample_data
function perform_fastqc() {
    # Below is a description of the positional arguments
    # $1 >> is the path to the data for the fastq analysis
    # $2 >> is the path to the directory to store the results after analysis
    # $3 >> is the path to the data directory
    # $4 >> is the path to the destination of the summary text

    fastqc $1
    mkdir $2
    mv $3*.zip $3*.html $2
    for zip in $2*.zip
    do
        unzip $zip
    done
    cat $2*/summary.text >> ../../results/$4
}

# the perform_fastqc function below perfoms a quality check on the raw sample data
perform_fastqc "../../../sample_data/*.fastq ../../results/fastqc_results/ ../../../sample_data/ fastqc_summary.txt"

# the prinseq_trimming function below trims the fastq data with prinseq
function prinseq_trimming() {
    for i in `ls -1 ../../../sample_data/*R1*.fastq | sed 's/\_R1.fastq//'`
    do
        prinseq-lite.pl -fastq $\_R1.fastq -fastq2 $i\R2.fastq -out_format 3
    done
    mkdir ../../results/prinseq_results && mv ../../../sample_data/*good* ../../results/prinseq_results
}

prinseq_trimming

# the perform_fastqc function below perfoms a quality check on the prinseq results
perform_fastqc "../../results/prinseq_results/*good*.fastq ../../results/prinseq_results/prinseq_fastqc_results/ ../../results/prinseq_results prinseq_fastqc_summary.txt"

# the merge_prinseq_reads function below merges the prinseq reads with pear and removes chimeras with chimeraslayer
function merge_prinseq_reads() {
    for file in ../../results/prinseq_results/*R1_prinseq*
    do
        pear -f ${file%%_*}_R1_prinseq* -r ${file%%_*}_R2_paired* -o ../../results/prinseq_results/pairedouputs
    done
    chimeraslayer --query_NAST ../../results/prinseq_results/pairedouputs.assembled.fastq
}

merge_prinseq_reads
