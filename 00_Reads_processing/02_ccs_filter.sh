# !/bin/bash
hifireads=/public/caiyuanshi/hifi/t2t_mcin/1.HiFireads/Mcin_WL302.ccs.fastq.gz

##### activate conda environment #####
#source /public/caiyuanshi/miniconda3/bin/activate blast

##### adapter filter #####
/public/caiyuanshi/bioinfo_software/HiFiAdapterFilt/hifiadapterfilt.sh -p Mcin_WL302.ccs -t 16 -o filter_adapter/

