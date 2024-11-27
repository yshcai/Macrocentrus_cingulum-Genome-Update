# !/bin/bash
GENOME=/public/caiyuanshi/hifi/t2t_mcin/4.Annotation/01_RepeatMask/Mcin.chr.fasta.masked
PROTEIN=/public/caiyuanshi/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/01.braker/Arthropoda.fa
RESULT=/public/caiyuanshi/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/01.braker/out
BAM=/public/caiyuanshi/hifi/t2t_mcin/4.Annotation/02_StructuralAnnotation/03.RNA_Seq-based/02.align

if [ ! -d $RESULT ]; then
        mkdir -p $RESULT
fi

# run with RNA-Seq and protein data
braker.pl --species=Mcin \
	--genome=$GENOME \
	--prot_seq=$PROTEIN \
	--threads 48 --gff3 --workingdir=out \
	--GENEMARK_PATH=/public/caiyuanshi/bioinfo_software/genemark/GeneMark-ETP/bin/ \
	--PROTHINT_PATH=/public/caiyuanshi/bioinfo_software/genemark/GeneMark-ETP/bin/gmes/ProtHint/bin/
