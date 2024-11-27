# !/bin/bash
GENOME=/public/caiyuanshi/hifi/t2t_mcin/3.Chromosome/Mcin.chr.fasta
RAWDATADIR=./00.raw_data
CLEANDATADIR=./01.cleandata
ALIGN=./02.align
GTF=./03.stringtie
MERGE=./04.taco_merge
TRANS=./05.transdecoder
PE=./00.raw_data/sample.list
PFAM=/public/caiyuanshi/bioinfo_software/transdecoder/TransDecoder/database/Pfam-A.hmm
UNSP=/public/caiyuanshi/bioinfo_software/transdecoder/TransDecoder/database/uniprot_sprot.fasta
UTIL=/public/caiyuanshi/bioinfo_software/transdecoder/TransDecoder/util

# creat drectories
for i in "$CLEANDATADIR" "$ALIGN" "$GTF" "$MERGE" "$TRANS"
do
	if [ ! -d $i ];then
		mkdir -p $i
	fi
done

# fastq filtering

for id in `cat $PE`
do
	fastp -i $RAWDATADIR/${id}_1.fq.gz -I $RAWDATADIR/${id}_2.fq.gz -o ${CLEANDATADIR}/${id}_1.fastq.gz -O ${CLEANDATADIR}/${id}_2.fastq.gz \
		--detect_adapter_for_pe --thread 16 --json ${CLEANDATADIR}/${id}.json --html ${CLEANDATADIR}/${id}.html 1> ${CLEANDATADIR}/${id}_fastp.log 2>&1
done

# hisat2 alignment

# index bulid
if [ -e "$ALIGN/genome.1.ht2" ];then
       echo "HISAT2 index already exists."
else
       echo "HISAT2 index does not exist. Building index"
       hisat2-build -p 12 $GENOME $ALIGN/genome
       echo "Index build completed."
fi
# align
for id in `cat $PE`
do
       hisat2 --dta -p 12 -x $ALIGN/genome -1 ${CLEANDATADIR}/${id}_1.fastq.gz -2 ${CLEANDATADIR}/${id}_2.fastq.gz \
               --summary-file $ALIGN/${id}_alignstat | samtools sort -@ 6 -o $ALIGN/${id}.bam -
done

# stringtie
for id in `cat $PE`
do
       stringtie $ALIGN/${id}.bam -p 12 -o ${GTF}/${id}.gtf -l ${id}
done

# taco
cd $MERGE
taco_run -p 12 `ls ../03.stringtie/*.gtf`
cd ..

# extract fasta sequence based on the gtf file and genome file
$UTIL/gtf_genome_to_cdna_fasta.pl $MERGE/assembly.gtf $GENOME > transcripts.fasta
mv transcripts.fasta 05.transdecoder/

# convert gtf to gff3
$UTIL/gtf_to_alignment_gff3.pl $MERGE/assembly.gtf > transcripts.gff3
mv transcripts.gff3 05.transdecoder/

# extract the long open reading frames
cd 05.transdecoder/
TransDecoder.LongOrfs -t transcripts.fasta

# blastp
blastp -query transcripts.fasta.transdecoder_dir/longest_orfs.pep -db $UNSP \
        -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 16 > blastp.outfmt6
# pfam
hmmsearch --cpu 16 -E 1e-10 --domtblout pfam.domtblout $PFAM transcripts.fasta.transdecoder_dir/longest_orfs.pep

# Integrating the Blast and Pfam search results into coding region selection
TransDecoder.Predict -t transcripts.fasta --retain_pfam_hits pfam.domtblout --retain_blastp_hits blastp.outfmt6

# generate a genome-based coding region annotation file
$UTIL/cdna_alignment_orf_to_genome_orf.pl transcripts.fasta.transdecoder.gff3 transcripts.gff3 transcripts.fasta > transcripts.fasta.transdecoder.genome.gff3

##### convert gene structure gff3 to alignment gff3 required by maker #####
python3 taco_stringtie_gtf_2_maker_alignment_gff3.py assembly.format.gtf > taco_merge.alignment.gff3
gffread -T transcripts.fasta.transdecoder.genome.gff3 > transcripts.fasta.transdecoder.genome.gtf
python3 transdecoder_gtf_2_maker_alignment_gff3.py transcripts.fasta.transdecoder.genome.gtf > transdecoder_alignment.gff3
