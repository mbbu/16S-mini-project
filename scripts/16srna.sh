#! usr/bin/env/bash

#fastqc the data

fastqc *.fastq

mkdir fastqc_results
mv *.zip fastqc_results/ && mv *.html fastqc_results/


#for file in *_fastqc
#do
#cat $file/summary.txt >> fastqc_summary.txt

#done

#cd ..

#trim the reads with trimmomatic

for i in `ls -1 *R1*.fastq | sed 's/\_R1.fastq//'`
do
trimmomatic PE -phred64 $i\_R1.fastq $i\_R2.fastq $i\_R1_paired.fastq $i\_R1_unpaired.fastq $i\_R2_paired.fastq $i\_R2_unpaired.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

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

#orient
usearch -orient usearch_merge/merged.fastq -db silva.bacteria.fasta -fastqout oriented.fastq -tabbedout orient.txt
#filter your oriented reads
usearch -fastq_filter oriented.fastq -fastq_maxee 1.0 -fastaout filtered.fastq
#dereplication remove duplicates
# replicates are discarded
usearch -fastx_uniques filtered.fastq -fastaout uniques.fastq -sizeout -relabel Uniq
#Otu Clustering - clustering the uniques only
usearch -cluster_otus uniques.fastq -otus otus.fastq -uparseout uparse.txt -relabel Otu
 # Denoise to form ZOTUS
 usearch -unoise3 uniques.fastq -zotus zotus.fastq

# OTU TABLES  and Mapping
usearch -otutab usearch_merge/merged.fastq -otus otus.fastq -otutabout otutab.txt -mapout map.txt

usearch -otutab usearch_merge/merged.fastq -zotus zotus.fastq -otutabout zotutab.txt -mapout zmap.txt

# usearch -otutab_norm otutab.txt -sample_size 5000 -output otutab_norm.txt

# usearch -otutab_norm zotutab.txt -sample_size 5000 -output zotutab_norm.txt

# QUALITY CONTROL
# usearch -usearch_global otus.fastq -db silva.bacteria.fasta -id 0.9 -strand both -alnout otu.aln -uc otu.uc
#  Check identity distribution
# cut -f4 otu.uc | sort -g | uniq -c > id_dist.txt


# Alignment using INFERNAL(Inference of RNA Alignment)
# infernal -i otus.fastq -t silva.bacteria.fasta  -o  aligned_otus.fastq
# Alignment with muscle
mv silva.bacteria.fasta >> otus.fastq
muscle -in otus.fastq -out aligned_otus.fastq -maxiters 2



#  phylogenetic tree with Fast Tree
FastTree -gtr -nt  otus.fastq > tree_file.txt


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
# download feature
wget -O "feature-table.qza" "https://data.qiime2.org/2018.2/tutorials/exporting/feature-table.qza"

#  Export features
qiime tools export feature-table.qza --output-dir exported-feature-table
cat otutab.txt feature-table.qza
# Alpha diversity 
qiime diversity alpha --i-table feature-table.qza  --p-metric shannon --o-alpha-diversity try2.qza



