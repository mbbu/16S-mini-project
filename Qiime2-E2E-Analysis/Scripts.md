
# How the scripts work

_download.sh_

This script makes a parent directory of the sample data file and downloads the practice sample data reads from the H3eaBionet website and the accompanying sample metadata file.

_16srna-dada2.sh and 16srna-deblur.sh_

Both these scripts are the main scripts and which employ the other scripts. Both consist of an end to end Qiime2 tools analysis using either of the two feature table creation strategies; 16srna-dada2.sh (for ASV Prediction) and 16srna-deblur.sh (for OTU Picking).

The scripts both have sequential Qiime2 steps whereby one step depends on the previous step.

_Q2_manifest_maker.py_

This script is an automatic manifest file maker which has one argument, the folder containing the fastq reads. Qiime2 uses Qiime2 Artifacts whereby the fastq reads have to be imported into Qiime2 Artifacts. This script automizes the construction of the manifest file which is used by Qiime2 Importing tools to import the fastq reads into a Qiime2 Artifact. For each of the reads, manifest file has sample names extracted from the reads, the absolute file path where the reads are found and the direction of the reads (both forward and reverse). The CSV file generated is used to import the sequences found in the folder of interest into a Qiime2 Artifact. Because of the specificty of formatting of the Qiime2 Import Tools, the CSV manifest file is further formatted after it has been made.


_train_classifier_gg.sh and train_classfier_silva.sh_

Both these scripts train classifiers using the Naive-Bayes model. To assign taxonomies to the feature table created earlier on in the main script, it is important to have a classifier which is used to assign taxonomies to the reads so as to determine their abundances. The only difference is the database being used. The train_classifier_gg.sh uses Greengenes as its database which the train_classifier_silva.sh uses SILVA as its database. While both do exactly the same thing, they take different times depending on how wide the database is.

_phyloseq.sh_

This script exports the Qiime2 products into items that can be imported as phyloseq objects. Phyloseq is an R package which makes it possible to conduct downstream analysis using an R environment. While Qiime2 is great for a majority of the analysis, it may not have everything R enthusiasts may want and so has been designed to offer flexibility to switch into R. 
