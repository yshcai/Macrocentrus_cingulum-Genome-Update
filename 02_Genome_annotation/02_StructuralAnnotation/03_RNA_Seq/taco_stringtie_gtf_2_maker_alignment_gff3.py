###############################
# Data: 2024-05-04
# Title: taco_gtf_2_maker_alignment_gff3
# Aim: to format taco gtf as alignment-based gff3 needed by maker
# Source: Enosh
###############################

import sys
import re

if len(sys.argv) != 2:
    print(
        "\nUSAGE: \npython3 taco_gtf_2_maker_alignment_gff3 <taco GTF file>\n"
    )
    exit()

gff_filename = sys.argv[1]

with open(gff_filename, "rt") as fi:
    # Read the first line
    while True:
        line = fi.readline().strip()
        if not line:
            break
        elif not line.startswith('#'):  # filter the annotation line
            elements = line.split("\t")
            if elements[2] == "transcript":
                i = 1
                elements[2] = "match"
                ID = eval(re.findall(r'transcript_id (.*?);', elements[-1])[0])
                Name = eval(re.findall(r'transcript_id (.*?);', elements[-1])[0])
                elements[-1] = 'ID=' + ID + ';' + 'Name=' + Name
                print('\t'.join(elements))
            elif elements[2] == "exon":
                elements[2] = "match_part"
                start = elements[3]
                end = elements[4]
                strand = elements[6]
                ID = eval(re.findall(r'transcript_id (.*?);', elements[-1])[0]) + '.exon' + str(i)
                i += 1
                Parent = eval(re.findall(r'transcript_id (.*?);', elements[-1])[0])
                Target = eval(re.findall(r'transcript_id (.*?);', elements[-1])[0])
                if 'exon1' in ID:
                    tl = 1
                    tr = int(end) - int(start) + 1
                else:
                    tl = tr + 1
                    tr = tl + int(end) - int(start)
                elements[-1] = 'ID=' + ID + ';' + 'Parent=' + Parent + ';' + 'Target=' + Target + ' ' \
                               + str(tl) + ' ' + str(tr) + ' ' + strand
                print('\t'.join(elements))
        else:
            continue
