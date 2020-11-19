## About Project
This project creates a workflow for 16SrRNA analysis for researchers.The 16S rRNA is a ribosomal RNA necessary for the synthesis of all prokaryotic proteins.To read more on this [click here](https://www.cd-genomics.com/blog/16s-rrna-one-of-the-most-important-rrnas/).


#### sample data
Datasets used for this workflow can be downloaded from [here](http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/)


## Collaborators

1. [Bryan Abuchery](https://github.com/BryanAbuchery)

2. [Virginiah Periah](https://github.com/virginiah894)

## Tools Used

| Phases | Tools Used | Purpose | Download Link |
| --------------- |--------------- |--------------- | --------------- |
| Phase 1 | FASTQC | Quality check/plots and stats | [click here to download](http://www.bioinformatics.babraham.ac.uk/projects/fastqc )|
| Phase 1 | Trimmomatic | Trim and filter reads | [click here to download](http://www.usadellab.org/cms/?page=trimmomatic) |
| Phase 1 | PEAR | stitching paired reads | [click here to download](https://cme.h-its.org/exelixis/web/software/pear/doc.html) |
| Phase 1 | UCHIIME | Chimera detection | [click here to download](http://drive5.com/usearch/manual/uchime_algo.html)|
| Phase 2 | QIIME | OTU picking| [click here to download](http://qiime.org/)|
| Phase 2 | QIIME2 | ASV prediction| [click here to download](https://qiime2.org/) |
| Phase 2 | UCLUST | Classification | [click here to download](http://www.drive5.com/uclust/downloads1_2_22q.html)|
| Phase 2 | PyNAST | Alignment | [click here to download](http://www.ncbi.nlm.nih.gov/pubmed/19914921) |
| Phase 2 | FastTree | Create Phylogenetic tree| [click here to download](http://www.microbesonline.org/fasttree/)|
| Phase 3 | QIIME | Alpha diversity | [click here to download](https://qiime.org/) |
| Phase 3 | QIIME | Beta Diversity |[click here to download](https://qiime.org/) |






<!-- ## table

| Phases  | Tools Used |Purpose | Link to Download |
| --------  | ------------------- | --------------------- |
| Phase 1 | FASTQC    | [click here to download](http://www.bioinformatics.babraham.ac.uk/projects/fastqc )| 
| Phase 1 | Trimmomatic | Trim and filter reads | [click here to download](http://www.usadellab.org/cms/?page=trimmomatic) |
| Phase 1 | PEAR | stitching paired reads | [click here to download](https://cme.h-its.org/exelixis/web/software/pear/doc.html) |
| Phase 1 | UCHIIME | Chimera detection | [click here to download](http://drive5.com/usearch/manual/uchime_algo.html)|
| Phase 1 | QIIME | OTU picking| [click here to download](http://qiime.org/)|
| Phase 2 | QIIME2 | ASV prediction| [click here to download](https://qiime2.org/) |
| Phase 2 | UCLUST | Classification | [click here to download](http://www.drive5.com/uclust/downloads1_2_22q.html)|
| Phase 2 | PyNAST | Alignment | [click here to download](http://www.ncbi.nlm.nih.gov/pubmed/19914921) |
| Phase 2 | FastTree | Create Phylogenetic tree| [click here to download](http://www.microbesonline.org/fasttree/)|
| Phase 3 | QIIME | Alpha diversity | [click here to download](https://qiime.org/) |
| Phase 3 | QIIME | Beta Diversity |[click here to download](https://qiime.org/) |
          |  -->


## Setting Up And Installation

This workflow assumes that you have already installed all tools required as mentioned above.



## B.D.D

## Bugs
There are no known bugs, but incase of any feel free to reach any collaborators of this repository.


## LICENSE
[MIT](https://github.com/mbbu/16S-mini-project/blob/main/LICENSE)