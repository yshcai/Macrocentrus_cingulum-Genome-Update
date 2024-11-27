# !/bin/bash
fasta=/public/caiyuanshi/hifi/t2t_mcin/2.Assembly/contig_fasta/hifi_only_l0/Mcin_WL302.asm.bp.p_ctg.gfa.fa
out=/public/caiyuanshi/hifi/t2t_mcin/2.Assembly/contig_fasta/hifi_only_l0/fcsgx
db=/public/caiyuanshi/bioinfo_software/fcsgx/database/gxdb

export FCS_DEFAULT_IMAGE=fcs-gx.sif
python3 /public/caiyuanshi/bioinfo_software/fcsgx/fcs.py screen genome --fasta $fasta --out-dir $out --gx-db $db --tax-id 535359
