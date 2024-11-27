# !/bin/bash
fasta=/share/home/nxy1hj2cys/hifi/t2t_mcin/3.Chromosome/Mcin.chr.fasta

cat Insecta_RepBase.fasta Mcin.chr.fasta.mod.EDTA.TElib.fa > TElib.fa
RepeatMasker -e rmblast -pa 8 -lib TElib.fa -xsmall -html -gff $fasta
