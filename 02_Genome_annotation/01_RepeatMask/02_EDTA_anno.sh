#!/bin/bash
#SBATCH --partition=x86_64_2cpu
#SBATCH --job-name=edta
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --nodelist=2cpu-n49

# activate conda environment
source /share/home/nxy1hj2cys/miniconda3/bin/activate EDTA2

# run
EDTA.pl --genome /share/home/nxy1hj2cys/hifi/t2t_mcin/3.Chromosome/Mcin.chr.fasta --species others --step all \
	--cds /share/home/nxy1hj2cys/hifi/t2t_mcin/4.Annotation/01_RepeatMask/02_EDTA/transcripts.fasta.transdecoder.cds \
	--sensitive 1 --anno 1 --threads 24
