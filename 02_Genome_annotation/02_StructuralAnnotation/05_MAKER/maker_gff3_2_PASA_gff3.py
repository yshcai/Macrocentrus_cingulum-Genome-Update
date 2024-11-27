# Title: maker_gff3_2_PASA_gff3
# Aim: to format maker gff3 needed by pasa
# Source: Enosh
###############################

import sys
import re

if len(sys.argv) != 3:
    print(
        "\nUSAGE: \npython3 maker_gff3_2_PASA_gff3.py <maker.gff3> <maker.pasa.gff3>\n"
    )
    exit()

gff_filename = sys.argv[1]
result = open(sys.argv[2], 'wt')

print("##gff-version 3", file=result)

with open(gff_filename, "rt") as fi:
    # Read the first line
    while True:
        line = fi.readline().strip()
        if not line:
            break
        elif not line.startswith('#'):
            elements = line.split("\t")
            if elements[2] == "gene":
                print('\t'.join(elements), file=result)
            elif elements[2] == "mRNA":
                print('\t'.join(elements), file=result)
            elif elements[2] == "exon":
                attributes = elements[8]
                attr_parts = attributes.split(';')
                for i, attr in enumerate(attr_parts):
                    if attr.startswith('Parent='):
                        parents = attr.split('=')[1].split(',')
                        for children in parents:
                            new_attr_parts = attr_parts.copy()
                            new_attr_parts[i] = f'Parent={children}'
                            id_part = new_attr_parts[0].split('=')[1]
                            new_id = f'ID={children}:{id_part.split(":")[-1]}'
                            new_attr_parts[0] = new_id
                            new_attributes = ';'.join(new_attr_parts)
                            new_elements = elements[:8] + [new_attributes]
                            print('\t'.join(new_elements), file=result)
            elif elements[2] == "five_prime_UTR":
                print('\t'.join(elements), file=result)
            elif elements[2] == "CDS":
                print('\t'.join(elements), file=result)
            elif elements[2] == "three_prime_UTR":
                print('\t'.join(elements), file=result)
            else:
                print(elements)
                continue
        else:
            print(line)

result.close()
