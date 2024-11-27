# !/bin/bash

##### activate conda environment #####
source /public/caiyuanshi/miniconda3/bin/activate pbccs

##### extract ccs reads #####
nohup ccs raw.subreads.bam ccs.fastq.gz --min-passes 3 \
--report-file ccs_report.txt --log-file ccs.log -j 32 &
