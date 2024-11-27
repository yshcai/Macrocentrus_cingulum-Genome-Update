# Refer to https://github.com/meiyang12/Genome-annotation-pipeline/blob/main/scripts/gff_rename.py
import re
import sys

if len(sys.argv) < 4:
    print('Usage: python3 PASA_GFF_Rename.py <gene_structures_post_PASA_updates.gff3> <Prefix> <custom_name.gff3>')
    sys.exit()

gff = open(sys.argv[1], 'rt')
prf = sys.argv[2]
result = open(sys.argv[3], 'wt')

count = 0
mRNA = 0
cds = 0
exon = 0
five_UTR = 0
three_UTR = 0


print("##gff-version 3", file=result)
for line in gff:
    if not line.startswith("\n") and not line.startswith("#"):
        records = line.split("\t")
        records[1] = "maker"
        if re.search(r"\tgene\t", line):
            count = count + 1
            mRNA = 0
            gene_id = prf + str(count).zfill(6)
            records[8] = "ID={}".format(gene_id)
        elif re.search(r"\tmRNA\t", line):
            cds = 0
            exon = 0
            five_UTR = 0
            three_UTR = 0
            mRNA = mRNA + 1
            mRNA_id = gene_id + "." + str(mRNA)
            records[8] = "ID={};Parent={}".format(mRNA_id, gene_id)
        elif re.search(r"\tfive_prime_UTR\t", line):
            five_UTR = five_UTR + 1
            five_UTR_id = mRNA_id + "_utr5p_"+str(five_UTR)
            records[8] = "ID={};Parent={}".format(five_UTR_id, mRNA_id)
        elif re.search(r"\texon\t", line):
            exon = exon + 1
            exon_id = mRNA_id + "_exon_" + str(exon)
            records[8] = "ID={};Parent={}".format(exon_id, mRNA_id)
        elif re.search(r"\tCDS\t", line):
            cds = cds + 1
            cds_id = mRNA_id + "_cds_" + str(cds)
            records[8] = "ID={};Parent={}".format(cds_id, mRNA_id)
        elif re.search(r"\tthree_prime_UTR\t", line):
            three_UTR = three_UTR + 1
            three_UTR_id = mRNA_id + "_utr3p_"+str(three_UTR)
            records[8] = "ID={};Parent={}".format(three_UTR_id, mRNA_id)
        else:
            print('Please Check Column 3')
    else:
        # print('This line is skipped')
        continue

    # print("\t".join(records))
    print("\t".join(records), file=result)

gff.close()
result.close()
