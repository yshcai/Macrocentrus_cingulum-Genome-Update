#!/bin/bash
#SBATCH --partition=x86_64_2cpu
#SBATCH --job-name=autohic
#SBATCH --nodes=1
#SBATCH --output=slurm.%j.out
#SBATCH --error=slurm.%j.err
#SBATCH --nodelist=2cpu-n36

# run container
singularity exec /share/home/nxy1hj2cys/bioinfo/autohic/autohic_container.sif bash -c "
	/home/autohic/miniconda3/bin/conda init bash
	source ~/.bashrc
	conda activate autohic
	/home/autohic/3d-dna/run-asm-pipeline-post-review.sh \
        -r /share/home/nxy1hj2cys/hifi/t2t_mcin/2.Assembly/scaffold/autohic/result/AutoHiC/autohic_results/chromosome/Mcin_WL302.final.review.assembly --sort-output \
        /share/home/nxy1hj2cys/hifi/t2t_mcin/2.Assembly/scaffold/autohic/Macrocentrus_cingulum/references/Mcin_WL302.fa \
        /share/home/nxy1hj2cys/hifi/t2t_mcin/2.Assembly/scaffold/autohic/result/AutoHiC/hic_results/juicer/Mcin_WL302/aligned/merged_nodups.txt
"