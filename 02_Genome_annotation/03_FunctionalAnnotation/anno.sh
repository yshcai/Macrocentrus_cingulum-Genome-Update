# !/bin/bash
swissprot=/public/caiyuanshi/bioinfo_software/blastdb/swissprot/diamond
nr=/public/caiyuanshi/bioinfo_software/blastdb/nr/diamond_nr_db
query=/public/caiyuanshi/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/08.Final/Macrocentrus_cingulum.pep.no_alt.fa
tmp=/public/caiyuanshi/hifi/t2t_mcin/4.Annotation/03_FunctionalAnnotation/tmp

##### swissprot #####
diamond blastp --query $query --db $swissprot/swissprot \
--outfmt 6 qseqid qlen sseqid slen pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle \
--evalue 1e-5 --max-target-seqs 1 --max-hsps 1 \
--block-size 20 --index-chunks 1 --tmpdir $tmp --more-sensitive \
--threads 16 \
--out Mcin_blast_swissprot.more_sensitive.outfmt6

##### nr #####
diamond blastp --query $query --db $nr/nr \
--outfmt 6 qseqid qlen sseqid slen pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle \
--evalue 1e-5 --max-target-seqs 1 --max-hsps 1 \
--block-size 20 --index-chunks 1 --tmpdir $tmp --more-sensitive \
--threads 16 \
--out Mcin_blast_nr.more_sensitive.outfmt6

##### interpro #####
/interproscan.sh \
-cpu 4 -dp \
-appl CDD,Pfam \
-i Macrocentrus_cingulum.pep.no_alt.fa -f tsv \
-b McOGS.interpro

##### eggnog #####
http://eggnog-mapper.embl.de/
