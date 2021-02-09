#!/usr/bin/env bash

# Downloads the practice data set and metadata

cd ../../../

mkdir -p sample_data && cd sample_data

dataset_uri=http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/

# download_metadata function downloads the practice dataset metadata
function download_metadata() {
    meta_uri=http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/practice.dataset1.metadata.tsv
    echo "##### Downloading metadata from ${meta_uri} #####"
    wget ${meta_uri}
}

# download_dataset function downloads the practice dataset and saves it in the sample_data directory
function download_dataset() {
    download_metadata
    for number  in 1 2 3 8 9 10 15 16 17 22 23 24 29 30 31;
    do
        read1File="Dog${number}_R1.fastq"
        read2File="Dog${number}_R2.fastq"
        echo "##### Downloading ${read1File} from ${dataset_uri}${read1File} #####" && wget ${dataset_uri}${read1File} &
        echo "##### Downloading ${read2File} from ${dataset_uri}${read2File} #####" && wget ${dataset_uri}${read2File} &


    done
}

download_dataset &

wait

cd ../ && mkdir backup_data

echo "Creating a backup of the sample data"

cp -r sample_data backup_data # create a backup of the sample data into the backup_data directory
