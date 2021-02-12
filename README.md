## About Project
This project creates a workflow for 16SrRNA analysis for researchers.The 16S rRNA is a ribosomal RNA necessary for the synthesis of all prokaryotic proteins.To read more on this [click here](https://www.cd-genomics.com/blog/16s-rrna-one-of-the-most-important-rrnas/).


## Sample data
Datasets used for this workflow can be found [here](http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/). The Dataset metadata is found at [this link](http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/practice.dataset1.metadata.tsv), but we will be downloading the datasets and metadata automatically using the [data-downloader script](https://github.com/totodingi/16S-mini-project/blob/main/workflow/scripts/bash/data-downloader.sh).


## Collaborators

1. [Bryan Abuchery](https://github.com/BryanAbuchery)

2. [Virginiah Periah](https://github.com/virginiah894)


## Tools Used

| Phases | Tools Used | Purpose | Link |
| --------------- |--------------- |--------------- | --------------- |
| Phase 1 | FASTQC | Quality check/plots and stats | [Link](https://anaconda.org/bioconda/fastqc)|
| Phase 1 | Trimmomatic | Trim and Filter reads | [Link](https://anaconda.org/bioconda/trimmomatic) |
| Phase 1 | UPARSE | Stitching paired reads | [Link](http://www.metagenomics.wiki/tools/16s/qiime/install/usearch61) |
| Phase 1 | UCHIME | Chimera detection | [Link](http://www.metagenomics.wiki/tools/16s/qiime/install/usearch61)|
| Phase 2 | UPARSE | OTU picking  and Chimera removal| [Link](http://www.metagenomics.wiki/tools/16s/qiime/install/usearch61)|
| Phase 2 | QIIME2 | Classification | [Link](https://docs.qiime2.org/2020.8/)|
| Phase 2 | QIIME2 | Alignment | [Link](https://docs.qiime2.org/2020.8/) |
| Phase 2 | QIIME2 | Create Phylogenetic tree| [Link](https://docs.qiime2.org/2020.8/)|
| Phase 3 | QIIME2 | Alpha diversity | [Link](https://docs.qiime2.org/2020.8/) |
| Phase 3 | QIIME2 | Beta Diversity |[Link](https://docs.qiime2.org/2020.8/)|




## Set Up And Installation

For you to be able to follow this workflow;

1. Clone this repository locally, then 

        cd "path/to/project/16S-mini-project" && bash start.sh

      Once you do this, sit back, relax and sip some coffee or water :blush:, its going to take a while. 

2. End to End 16S RNA analysis can also be done using Qiime2 feature tools only. This analysis produces different core metrics alpha and beta analyses as well as explores different microbial profiles by assigning taxonomies. To follow this kind route, activate the Qiime2-2020.8 environment, `cd` into Qiime2-E2E-Analysis and `bash scripts/16srna-deblur.sh` to do denoising using deblur or `bash scripts/16srna-dada2.sh` to denoise using dada2. The scripts follow a download of datasets to analysis end of Qiime2. Please ensure that you read the documentation for each of the scripts used before running them. The automatic manifest file maker was adapted [from this repo](https://github.com/Micro-Biology/BasicBashCode/blob/master/BasicScripts/Q2_manifest_maker.py) The script that exports Qiime2 artifacts into objects that can be used with phyloseq was adopted from [this tutorial](http://john-quensen.com/tutorials/processing-16s-sequences-with-qiime2-and-dada2/). More information about importing dada2 artifacts into phyloseq can also be obtained [from here.](http://john-quensen.com/r/import-dada2-asv-tables-into-phyloseq/)



## Bugs
There are no known bugs, but incase of any feel free to reach any collaborators of this repository.


## LICENSE
[MIT](https://github.com/mbbu/16S-mini-project/blob/main/LICENSE)
