FROM snakemake/snakemake:latest

WORKDIR /opt/

RUN apt update 

RUN apt install -y build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev

RUN mamba install -c conda-forge -c bioconda bowtie2

COPY hlahd.1.5.0.tar.gz .

RUN tar -zxvf hlahd.1.5.0.tar.gz

RUN cd hlahd.1.5.0 && \
    sh install.sh

RUN cp hlahd.1.5.0/bin/* /bin/

COPY Snakefile .
#COPY config.yaml .
COPY samples.tsv .


