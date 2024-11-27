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
	python3.9 autohic.py -c cfg-autohic.txt
"