## About Project
This project creates a workflow for 16SrRNA analysis for researchers.The 16S rRNA is a ribosomal RNA necessary for the synthesis of all prokaryotic proteins.To read more on this [click here](https://www.cd-genomics.com/blog/16s-rrna-one-of-the-most-important-rrnas/).


## Sample data
Datasets used for this workflow can be downloaded from [here](http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/). The Dataset metadata can be downloded from [this link](http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/practice.dataset1.metadata.tsv). After downloading the metadata file, open it with your favourite text editor and change the column headers into lowercase. Ensure that both your dataset and metadata are in one directory.



## Collaborators

1. [Bryan Abuchery](https://github.com/BryanAbuchery)

2. [Virginiah Periah](https://github.com/virginiah894)


## Tools Used

| Phases | Tools Used | Purpose | Download Link |
| --------------- |--------------- |--------------- | --------------- |
| Phase 1 | FASTQC | Quality check/plots and stats | [click here to download](https://anaconda.org/bioconda/fastqc)|
| Phase 1 | Trimmomatic | Trim and Filter reads | [click here to download](https://anaconda.org/bioconda/trimmomatic) |
| Phase 1 | UPARSE | Stitching paired reads | [click here to download](http://www.metagenomics.wiki/tools/16s/qiime/install/usearch61) |
| Phase 1 | UCHIME | Chimera detection | [click here to download](http://www.metagenomics.wiki/tools/16s/qiime/install/usearch61)|
| Phase 2 | UPARSE | OTU picking  and Chimera removal| [click here to download](http://www.metagenomics.wiki/tools/16s/qiime/install/usearch61)|
| Phase 2 | QIIME2 | Classification | [click here to download](https://docs.qiime2.org/2020.8/)|
| Phase 2 | QIIME2 | Alignment | [click here to download](https://docs.qiime2.org/2020.8/) |
| Phase 2 | QIIME2 | Create Phylogenetic tree| [click here to download](https://docs.qiime2.org/2020.8/)|
| Phase 3 | QIIME2 | Alpha diversity | [click here to download](https://docs.qiime2.org/2020.8/) |
| Phase 3 | QIIME2 | Beta Diversity |[click here to download](https://docs.qiime2.org/2020.8/)|




## Set Up And Installation

For you to be able to follow this workflow;

1. Install Qiime2 by following [this link](https://docs.qiime2.org/2020.8/install/native/).

2. Activate the Qiime2 environment and conda install Fastqc and Trimmomatic as guided by the above links in the "Tools used" section. Alternatively, there is a .yml Qiime2-2020.8 environment on this repo. After cloning the repo, on the terminal; `cd` into "Qiime_env" and bash `conda create -f try.yml` After running successfully, bash `conda activate Qiime2-2020.8`
3. Download USEARCH as the Uchime and Uparse tools are depnded on it. However, USEARCH does not have an installation set up. To be able to use USEARCH, follow [this link](http://www.metagenomics.wiki/tools/16s/qiime/install/usearch61).

_Note_: Tools in USEARCH could be used only in so far as Chimera detection. This is the 32-bit version which is licensed for free use. The section running from Classification until Alpha and Beta Diversity Analyses requires Qiime2 tools, hence working from the Qiime2 environment.

4. Download the [Dataset](http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/) and the [metadata](http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/practice.dataset1.metadata.tsv) as described in the links above.

5. Move the directory containing your data set and metadata into the 16S-mini-project. Bash `cd scripts && cp 16srna.sh ../path/to/your/dataset` To run the workflow; bash `cd path/to/your/dataset && bash 16srna.sh`



## Bugs
There are no known bugs, but incase of any feel free to reach any collaborators of this repository.


## LICENSE
[MIT](https://github.com/mbbu/16S-mini-project/blob/main/LICENSE)
