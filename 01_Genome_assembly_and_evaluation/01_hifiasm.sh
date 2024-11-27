# !/bin/bash

ccs=/public/caiyuanshi/hifi/t2t_mcin/1.HiFireads/filter_adapter/Mcin_WL302.ccs.filt.fastq.gz
asm=/public/caiyuanshi/hifi/t2t_mcin/2.Assembly
fasta=/public/caiyuanshi/hifi/t2t_mcin/2.Assembly/contig_fasta
database=/public/caiyuanshi/bioinfo_software/busco_database
fastq=/public/caiyuanshi/hifi/hic/ANNO_ANCGD180475_PM-ANCGD180475-17_2022-07-06_17-51-30_BHJCVYDSX3/Rawdata/M411

# HiFi-only mode
## l0 parameters
mkdir -p $fasta/hifi_only_l0/busco
output=$fasta/hifi_only_l0
hifiasm -o ${asm}/Mcin_WL302.asm -l0 -t32 ${ccs} &>$output/run_hifisam.log

for i in `ls $asm/*.p_ctg.gfa`
do
        awk '/^S/{print ">"$2;print $3}' $i > $output/${i##*/}.fa
        python /public/caiyuanshi/miniconda3/envs/assembly/bin/quast $output/${i##*/}.fa -t 8 -o $output/quast/${i##*/}.fa
        busco -i $output/${i##*/}.fa -o ${i##*/}.fa --out_path $output/busco/ -m genome --augustus --offline -l ${database}/insecta_odb10 -c 8
done
