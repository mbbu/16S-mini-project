#! usr/bin/env/bash

#Fastqc the data

fastqc *.fastq

mkdir fastqc_results
mv *.zip fastqc_results/ && mv *.html fastqc_results/
cd fastqc_results/
for file in *zip
do
unzip $file

done
cat */summary.txt >>  fastq_summary.txt
mv fastq_summary.txt ../
cd ..

#Trim the reads with trimmomatic

for i in `ls -1 *R1*.fastq | sed 's/\_R1.fastq//'`
do
trimmomatic PE -phred64 $i\_R1.fastq $i\_R2.fastq $i\_R1_paired.fastq $i\_R1_unpaired.fastq $i\_R2_paired.fastq $i\_R2_unpaired.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

done
#Using trimmomatic results

mkdir trimmomatic_results
mv *paired* trimmomatic_results/
cd trimmomatic_results/

#Check to see maximum & minimum read lengths for merging.
mkdir -p merge_test
usearch -fastq_mergepairs *_R1_paired.fastq -fastq_merge_maxee 1 -relabel @ -report merge_test/merge_test.log

#Merging using usearch
mkdir -p usearch_merge
usearch -fastq_mergepairs *_R1_paired.fastq -fastq_minmergelen 75 -fastq_maxmergelen 265 -relabel @ -report usearch_merge/merge.log -fastqout usearch_merge/merged.fastq -tabbedout usearch_merge/detail_pairs.log

#Move merge test logfile into usearch dir.
mv merge_test usearch_merge/
mv usearch_merge/ ../
cd ..


#Download the database SILVA DATABASE bacteria fasta as referrence sequences.
# if
# [[! -f silva.bacteria.fasta]] && 
wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip
unzip silva.bacteria.zip
cd silva.bacteria && mv silva.bacteria.fasta ../ && cd ..


#Chimera detection
usearch -uchime2_ref usearch_merge/merged.fastq -db silva.bacteria.fasta -uchimeout chimera_out.fastq -strand plus -mode sensitive

#Orient - Proper alignment 
usearch -orient usearch_merge/merged.fastq -db silva.bacteria.fasta -fastqout oriented.fastq -tabbedout orient.txt
#Filter your oriented reads- Remove repeats
usearch -fastq_filter oriented.fastq -fastq_maxee 1.0 -fastaout filtered.fastq
#Dereplication remove duplicates

usearch -fastx_uniques filtered.fastq -fastaout uniques.fastq -sizeout -relabel Uniq
#Otu Clustering - clustering the uniques only
usearch -cluster_otus uniques.fastq -otus otus.fastq -uparseout uparse.txt -relabel Otu
 # Denoise to form ZOTUS
 usearch -unoise3 uniques.fastq -zotus zotus.fastq

# OTU TABLES  and Mapping
usearch -otutab usearch_merge/merged.fastq -otus otus.fastq -otutabout otutab.txt -mapout map.txt

usearch -otutab usearch_merge/merged.fastq -zotus zotus.fastq -otutabout zotutab.txt -mapout zmap.txt
# Normalization (64-bit usearch version)
# usearch -otutab_norm otutab.txt -sample_size 5000 -output otutab_norm.txt

# usearch -otutab_norm zotutab.txt -sample_size 5000 -output zotutab_norm.txt

# QUALITY CONTROL
# usearch -usearch_global otus.fastq -db silva.bacteria.fasta -id 0.9 -strand both -alnout otu.aln -uc otu.uc
#  Check identity distribution
# cut -f4 otu.uc | sort -g | uniq -c > id_dist.txt


# Alignment using INFERNAL(Inference of RNA Alignment)
# infernal -i otus.fastq -t silva.bacteria.fasta  -o  aligned_otus.fastq
# Alignment with muscle
# mv silva.bacteria.fasta >> otus.fastq
# muscle -in otus.fastq -out aligned_otus.fastq -maxiters 2



# #  phylogenetic tree with Fast Tree
# FastTree -gtr -nt  otus.fastq > tree_file.txt


# Alpha Diversity using USEARCH for shannon index(basic metrics)
# usearch -alpha_div otutab.txt -output alphadiversity.txt



#Calculate significant of differences in all metrics in a community

# usearch -alpha_div_sig otutab.txt -meta map.txt -tabbedout sig.txt


# Beta diversity using USEARCH
# usearch -beta_div otutab.txt



# calculate Gini-Simpson index

# usearch -alpha_div otutable.txt -output gini.txt -metrics gini_simpson

# calculate Chao1 and Berger-Parker indexes

# usearch -alpha_div otutable.txt -output alpha.txt -metrics chao1,berger_parker
 

# Shannon index in Qiime
# for i in 'shannon' 'observed_otus' 'dominance'
# do
# echo $i
# qiime diversity alpha
# --i-table Ar2_raw_PairedEnd_table_deblur.qza
# --p-metric $i
# --o-alpha-diversity $i.qza
# done


# Alpha diversity using qiime

# First import your data
qiime tools import --input-path otus.fastq --output-path otus.qza --type 'FeatureData[Sequence]'

#Alignment using MAFFT- for 
qiime alignment mafft --input-sequences otus.qza --o-alignment aligned_otus.qza
#Masking

qiime alignment mask --i-alignment aligned_otus.qza  --o-masked-alignment masked_aligned_otus.qza
# Construct Phylogenetic tree
qiime phylogeny fasttree --i-alignment masked_aligned_otus.qza --o-tree unrooted_tree.qza
# Midpoint rooting
qiime phylogeny midpoint-root --i-tree unrooted_tree.qza --o-rooted-tree rooted_tree.qza

# convert otutab.txt to hdf5 formart which is BIOM (Json /hdf5)

# biom convert -i otutab.txt -o table.from_txt_json.biom --table-type="OTU table" --to-json

biom convert -i otutab.txt -o table.from_txt_hdf5.biom --table-type="OTU table" --to-hdf5
# Import the table to qiime artifacts as a feature table

qiime tools import --input-path table.from_txt_hdf5.biom --type 'FeatureTable[Frequency]' --output-path otutable111.qza
#  core -metric diversity that does both alpha and beta

# Alpha diversity
qiime diversity alpha --i-table otutable111.qza  --p-metric observed_otus --o-alpha-diversity otus_tables.qza

# Core metrics diversity

qiime diversity core-metrics --i-table otutable111.qza --p-sampling-depth 4000 --m-metadata-file practice.dataset1.metadata.tsv --output-dir core-metrics-results/

# Convert qza`s into qzv`s -if they aren`nt in order to visualize in qiime.
# Open your files  then drag and drop any metric qzv file to the qiime2 web (https://view.qiime2.org/)

# Eveness vector(alpha diversity)
qiime diversity alpha-group-significance --i-alpha-diversity core-metrics-results/evenness_vector.qza --m-metadata-file practice.dataset1.metadata.tsv --o-visualization core-metrics-results/evenness-group-significance.qzv

# Shannon vector
qiime diversity alpha-group-significance --i-alpha-diversity core-metrics-results/shannon_vector.qza --m-metadata-file practice.dataset1.metadata.tsv --o-visualization core-metrics-results/shannon_index.qzv

# Beta Diversity
# Example with bray-curtis
qiime emperor plot   --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza   --m-metadata-file practice.dataset1.metadata.tsv  --o-visualization core-metrics-results/bray_curtis_pcoa_results.qzv

