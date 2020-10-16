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
        expand("{sample}_hlahd", sample=samples['sample'])

rule run_hla_hd:
    input: 
        get_fastq
    output: 
        "{sample}_hlahd"
    threads: threads
    log: 
        "logs/hla-hd/{sample}.log"
    shell:
        "dir=`dirname {input[0]}`; hlahd.sh -t {threads} -m 75 -f /opt/hlahd.1.2.1/freq_data/ {input} /opt/hlahd.1.2.1/HLA_gene.split.txt /opt/hlahd.1.2.1/dictionary/ {output} $dir"

