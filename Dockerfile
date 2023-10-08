# Start with Python 3.11.6 base image
#FROM python:3.11-slim-bookworm
FROM arm64v8/python:3.11-bookworm
#FROM arm64v8/python:3.11-bookworm

# Set the working directory
WORKDIR /app

# Copy your project files into the Docker image
COPY . /app

# Set environment variables to non-interactive (this ensures that installs don't prompt for input)
ENV DEBIAN_FRONTEND=noninteractive

# Install base tools 
RUN apt-get update && apt-get install -y wget curl build-essential 
# gdal-bin python3-gdal
#openssl
# Install necessary packages and set up environment
# RUN apt-get update && \
#     apt-get install -y wget && \
#     mkdir -p /miniconda3 && \
#     wget https://repo.anaconda.com/miniconda/Miniconda3-py311_23.5.2-0-Linux-aarch64.sh -O /miniconda3/miniconda.sh && \
#     bash /miniconda3/miniconda.sh -b -u -p /miniconda3 && \
#     rm -rf /miniconda3/miniconda.sh

# # MAFFT Installation
# RUN wget https://mafft.cbrc.jp/alignment/software/mafft_7.520-1_amd64.deb && \
#     dpkg -i mafft_7.520-1_amd64.deb && \
#     rm mafft_7.520-1_amd64.deb

# NEW MAFFT
RUN wget https://mafft.cbrc.jp/alignment/software/mafft-7.505-with-extensions-src.tgz && \
    tar xfv mafft-7.505-with-extensions-src.tgz && \
    cd mafft-7.505-with-extensions/core/ && \
    make clean && make && make install && \
    cd ../extensions && make clean && make && make install && \
    cd ../.. && rm -rf mafft-7.505-with-extensions-src.tgz


# # IQ-TREE Installation
RUN wget https://github.com/iqtree/iqtree2/releases/download/v2.2.2.7/iqtree-2.2.2.7-Linux.tar.gz && \
    tar -zxvf iqtree-2.2.2.7-Linux.tar.gz && \
    mv iqtree-2.2.2.7-Linux/bin/iqtree2 /usr/bin/ && \
    rm -rf iqtree-2.2.2.7-Linux.tar.gz iqtree-2.2.2.7-Linux


# Install Miniconda
# RUN mkdir -p /miniconda3 && \
#     wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda3/miniconda.sh && \
#     bash /miniconda3/miniconda.sh -b -u -p /miniconda3 && \
#     rm -rf /miniconda3/miniconda.sh && \
#     /miniconda3/bin/conda init bash

#https://repo.anaconda.com/miniconda/Miniconda3-py311_23.5.2-0-Linux-aarch64.sh
# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py311_23.5.2-0-Linux-aarch64.sh -O ~/miniconda.sh && \
/bin/bash ~/miniconda.sh -b -p /opt/conda
# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# Update PATH for Miniconda (to use conda directly)
#ENV PATH="/miniconda3/bin:${PATH}"

# Install Python libraries
RUN pip install --no-cache-dir -r requirements.txt

# Set up Bioconda and install tools
RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge 


    # && \
    # conda install -c bioconda mafft

#conda install -c bioconda mafft iqtree muscle
# Set the default command for the container
CMD ["bash"]