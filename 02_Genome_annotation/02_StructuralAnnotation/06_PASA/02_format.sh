# !/bin/bash
genome=/share/home/nxy1hj2cys/hifi/t2t_mcin/3.Chromosome/Mcin.chr.fasta

##### format gff3 updated by PASA #####
python3 PASA_GFF_Rename.py blat.Mcin_mydb_pasa.sqlite.gene_structures_post_PASA_updates.3879758.gff3 McOGS Mcin.pasa_updates.gff3

##### get fasta file #####
source /share/home/nxy1hj2cys/miniconda3/bin/activate rnaseq
gffread Mcin.pasa_updates.gff3 -g $genome -w Mcin.pasa_updates.exon.fa -x Mcin.pasa_updates.cds.fa -y Mcin.pasa_updates.pep.fa
