# !/bin/bash
database=/public/caiyuanshi/bioinfo_software/busco_database

python /public/caiyuanshi/miniconda3/envs/assembly/bin/quast Mcin.chr.fasta -t 8 -o quast/
busco -i Mcin.chr.fasta -o busco -m genome --augustus --offline -l ${database}/insecta_odb10 -c 24
