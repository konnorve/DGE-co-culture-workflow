
rule run_trim_PE:
    input:
        r1 = lambda wildcards: SAMPLE_TABLE.loc[wildcards.sample, 'fwd_read'],
        r2 = lambda wildcards: SAMPLE_TABLE.loc[wildcards.sample, 'rev_read'],
        ref = Path(config["input"]["adapter_file"]),
    output:
        o1 = output_path_dict["trimmed_reads"] / "{sample}_1_trimmed.fastq.gz",
        o2 = output_path_dict["trimmed_reads"] / "{sample}_2_trimmed.fastq.gz",
    resources:
        mem_mb=100000,
    conda:
        "../envs/bbtools.yaml"
    shell:
        "bbduk.sh "
        "in1={input.r1} in2={input.r2} "
        "out1={output.o1} out2={output.o2} "
        "minlen=25 qtrim=rl trimq=10 "
        "ref={input.ref} ktrim=r k=23 mink=11 hdist=1"



# rule run_trim_SE:
#     input:
#         r = Path(config["input"]["raw_reads"]) / "2019_dark_adapted_transcriptome_sequencing_{sample}.fastq.bz2",
#         ref = Path(config["input"]["adapter_file"]),
#     output:
#         o = output_path_dict["trimmed_reads"] / "{sample}_trimmed.fastq.gz",
#     resources:
#         mem_mb=100000,
#     conda:
#         "../envs/bbtools.yaml"
#     shell:
#         "bbduk.sh "
#         "in={input.r} "
#         "out={output.o} "
#         "minlen=25 qtrim=rl trimq=10 "
#         "ref={input.ref} ktrim=r k=23 mink=11 hdist=1"