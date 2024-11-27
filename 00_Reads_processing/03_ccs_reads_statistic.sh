# !/bin/bash
hifireads=/public/caiyuanshi/hifi/t2t_mcin/1.HiFireads/filter_adapter/Mcin_WL302.ccs.filt.fastq.gz

##### simple statistics of FASTA/Q files #####
seqkit stats -a -j 2 $hifireads > Mcin_WL302.ccs.filt.fastq.stats.txt
