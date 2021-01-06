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
#Do Trimmomatic for trimming
for i in `ls -1 *R1*.fastq | sed 's/\_R1.fastq//'`
do
trimmomatic PE -phred33 $i\_R1.fastq $i\_R2.fastq $i\_R1_paired.fastq $i\_R1_unpaired.fastq $i\_R2_paired.fastq $i\_R2_unpaired.fastq LEADING:3  TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done

mkdir trimmomatic_results
mv *paired* trimmomatic_results/
cd trimmomatic_results/

#Do quality check for trimmomatic results
fastqc *_paired.fastq
mkdir trimmomatic_fastqc_results
mv *.zip trimmomatic_fastqc_results && mv *.html trimmomatic_fastqc_results
cd trimmomatic_fastqc_results
for zip in *.zip; do unzip $zip; done
cat */summary.txt >> trimmomatic_fastqc_summary.txt
mv trimmomatic_fastqc_summary.txt ../../
cd ..

#Merge files
#Merge Test to determine maximum and minimum length.
mkdir -p merge_test
usearch -fastq_mergepairs *_R1_paired.fastq -relabel @ -report merge_test/merge_test.log
#Perform Merge
mkdir -p usearch_merge
usearch -fastq_mergepairs *_R1_paired.fastq -fastq_minmergelen \
 75 -fastq_maxmergelen 265 -relabel @ -report usearch_merge/merge.log -fastqout usearch_merge/merged.fastq -tabbedout usearch_merge/detail_pairs.log
mv merge_test usearch_merge/
mv usearch_merge/ ../

cd ..

wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip
unzip silva.bacteria.zip
cd silva.bacteria && mv silva.bacteria.fasta ../ && cd ..

#Chimera detection
usearch -uchime2_ref usearch_merge/merged.fastq -db silva.bacteria.fasta -uchimeout chimera_out.fastq -strand plus -mode sensitive
#strip primer-binding sequences
#usearch -fastx_truncate merged.fq -stripleft 19 -stripright 20 -fastqout stripped.fq
#Orient
usearch -orient usearch_merge/merged.fastq -db silva.bacteria.fasta -fastqout oriented.fastq -tabbedout orient.txt
#Filter your oriented reads
usearch -fastq_filter oriented.fastq -fastq_maxee 1.0 -fastaout filtered.fastq
#Dereplication
usearch -fastx_uniques filtered.fastq -fastaout uniques.fastq -sizeout -relabel Uniq
#Otu Clustering
usearch -cluster_otus uniques.fastq -otus otus.fastq -uparseout uparse.txt -relabel Otu
#Denoise -Remove clutters
usearch -unoise3 uniques.fastq -zotus zotus.fastq
#Creating OTU tables
usearch -otutab usearch_merge/merged.fastq -otus otus.fastq -otutabout otutab.txt -mapout map.txt
#Creating ZOTU tables
usearch -otutab usearch_merge/merged.fastq -zotus zotus.fastq -otutabout zotutab.txt -mapout zmap.txt
#normalization(needs 64_bit version)
#usearch -otutab_rare otutab.txt -output otutab_norm.txt
#usearch -zotutab_rare zotutab.txt -output zotutab_norm.txt

# Align the sequences with an ARB file-format database
#Convert the silva database into an ARB file-format database.
#sina -i silva.bacteria.fasta -o silva.bacteria.arb --prealigned
#Align your sequences
#sina -i otus.fastq -o otus_aligned.fastq --db silva.bacteria.arb

#Convert Otu reads into qiime2 artifact
qiime tools import --input-path otus.fastq --output-path otus.qza --type 'FeatureData[Sequence]'
#Perform Alignment using Mafft
qiime alignment mafft --i-sequences otus.qza --o-alignment aligned_otus.qza
#Masking sites (because in the alignment some sites are not phylogenetically informative)
qiime alignment mask --i-alignment aligned_otus.qza --o-masked-alignment masked_aligned_otus.qza
#Create Phylogeny tree using FastTree
qiime phylogeny fasttree --i-alignment masked_aligned_otus.qza --o-tree unrooted_tree.qza
#Midpoint-rooting of the Phylogeny tree
qiime phylogeny midpoint-root --i-tree unrooted_tree.qza --o-rooted-tree rooted-tree.qza
# qiime tools export unrooted-tree.qza --output-dir exported-tree
#Convert Otu table into a qiime2 Artifact
biom convert -i otutab.txt -o otu_table.from_txt_hdf5.biom --table-type="OTU table" --to-hdf5
qiime tools import --input-path otu_table.from_txt_hdf5.biom --type 'FeatureTable[Frequency]' --output-path otu_tab.qza
#Explore Beta and Alpha Diversity Analyses
#Creates a bunch of diversity of analyses
qiime diversity core-metrics --i-table otu_tab.qza --p-sampling-depth 4000 --m-metadata-file practice.dataset1.metadata.tsv --output-dir core-metrics-results


#Data Visualization
#Alpha Diversity
#Evenness
qiime diversity alpha-group-significance  --i-alpha-diversity core-metrics-results/evenness_vector.qza   --m-metadata-file practice.dataset1.metadata.tsv   --o-visualization core-metrics-results/evenness-group-significance.qzv
#Shannon_Vector
qiime diversity alpha-group-significance  --i-alpha-diversity core-metrics-results/shannon_vector.qza   --m-metadata-file practice.dataset1.metadata.tsv   --o-visualization core-metrics-results/shannon_group-significance.qzv
#Beta Diversity
#Bray_Curtis
qiime emperor plot --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza   --m-metadata-file practice.dataset1.metadata.tsv  --o-visualization core-metrics-bray_curtis_pcoa_results.qzv




