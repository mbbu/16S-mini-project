### Workflow Analysis

### Why is this analysis necessary?
- This workflow aims at identifying diversity of bacteria species present in samples.

### Application
We used these two pipelines to identify the efficiency of different treatments (B,G and K) on bacteria species present in 15 dog samples, each with paired reads.

### Objectives
1. To develop a 16S rRNA  analysis workflow from illumina sequencing platform.

2. To test the pipelines.
3. To analyse the results.
4. To compare the tools used.
### Methodology

##### Quality check
Purpose - Quality Control is performed to inspect the quality of sequenced reads. The quality scores will guide in trimming and filtering.

Tools used -Fastqc ,Multiqc and QIIME2.
Time - 2 minutes for both.

Pros - The tools are fast,lightweight and simple syntax.
Cons- None

Conclusion: Not much of the reads were truncated because the quality of reads was good.


#####  Trimming and filtering reads
Purpose - To remove poor quality reads.
Tools used -Trimmomatic, Prinseq and QIIME2
Time Taken:Trimmomatic - 10 minutes
           Prinseq - 6 minutes.
           Qiime - 4 minutes
Pros: - Trimmomatic and Prinseq provide more trimming options.
      - Qiime tool does both the quality check,filtering and trimming in one step ; syntax is brief.
     
Cons:For Trimmomatic and Prinseq, the proccess and report generation is not automatic. 

#####  Chimera detection
Purpose - To remove chimeras which can lead to spurious results.
Tools used -UCHIME, Qiime Deblur.
Time Taken:UCHIME - 70 minutes.
           Deblur - 6 minutes.

Pros - Deblur is fast and does chimera detection,denoising and feature table creation at once.Moreover, there is an informative report generated.
Cons - UCHIME requires a reference database.
#####  OTU picking
Purpose - To find representative sequences/Sequence Variants for the samples. This is used when assigning taxonomy.
Tools used -USEARCH, Qiime Deblur.
Time Taken:USEARCH - 50 minutes.
           Deblur - 4 minutes.
```
***usearch uses closed-reference OTU picking whereas Qiime uses De novo OTU picking.***
```
Pros - Deblur is fast and does chimera detection,denoising and feature table creation at once.Moreover, there is an informative report generated.
Cons - USEARCH requires a reference database.


#####  ASV prediction
#####  Classification and alignment
#####  Phylogenetic analysis
#####  Measurement of diversity

|Pipeline | Tools| Purpose | Time | Computational Resources | Pros | Cons
| --------------- |--------------- |--------------- | --------------- |--------------- |--------------- |--------------- |
|Qiime2 pipeline | | | | | | |
| Usearch/Qiime workflow| | | | | | |
