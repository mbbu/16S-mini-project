# This script marks the begining of the analysis by instaling all the project dependancies

mkdir -p dependancies && cd dependancies

# the install miniconda function below installs the miniconda into your local machine
function install_miniconda () {
    echo "#### Installing Miniconda ####"
    mkdir -p miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3/miniconda.sh
    bash miniconda3/miniconda.sh -b -u -p miniconda3
    rm -rf miniconda3/miniconda.sh
    miniconda3/bin/conda init bash
    miniconda3/bin/conda init zsh
    echo "#### Succefully Installed Miniconda ####"
}

install_miniconda

# the function below updates the conda, installs wget then downloads the qiime2 tool
function install_qiime2() {
    echo "#### Installing Qiime ####"
    #conda update conda
    conda install wget
    wget https://data.qiime2.org/distro/core/qiime2-2020.8-py36-linux-conda.yml
    conda env create -n qiime2-2020.8 --file qiime2-2020.8-py36-linux-conda.yml
    rm qiime2-2020.8-py36-linux-conda.yml
    conda activate qiime2-2020.8
    echo "#### Succefully Installed Qiime ####"
}

install_qiime2

# the function below installs the usearch tool
function install_usearch(){
    echo "#### Installing Usearch ####"
    wget http://www.drive5.com/downloads/usearch11.0.667_i86linux32.gz
    gzip -d usearch11.0.667_i86linux32.gz
    mv usearch11.0.667_i86linux32 usearch
    chmod a+x usearch
    sudo mv usearch /usr/local/bin/
    echo "#### Succefully Installed Usearch ####"
}

install_usearch

# Install the trimmomatic package
echo "#### Installing Trimmomatic ####"
conda install -c bioconda trimmomatic
echo "#### Succefully Installed Trimmomatic ####"

echo "#### Executing the data-downloader script ####"

cd ../workflow/scripts/bash && bash data-downloader.sh
