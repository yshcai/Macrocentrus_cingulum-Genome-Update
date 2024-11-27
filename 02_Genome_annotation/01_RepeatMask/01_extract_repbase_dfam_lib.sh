# !/bin/bash
dir=/share/home/nxy1hj2cys/hifi/t2t_mcin/4.Annotation/01_RepeatMask
repeatmasker=/share/home/nxy1hj2cys/miniconda3/envs/repeatmask/share/RepeatMasker

for i in '01_RepDfam.lib' '02_EDTA' '03_generate_masked_fa'
do
  if [ ! -d $dir/$i ];then
    mkdir -p $dir/$i
  fi
done

##### activate conda environment #####
source /share/home/nxy1hj2cys/miniconda3/bin/activate repeatmask

##### repbase build #####
cd $dir/01_RepDfam.lib
$repeatmasker/famdb.py -i $repeatmasker/Libraries/RepeatMaskerLib.h5 families --format fasta_name -ad 'Insecta' --include-class-in-name | less > Insecta_RepBase.fasta
echo "repbase build done!"
