FROM snakemake/snakemake:latest

WORKDIR /opt/

RUN apt update 

RUN apt install -y build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev

RUN conda install -c bioconda bowtie2

COPY hlahd.1.2.1.tar.gz .

RUN tar -zxvf hlahd.1.2.1.tar.gz

RUN cd hlahd.1.2.1 && \
    sh install.sh

RUN cp hlahd.1.2.1/bin/* /bin/

COPY Snakefile .
COPY config.yaml .
COPY samples.tsv .


