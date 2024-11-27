# !/bin/bash
RAWDATADIR=./00.raw_data

for id in `cat $RAWDATADIR/ncbi_sra.txt`
do
	fasterq-dump --split-3 $RAWDATADIR/${id} -e 12 -O $RAWDATADIR --seq-defline '@$ac.$si $sn/$sg/$ri' --qual-defline '+'
        pigz -p 12 -k $RAWDATADIR/${id}_1.fq
        pigz -p 12 -k $RAWDATADIR/${id}_2.fq
done
