#!/bin/bash
#SBATCH --partition=x86_64_2cpu
#SBATCH --job-name=MAKER
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --nodelist=2cpu-n47

# activate conda environment
source /share/home/nxy1hj2cys/miniconda3/bin/activate maker

# run
export LIBDIR=/share/home/nxy1hj2cys/miniconda3/envs/maker/share/RepeatMasker/Matrices
export LIBDIR=/share/home/nxy1hj2cys/miniconda3/envs/maker/share/RepeatMasker/Libraries
mpiexec -n 12 maker -base Mcin -fix_nucleotides maker_bopts.ctl maker_exe.ctl maker_opts.ctl
cd Mcin.maker.output/
gff3_merge -d ./Mcin_master_datastore_index.log -o Mcin.maker.all.gff3
fasta_merge -d ./Mcin_master_datastore_index.log -o Mcin
awk '$2 == "maker"' Mcin.maker.all.gff3 > Mcin.maker.only.gff3

# create naming table (there are additional options for naming beyond defaults)
maker_map_ids --prefix MCIN --justify 6 Mcin.maker.all.gff3 > Mcin.maker.all.name.map
# replace names in GFF files
cp Mcin.maker.all.gff3 Mcin.maker.all.renamed.gff3
cp Mcin.maker.only.gff3 Mcin.maker.only.renamed.gff3
cp Mcin.all.maker.proteins.fasta Mcin.all.maker.proteins.renamed.fasta
cp Mcin.all.maker.transcripts.fasta Mcin.all.maker.transcripts.renamed.fasta
map_gff_ids Mcin.maker.all.name.map Mcin.maker.all.renamed.gff3
map_gff_ids Mcin.maker.all.name.map Mcin.maker.only.renamed.gff3
# replace names in FASTA headers
map_fasta_ids Mcin.maker.all.name.map Mcin.all.maker.proteins.renamed.fasta
map_fasta_ids Mcin.maker.all.name.map Mcin.all.maker.transcripts.renamed.fasta
