# Title: gemoma_gff3_2_maker_alignment_gff3
# Aim: to format gemoma gff3 as alignment-based gff3 needed by maker
# Source: Enosh
###############################

import sys
import re

if len(sys.argv) != 2:
    print(
        "\nUSAGE: \npython3 gemoma_gff3_2_maker_alignment_gff3 <gemoma.gff3>\n"
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
            if elements[2] == "mRNA":
                i = 1
                elements[2] = "match"
                ID = re.findall(r'ID=(.*?);', elements[-1])[0]
                Name = re.findall(r'ID=(.*?);', elements[-1])[0]
                elements[-1] = 'ID=' + ID + ';' + 'Name=' + Name
                print('\t'.join(elements))
            elif elements[2] == "CDS":
                elements[2] = "match_part"
                start = elements[3]
                end = elements[4]
                strand = elements[6]
                Parent = re.findall(r'Parent=(.*)', elements[-1])[0]
                Target = re.findall(r'Parent=(.*)', elements[-1])[0]
                ID = re.findall(r'Parent=(.*)', elements[-1])[0] + '.CDS' + str(i)
                i += 1
                if 'CDS1' in ID:
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
