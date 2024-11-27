# Refer to https://github.com/meiyang12/Genome-annotation-pipeline/blob/main/scripts/Collect_no_alt.py
from sys import argv
import re

pep_dict = {}
for x in open(argv[1]):
    x = x.strip()
    if x.startswith('>'):
        tmp_id = x[1:]
        pep_dict[tmp_id] = []
    else:
        pep_dict[tmp_id].append(x)

cds_dict = {}
for x in open(argv[2]):
    x = x.strip()
    if x.startswith('>'):
        tmp_id = x[1:]
        cds_dict[tmp_id] = []
    else:
        cds_dict[tmp_id].append(x)

exon_dict = {}
for x in open(argv[3]):
    x = x.strip()
    if x.startswith('>'):
        tmp_id = x[1:].split(' ')[0]
        exon_dict[tmp_id] = []
    else:
        exon_dict[tmp_id].append(x)

pep_len = {}
for x in pep_dict:
    gene_id = x.split('.')[0]
    pep_id = x
    pep_seq = ''.join(pep_dict[x])
    pep_length = len(pep_seq)
    if gene_id not in pep_len:
        pep_len[gene_id] = {}
        pep_len[gene_id][pep_id] = pep_length
    else:
        pep_len[gene_id][pep_id] = pep_length

longest_pep = {}
for x in pep_len:
    max_pep = max(pep_len[x], key=pep_len[x].get)
    longest_pep[max_pep] = 1

gff = open('no_alt.gff', 'w')
for x in open(argv[4]):
    x = x.strip()
    if 'gene' in x:
        print(x, file=gff)
    elif 'mRNA' in x:
        tmp_id = re.findall(r'ID=(.*?);', x)
        if tmp_id[0] in longest_pep:
            print(x, file=gff)
    elif 'mRNA' not in x:
        if x.split('=')[-1] in longest_pep:
            print(x, file=gff)

pep = open('pep_no_alt.fa', 'w')
cds = open('cds_no_alt.fa', 'w')
exon = open('exon_no_alt.fa', 'w')
for x in longest_pep:
    print('>' + x + '\n' + ''.join(pep_dict[x]), file=pep)
    print('>' + x + '\n' + ''.join(cds_dict[x]), file=cds)
    print('>' + x + '\n' + ''.join(exon_dict[x]), file=exon)
pep.close()
cds.close()
exon.close()
gff.close()
