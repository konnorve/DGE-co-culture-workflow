from pathlib import Path
import pandas as pd
import logging as log
import json
import yaml

log.basicConfig(format='%(levelname)s:%(message)s', level=log.INFO)

counts_df = pd.read_csv(snakemake.input['counts'], sep='\t', header=[0,1], index_col=[0,1,2])
metadata_df = pd.read_csv(snakemake.input['metadata'], sep='\t', header=0, index_col=0)
samples_df = pd.read_csv(snakemake.input['samples'], sep='\t', header=0, index_col=2)
ref_table = pd.read_csv(snakemake.input['ref_table'], sep='\t', index_col=['ref_col','id'])

log.debug(f"counts_df:\n{counts_df}\n\n")
log.debug(f"metadata_df:\n{metadata_df}\n\n")
log.debug(f"samples_df:\n{samples_df}\n\n")
log.debug(f"ref_table:\n{ref_table}\n\n")

all_data = {}

with open("config.yaml") as file:
    all_data['config'] = yaml.load(file, Loader=yaml.FullLoader)

all_data['samples'] = samples_df.to_dict(orient='index')

all_data['metadata'] = metadata_df.to_dict(orient='index')

for ref_col in ref_table.index.unique(level='ref_col'):
    all_data['db lookup'][ref_col] = samples_df.loc[ref_col]['term'].to_dict()


counts_df = counts_df.reset_index(level='type', col_level=1, col_fill='annotation_data')

for organism in counts_df.index.unique(level='organism'):
    all_data['annotation_data'][organism] = counts_df['sample_data'].to_dict(orient='index')
    all_data['count_data'][organism] = counts_df['annotation_data'].to_dict(orient='index')

with open(snakemake.output['data_json'], "w") as outfile:
    json.dump(all_data, outfile)