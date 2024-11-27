# !/bin/bash
cds=/share/home/nxy1hj2cys/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/07.TEsorter/Mcin.pasa_updates.cds.fa
TEsorter=/share/home/nxy1hj2cys/miniconda3/envs/EDTA2/bin/TEsorter
repeatmasker=/share/home/nxy1hj2cys/miniconda3/envs/EDTA2/bin/RepeatMasker
threads=24

# cleanup TE-related sequences in the CDS file with TEsorter
source /share/home/nxy1hj2cys/miniconda3/bin/activate EDTA2
cds=$(basename $cds)
TEsorter -p $threads $cds

# make an initial TE list
source /share/home/nxy1hj2cys/miniconda3/bin/activate seqkit
cat $cds.rexdb.cls.tsv | grep '#' -v | awk -F '\t' '{print$1}' | cut -d '.' -f 1 | sort | uniq | less > $cds.TE.list

# extract gff3 that has been removed TE-related gene
grep -w -f $cds.TE.list \
	Mcin.pasa_updates.gff3 -v | less > Mcin.pasa_updates.noTE.gff3

# sort the gff3
gff3_sort --gff_file Mcin.pasa_updates.noTE.gff3 --sort_template sort_template.txt --output_gff Mcin.pasa_updates.noTE.sorted.gff3
