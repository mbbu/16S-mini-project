#!/usr/bin/env bash


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


# the perfom_trimmomatic function below implements trimmomatic trimming
function perfom_trimmomatic() {
    for i in `ls -1 ../../../sample_data/*R1*.fastq | sed 's/\_R1.fastqc//'`
    do
        trimmomatic PE -phred33 $i\_R1.fastq $i\_R2.fastq $i\_R1_paired.fastq $i\_R1_unpaired.fastq $i\_R2_paired.fastq $i\_R2_unpaired.fastq LEADING:3  TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    done
    mkdir ../../results/trimmomatic_results && mv ../../../sample_data/*paired* trimmomatic_results/
}

perfom_trimmomatic

# The perform_fastqc function below performs a quality check for trimmomatic results
perform_fastqc "../../results/trimmomatic_results/*_paired.fastq ../../results/trimmomatic_results/trimmomatic_fastqc_results/ ../../results/trimmomatic_results trimmomatic_fastqc_summary.txt"


# the merge_files function implements merge tests
function merge_files() {
    mkdir -p ../../results/trimmomatic_results/merge_test
    usearch -fastq_mergepairs *_R1_paired.fastq -relabel @ -report ../../results/trimmomatic_results/merge_test/merge_test.log
    # Perform Merge
    mkdir -p ../../results/trimmomatic_results/usearch_merge
    usearch -fastq_mergepairs ../../results/trimmomatic_results/*_R1_paired.fastq -fastq_minmergelen 75 -fastq_maxmergelen \
    265 -relabel @ -report ../../results/trimmomatic_results/usearch_merge/merge.log -fastqout ../../results/trimmomatic_results/usearch_merge/merged.fastq -tabbedout ../../results/trimmomatic_results/usearch_merge/detail_pairs.log
    mv ../../results/trimmomatic_results/merge_test ../../results/trimmomatic_results/usearch_merge
    mv ../../results/trimmomatic_results/usearch_merge ../../results/trimmomatic_results/

    cd ../../../sample_data && wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip
    unzip ../../../sample_data/silva.bacteria.zip
    mv ../../../sample_data/silva.bacteria/silva.bacteria.fasta ../../../sample_data
    cd workflow/scripts/bash
}

merge_files

# the chimera_detection implements the chimera detection and filtration functions
function chimera_detection() {
    usearch -uchime2_ref ../../results/trimmomatic_results/usearch_merge/merged.fastq -db ../../../sample_data/silva.bacteria.fasta -uchimeout ../../results/trimmomatic_results/chimera_out.fastq -strand plus -mode sensitive
    # Orient
    usearch -orient ../../results/trimmomatic_results/usearch_merge -db ../../../sample_data/silva.bacteria.fasta -fastqout ../../results/trimmomatic_results/oriented.fastq -tabbedout ../../results/trimmomatic_results/orient.txt
    # Filter your oriented reads
    usearch -fastq_filter ../../results/trimmomatic_results/oriented.fastq -fastq_maxee 1.0 -fastaout ../../results/trimmomatic_results/filtered.fastq
    #Dereplication
    usearch -fastx_uniques ../../results/trimmomatic_results/filtered.fastq -fastaout ../../results/trimmomatic_results/uniques.fastq -sizeout -relabel Uniq
    #Otu Clustering
    usearch -cluster_otus ../../results/trimmomatic_results/uniques.fastq -otus ../../results/trimmomatic_results/otus.fastq -uparseout ../../results/trimmomatic_results/uparse.txt -relabel Otu
    #Denoise -Remove clutters
    usearch -unoise3 ../../results/trimmomatic_results/uniques.fastq -zotus ../../results/trimmomatic_results/zotus.fastq
    #Creating OTU tables
    usearch -otutab ../../results/trimmomatic_results/usearch_merge/merged.fastq -otus ../../results/trimmomatic_results/otus.fastq -otutabout ../../results/trimmomatic_results/otutab.txt -mapout ../../results/trimmomatic_results/map.txt
    #Creating ZOTU tables
    usearch -otutab ../../results/trimmomatic_results/usearch_merge/merged.fastq -zotus ../../results/trimmomatic_results/zotus.fastq -otutabout ../../results/trimmomatic_results/zotutab.txt -mapout ../../results/trimmomatic_results/zmap.txt
    #normalization(needs 64_bit version)
}

chimera_detection

# the get_qiime2_artifact implements the qiime2 functions

function get_qiime2_artifact() {
    #Convert Otu reads into qiime2 artifact
    qiime tools import --input-path ../../results/trimmomatic_results/otus.fastq --output-path ../../results/trimmomatic_results/otus.qza --type 'FeatureData[Sequence]'
    #Perform Alignment using Mafft
    qiime alignment mafft --i-sequences ../../results/trimmomatic_results/otus.qza --o-alignment ../../results/trimmomatic_results/aligned_otus.qza
    #Masking sites (because in the alignment some sites are not phylogenetically informative)
    qiime alignment mask --i-alignment ../../results/trimmomatic_results/aligned_otus.qza --o-masked-alignment ../../results/trimmomatic_results/masked_aligned_otus.qza
    #Create Phylogeny tree using FastTree
    qiime phylogeny fasttree --i-alignment ../../results/trimmomatic_results/masked_aligned_otus.qza --o-tree ../../results/trimmomatic_results/unrooted_tree.qza
    #Midpoint-rooting of the Phylogeny tree
    qiime phylogeny midpoint-root --i-tree ../../results/trimmomatic_results/unrooted_tree.qza --o-rooted-tree ../../results/trimmomatic_results/rooted-tree.qza
    # qiime tools export unrooted-tree.qza --output-dir exported-tree
    #Convert Otu table into a qiime2 Artifact
    biom convert -i ../../results/trimmomatic_results/otutab.txt -o ../../results/trimmomatic_results/otu_table.from_txt_hdf5.biom --table-type="OTU table" --to-hdf5
    qiime tools import --input-path ../../results/trimmomatic_results/otu_table.from_txt_hdf5.biom --type 'FeatureTable[Frequency]' --output-path ../../results/trimmomatic_results/otu_tab.qza
    #Explore Beta and Alpha Diversity Analyses
    #Creates a bunch of diversity of analyses
    qiime diversity core-metrics --i-table ../../results/trimmomatic_results/otu_tab.qza --p-sampling-depth 4000 --m-metadata-file ../../results/trimmomatic_results/practice.dataset1.metadata.tsv --output-dir ../../results/trimmomatic_results/core-metrics-results
}

get_qiime2_artifact

# qiime2_visualization function implements the data visualizations for alpha diversity
function qiime2_visualization() {
    #Data Visualization
    #Alpha Diversity
    #Evenness
    qiime diversity alpha-group-significance  --i-alpha-diversity ../../results/trimmomatic_results/core-metrics-results/evenness_vector.qza   --m-metadata-file ../../../sample_data/practice.dataset1.metadata.tsv   --o-visualization ../../results/trimmomatic_results/core-metrics-results/evenness-group-significance.qzv
    #Shannon_Vector
    qiime diversity alpha-group-significance  --i-alpha-diversity ../../results/trimmomatic_results/core-metrics-results/shannon_vector.qza   --m-metadata-file ../../../sample_data/practice.dataset1.metadata.tsv   --o-visualization ../../results/trimmomatic_results/core-metrics-results/shannon_group-significance.qzv
    #Beta Diversity
    #Bray_Curtis
    qiime emperor plot --i-pcoa ../../results/trimmomatic_results/core-metrics-results/bray_curtis_pcoa_results.qza   --m-metadata-file ../../../sample_data/practice.dataset1.metadata.tsv  --o-visualization ../../results/trimmomatic_results/core-metrics-bray_curtis_pcoa_results.qzv
}

qiime2_visualization
