### Workflow Analysis

### Why is this analysis necessary?
- This workflow aims at identifying bacteria species present in samples.

### Application
We used these two pipelines to identify the efficiency of different treatments (B,G and K) on bacteria species present in different dog samples.

### Objectives
1. To develop a 16S rRNA  analysis workflow from illumina sequencing platform.

2. To test the pipelines.
3. To analyse the results.

### Methodology

##### Quality check
Purpose - Quality Control is performed to inspect the quality of sequenced reads. The quality scores will guide in trimming and filtering.
Tools used -Fastqc and Multiqc 
Time- 2 minutes for both.

Pros - Both are fast, lightweight and simple syntax.
Cons- None


#####  Trimming and filtering reads
Purpose - To remove poor quality reads.
Tools used -Trimmomatic and Prinseq 
Time- Trimmomatic took 10 minutes whereas Prinseq took 6 minutes.

Pros - Give trimming options
Cons - 
[<img src="images/emperor(12).png">](images/emperor(12).png)




#####  Chimera detection
Purpose - To remove chimeras which can lead to spurious results.
Tools used -Trimmomatic and Prinseq 
Time- Trimmomatic took 10 minutes whereas Prinseq took 6 minutes.

Pros - Give trimming options
Cons - 
#####  OTU picking
#####  ASV prediction
#####  Classification and alignment
#####  Phylogenetic analysis
#####  Measurement of diversity

|Pipeline | Tools| Purpose | Time | Computational Resources | Pros | Cons
| --------------- |--------------- |--------------- | --------------- |--------------- |--------------- |--------------- |
|Qiime2 pipeline | | | | | | |
| Usearch/Qiime workflow| | | | | | |
