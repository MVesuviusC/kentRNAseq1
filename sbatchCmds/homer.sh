#!/bin/sh
#SBATCH --account=gdlessnicklab
#SBATCH --array=0-15
#SBATCH --error=slurmOut/homer-%j.txt
#SBATCH --output=slurmOut/homer-%j.txt
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --job-name homer
#SBATCH --wait
#SBATCH --time=0-08:00:00
#SBATCH --mail-user=matthew.cannon@nationwidechildrens.org
#SBATCH --mail-type=FAIL,REQUEUE,TIME_LIMIT_80

set -e ### stops bash script if line ends with error

cmp_list=(output/edgeROut/listDeGenes*.txt)

to_cmp=${cmp_list[${SLURM_ARRAY_TASK_ID}]}
nameStub=${to_cmp##*listDeGenes_}
nameStub=${nameStub%.txt}

findMotifs.pl \
  ${to_cmp} \
  zebrafish \
  output/motif/homerOut/${nameStub} \
  -p 10

