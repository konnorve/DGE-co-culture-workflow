# rule make_results_dir:
#     output:
#         directory(config["results"])
#     shell:
#         "mkdir -p {output}; sleep 1"

# run post-HTseq script
rule generate_counts_metadata_dfs:
    input:
        sample_counts=expand(output_path_dict["feature_count"] / "{sample}.tsv", sample=SAMPLES),
        raw_gff_dir=Path(config["input"]["gff_refs"]),
        condition_table_path=Path(config["samples"]),
        config_yaml_path=Path(config["config"]),
        # results_dir = Path(config["results"]),
        # raw_reads=Path(config["input"]["raw_reads"]),
        # raw_reads_counts=output_path_dict["library_count"],
        # bam_coverages=expand(output_path_dict["coverage_positions"] / "{sample}_coverage_depth.tsv", sample=SAMPLES),
    output:
        counts = results_path_dict['counts'],
        metadata = results_path_dict['metadata'],
        config = results_path_dict['config'],
        samples = results_path_dict['samples'],
    conda:
        "../envs/post_htseq2_parsing.yaml"
    script:
        "../scripts/generate_counts_metadata_dfs.py"

# run post-HTseq script
rule add_kegg_ids_to_count_df:
    input:
        counts = results_path_dict['counts']
    output:
        kegg_refs = results_path_dict['kegg_refs'],
        count_df_updated = touch(output_path_dict['done_files'] / 'kegg_additions.done')
    conda:
        "../envs/post_htseq2_parsing.yaml"
    script:
        "../scripts/add_kegg_ids_to_countdf.py"

# run post-HTseq script
rule generate_results_rlog_dfs:
    input:
        counts = results_path_dict['counts'],
        kegg_refs = results_path_dict['kegg_refs'],
        samples = results_path_dict['samples'],
        count_df_updated = output_path_dict['done_files'] / 'kegg_additions.done'
    output:
        results = results_path_dict['results'],
        rlog = results_path_dict['rlog'],
    conda:
        "../envs/post_htseq2_parsing.yaml"
    script:
        "../scripts/generate_results_rlog_dfs.py"