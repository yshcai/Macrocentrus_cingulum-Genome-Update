# !/bin/bash
Genome=/public/caiyuanshi/hifi/t2t_mcin/3.Chromosome/Mcin.chr.fasta
Reference=/public/caiyuanshi/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/02.homology-based/reference
Threads=10
Align=/public/caiyuanshi/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/03.RNA_Seq-based/02.align
database=/public/caiyuanshi/bioinfo_software/busco_database
GeMoMa=/public/caiyuanshi/bioinfo_software/gemoma

# run GeMoMa Pipeline
#mkdir result
java -Xms50G -Xmx150G -jar $GeMoMa/GeMoMa-1.9.jar CLI GeMoMaPipeline threads=$Threads outdir=result/ GeMoMa.Score=ReAlign AnnotationFinalizer.r=NO p=true o=true tblastn=false t=$Genome \
s=own i=Cflo a=$Reference/Copidosoma_floridanum/GCF_000648655.2_Cflo_2.0_genomic.gff g=$Reference/Copidosoma_floridanum/GCF_000648655.2_Cflo_2.0_genomic.fna \
s=own i=Cglo a=$Reference/Cotesia_glomerata/GCF_020080835.1_MPM_Cglom_v2.3_genomic.gff g=$Reference/Cotesia_glomerata/GCF_020080835.1_MPM_Cglom_v2.3_genomic.fna \
s=own i=Dmel a=$Reference/Drosophila_melanogaster/GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.gff g=$Reference/Drosophila_melanogaster/GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna \
s=own i=Mdem a=$Reference/Microplitis_demolitor/GCF_026212275.2_iyMicDemo2.1a_genomic.gff g=$Reference/Microplitis_demolitor/GCF_026212275.2_iyMicDemo2.1a_genomic.fna \
s=own i=Nvit a=$Reference/Nasonia_vitripennis/GCF_009193385.2_Nvit_psr_1.1_genomic.gff g=$Reference/Nasonia_vitripennis/GCF_009193385.2_Nvit_psr_1.1_genomic.fna

# run busco
source /share/home/nxy1hj2cys/miniconda3/bin/activate busco
busco -i result/predicted_proteins.fasta -o busco --out_path result/ -m proteins --augustus --offline -l ${database}/insecta_odb10 -c 8

source /share/home/nxy1hj2cys/miniconda3/bin/activate gemoma
GeMoMa Extractor Ambiguity=AMBIGUOUS p=true g=$Genome a=result/final_annotation.gff l=true
mv assignment.tabular result/
GeMoMa BUSCORecomputer b=result/busco/run_insecta_odb10/full_table.tsv i=result/assignment.tabular outdir=result/

##### convert gene structure gff3 to alignment gff3 required by maker #####
cd result/
python3 gemoma_gff3_2_maker_alignment_gff3.py final_annotation.gff > gemoma.protein_alignment.gff3