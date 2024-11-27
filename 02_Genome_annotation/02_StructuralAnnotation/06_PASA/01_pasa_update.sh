genome=/share/home/nxy1hj2cys/hifi/t2t_mcin/3.Chromosome/Mcin.chr.fasta
trans=/share/home/nxy1hj2cys/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/03.RNA_Seq-based/05.transdecoder/transcripts.fasta.transdecoder.genome.gtf
threads=16
pasa=/share/home/nxy1hj2cys/miniconda3/envs/evm/opt/pasa-2.5.3
transdecoder=/share/home/nxy1hj2cys/miniconda3/envs/evm/opt/transdecoder
maker=/share/home/nxy1hj2cys/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/05.MAKER/Mcin.maker.output/Mcin.maker.only.final.gff3
work=/share/home/nxy1hj2cys/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/06.PASA

# Running the Alignment Assembly Pipeline
# 1. cleaning the transcript sequences
mkdir 01.seqclean && cd 01.seqclean
$transdecoder/util/gtf_genome_to_cdna_fasta.pl $trans $genome > transcripts.fasta
$pasa/bin/seqclean transcripts.fasta
cd $work

# 2. transcript alignments followed by alignment assembly
mkdir -p 02.alignment_assembly/database.sqlite && cd 02.alignment_assembly

cp $pasa/pasa_conf/pasa.alignAssembly.Template.txt alignAssembly.config
sed -i "s#^DATABASE=<__DATABASE__>#DATABASE=$work/02.alignment_assembly/database.sqlite/blat.Mcin_mydb_pasa.sqlite#g" alignAssembly.config
sed -i 's#--MIN_PERCENT_ALIGNED=<__MIN_PERCENT_ALIGNED__>#--MIN_PERCENT_ALIGNED=80#' alignAssembly.config
sed -i 's#--MIN_AVG_PER_ID=<__MIN_AVG_PER_ID__>#--MIN_AVG_PER_ID=80#' alignAssembly.config

$pasa/Launch_PASA_pipeline.pl \
       -c alignAssembly.config -C -R -g $genome \
       -t $work/01.seqclean/transcripts.fasta.clean -T -u $work/01.seqclean/transcripts.fasta \
       --ALIGNERS blat --CPU $threads
cd $work
echo 'PASA alignment assembly done!!!'

# PASA genome annotation
mkdir 03.update_annotation && cd 03.update_annotation
# 1. check gff3
$pasa/misc_utilities/pasa_gff3_validator.pl $maker

# 2. edit annotation config
cp $pasa/pasa_conf/pasa.annotationCompare.Template.txt annotCompare.config
sed -i "s#^DATABASE=<__DATABASE__>#DATABASE=$work/02.alignment_assembly/database.sqlite/blat.Mcin_mydb_pasa.sqlite#g" annotCompare.config
# replaced the DATABASE=<MYSQLDB> line with DATABASEB='sample_mydb_pasa' as before with the alignAssembly.config file
# Notice this config file contains numerous parameters that can be modified to tune the process to any genome of interest

# 3. Performing an annotation comparison and generating an updated gene set
# round1
mkdir round1 && cd round1
# load annotations into the PASA database
$pasa/scripts/Load_Current_Gene_Annotations.dbi \
        -c $work/02.alignment_assembly/alignAssembly.config -g $genome \
        -P $maker
# annotation comparison
$pasa/Launch_PASA_pipeline.pl \
        -c $work/03.update_annotation/annotCompare.config -A \
	-g $genome \
	-t $work/01.seqclean/transcripts.fasta.clean --CPU 16
cd $work/03.update_annotation/
echo 'PASA update round 1 done!!!'

# round2
mkdir round2 && cd round2
# load annotations into the PASA database
$pasa/scripts/Load_Current_Gene_Annotations.dbi \
        -c $work/02.alignment_assembly/alignAssembly.config -g $genome \
        -P $work/03.update_annotation/round1/*.gff3
# annotation comparison
$pasa/Launch_PASA_pipeline.pl \
        -c $work/03.update_annotation/annotCompare.config -A \
	-g $genome \
        -t $work/01.seqclean/transcripts.fasta.clean --CPU 16
cd $work/03.update_annotation/
echo 'PASA update round 2 done!!!'
