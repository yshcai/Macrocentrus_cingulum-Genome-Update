# !/bin/bash
genome=/share/home/nxy1hj2cys/hifi/t2t_mcin/3.Chromosome/Mcin.chr.fasta

##### format gff3 updated by PASA #####
python3 PASA_GFF_Rename.py Mcin.pasa_updates.noTE.sorted.gff3 McOGS Macrocentrus_cingulum.gff3

##### get fasta file #####
source /share/home/nxy1hj2cys/miniconda3/bin/activate rnaseq
gffread Macrocentrus_cingulum.gff3 -g $genome -w Macrocentrus_cingulum.exon.fa -x Macrocentrus_cingulum.cds.fa -y Macrocentrus_cingulum.pep.fa

##### get the longest sequence #####
python3 get_longest_seq.py Macrocentrus_cingulum.pep.fa Macrocentrus_cingulum.cds.fa Macrocentrus_cingulum.exon.fa Macrocentrus_cingulum.gff3
