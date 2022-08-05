import pandas as pd

threads=config['threads']
samples_file = config['samples']
samples = pd.read_table(samples_file).set_index(["sample"], drop=False)

def get_fastq(wildcards):
    fastqs = samples.loc[(wildcards.sample), ["fq1", "fq2"]].dropna()
    if len(fastqs) == 2:
        return f"{fastqs.fq1}", f"{fastqs.fq2}"
    return f"{fastqs.fq1}"

rule all:
    input: 
        expand("/data/{accession}_hlahd", accession=samples['sample'])

rule run_hla_hd:
    input: 
        "/data/{accession}_1.fastq",
        "/data/{accession}_2.fastq",
    output: 
        "/data/{accession}_hlahd"
    threads: threads
    log: 
        "/data/logs/hla-hd/{accession}.log"
    shell:
        "dir=`echo {input[0]} | cut -d \"/\" -f2 | cut -d \"_\" -f1`;mkdir -p {output}; hlahd.sh -t {threads} -m 75 -f /opt/hlahd.1.5.0/freq_data/ {input} /opt/hlahd.1.5.0/HLA_gene.split.txt /opt/hlahd.1.5.0/dictionary/ $dir {output}"

rule get_fastq_pe:
    output:
        # the wildcard name must be accession, pointing to an SRA number
        "/data/{accession}_1.fastq",
        "/data/{accession}_2.fastq",
    log:
        "/data/logs/pe/{accession}.log"
    params:
        extra="--skip-technical"
    threads: 6  # defaults to 6
    wrapper:
        "v1.7.1/bio/sra-tools/fasterq-dump"