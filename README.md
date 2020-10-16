# hla-pipeline

### Download

First clone this repository

```git clone https://github.com/osvaldoreisss/hla-pipeline.git```

To download HLA-HD we need to fill a form to get a user and password. After just use wget to download replacing user and passwd with your user and password.

```wget --http-user=user --http-password=password https://www.genome.med.kyoto-u.ac.jp/HLA-HD/filedownload/hlahd.1.2.1.tar.gz```

### Create docker image

First edit the samples.tsv file and add sample name, condition, the full path to fastq files.

```docker build --network=host -t hla:v1 -f Dockerfile .```

### Run pipeline

```docker run -it -v/path/to/root/fastq/:/path/to/root/fastq/ hla:v1 snakemake -p --use-conda --cores 1 --config samples=samples.tsv threads=1```

The -v/path/to/root/fastq/:/path/to/root/fastq/  must be the full path to the root where the fastq input files are stored.