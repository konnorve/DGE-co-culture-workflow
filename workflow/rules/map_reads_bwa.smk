# map sample reads to concatenated genome
rule map_reads_PE:
    input:
        r1 = path_dict["trimmed_reads"] / "{sample}_1_trimmed.fastq",
        r2 = path_dict["trimmed_reads"] / "{sample}_2_trimmed.fastq",
        ref = path_dict["concat_genome"]["concat_genome_file"],
        indexing = path_dict"concat_genome"]["concat_genome_done"]
    output:
        sam_out = temp(path_dict["mapped_reads"] / "{sample}_mapped.sam"),
        sai1 = temp(path_dict["mapped_reads"] / "{sample}_1_bwa.sai"),
        sai2 = temp(path_dict["mapped_reads"] / "{sample}_2_bwa.sai"),
    resources: 
        mem_mb=100000,
    conda:
        "../envs/bwa.yaml"
    shell:
        # BWA Mapping:
        """
        bwa aln {input.ref} {input.r1} > {output.sai1}
        bwa aln {input.ref} {input.r2} > {output.sai2}

        bwa sampe {input.ref} {output.sai1} {output.sai2} {input.r1} {input.r2} > {output.sam_out}
        """

# rule map_reads_SE_greater_70bp:
#     input:
#         se_reads = Path(config["output"]["trimmed_reads"]) / "{sample}_trimmed.fastq",
#         ref = Path(config["output"]["concat_genome"]["concat_genome_file"]),
#     output:
#         temp(Path(config["output"]["mapped_reads"]) / "{sample}_mapped.sam"),  # temp() temporarily keeps SAMs until converted
#     resources:
#         mem_mb=100000,
#     conda:
#         "../envs/bwa.yaml"
#     shell:
#         # BWA Mapping:
#         """
#         bwa index {input.ref}
#         bwa mem {input.ref} {input.se_reads} > {output}
#         """

rule index_genome:
    input:
        ref = path_dict["concat_genome"]["concat_genome_file"]
    output:
        touch(path_dict["concat_genome"]["concat_genome_done"]),
    resources:
        mem_mb=10000,
    conda:
        "../envs/bwa.yaml"
    shell:
        "bwa index {input.ref}"


# rule map_reads_SE_less_70bp:
#     input:
#         se_reads = Path(config["output"]["trimmed_reads"]) / "{sample}_trimmed.fastq",
#         ref = Path(config["output"]["concat_genome"]["concat_genome_file"]),
#         indexing = Path(config["output"]["concat_genome"]["concat_genome_done"])
#     output:
#         sam = temp(Path(config["output"]["mapped_reads"]) / "{sample}_mapped.sam"),  # temp() temporarily keeps SAMs until converted
#         index = temp(Path(config["output"]["trimmed_reads"]) / "{sample}_trimmed.sai"),
#     resources:
#         mem_mb=100000,
#     conda:
#         "../envs/bwa.yaml"
#     shell:
#         # BWA Mapping:
#         """
#         bwa aln {input.ref} {input.se_reads} > {output.index}
#         bwa samse {input.ref} {output.index} {input.se_reads} > {output.sam}
#         """
