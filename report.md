### Workflow Analysis

### Why is this analysis necessary?
- This workflow aims to identify diversity of bacteria species present in samples.

### Application.
We used these two pipelines to identify the efficiency of different treatments (B,G and K) on bacteria species present in 15 dog samples, each with paired reads.

### Objectives.

1. To develop a 16S-rRNA  analysis workflow from illumina sequencing platform.
2. To test the pipelines.
3. To analyse the results.
4. To compare the tools used.


### Methodology.

##### Quality Control.

Purpose - Quality Control is performed to inspect the quality of sequenced reads. The quality scores will guide in trimming and filtering.

Tools used -Fastqc ,Multiqc and QIIME2.
Time - 2 minutes for both.

Pros - The tools are fast,lightweight and simple syntax.
Cons- None

Conclusion: Not much of the reads were truncated because the quality of reads was good.


#####  Trimming and Filtering reads.

Purpose - To remove poor quality reads.

Tools used -Trimmomatic, Prinseq and QIIME2

Time Taken:Trimmomatic - 10 minutes

           Prinseq - 6 minutes.
           Qiime - 4 minutes
Pros: - Trimmomatic and Prinseq provide more trimming options.

      - Qiime tool does both the quality check, filtering and trimming in one step ; syntax is brief.
     
Cons: For Trimmomatic and Prinseq, the proccess and report generation is not automatic. 

#####  Chimera Detection.
Purpose - To remove chimeras which can lead to spurious results.

Tools used -UCHIME, Qiime Deblur.

Time Taken:UCHIME - 70 minutes.
           Deblur - 6 minutes.

Pros - Deblur is fast and does chimera detection, denoising and feature table creation at once.Moreover, there is an informative report generated.

Cons - UCHIME requires a reference database.

#####  OTU Picking.

Purpose  - To find representative sequences/Sequence Variants for the samples. This is used when assigning taxonomy.

Tools used - USEARCH, Qiime Deblur.

Time Taken:USEARCH - 50 minutes.
           Deblur - 4 minutes.
```
Usearch uses closed-reference OTU picking whereas Qiime uses De novo OTU picking.
Qiime picked 209 OTUS whereas USEARCH picked 113 OTUS.
```
Pros  - Deblur is fast, uses De novo OTU picking which ensures no sequences are disregarded.
      - Deblur allows you to assign taxonomy upto subspecies level.
   

Cons  - USEARCH discards sequences that do not have a match in the reference database.
      - The OTUS picked in USEARCH are limited to the database used.


#####  ASV Prediction.

Purpose  - To find representative sequences/Sequence Variants for the samples. This is used when assigning taxonomy.

Tools used - Qiime Dada2.
Time Taken:   - 60 minutes.
          
```
282 sequence variants picked.
```
Pros  - More Accurate.


Cons  - USEARCH discards sequences that do not have a match in the reference database.
      - The OTUS picked in USEARCH are limited to the database used.


#####  Classification and Alignment.

Purpose  - To establish the similarities and dissimilarities between the variants picked (OTUS).

Tools used - Qiime mafft and FastTree.
Time Taken:Qiime - 10 minutes.

Pros  - Both Mafft and FastTree are fast and lightweight.
   

Cons  - The phylogeny tree .
      - The OTUS picked in USEARCH are limited to the database used.



#####  Diversity.
###### Alpha Diversity.
Purpose  - To establish the similarities within a community or treatment.

Tools used - Qiime.
Time Taken:Qiime - 7 minutes.

Pros  - The core metrics analyses generates alpha and beta diversity results in one command.
   

###### Beta Diversity.
Purpose  - To establish the similarities within a community or treatment.
Tools used - Qiime.
Time Taken:Qiime - 7 minutes.

Pros  - The core metrics analyses generates alpha and beta diversity results in one command.

##### Results.
To view the results generated from this project, [click here](https://mbbu.github.io/16S-mini-project/)

### Conclusion.

```
The results from both pipelines did not show significant differences on the dataset used. However, a bigger dataset would inform more about the most efficent pipeline. 
```
```
There was a more diverse population found in samples treated with B compared to K and G(least diverse). 

```
