#!/bin/sh
#SBATCH --account=gdtheisenlab
#SBATCH --error=slurmOut/CountSample.out
#SBATCH --output=slurmOut/CountSample.out
#SBATCH --mem=1G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name countSample
#SBATCH --wait
#SBATCH --array=0-71
#SBATCH --time=1-00:00:00
#SBATCH --mail-user=matthew.cannon@nationwidechildrens.org
#SBATCH --mail-type=FAIL,REQUEUE,TIME_LIMIT_80

set -e ### stops bash script if line ends with error

echo ${HOSTNAME} ${SLURM_ARRAY_TASK_ID}

module purge

inputPath=/home/gdkendalllab/lab/raw_data/fastq/2021_10_07

fileArray=(${inputPath}/[hmW]*/*fastq.gz)

zgrep -Hc "" ${fileArray[${SLURM_ARRAY_TASK_ID}]} | \
    perl -pe 's/:/\t/' | \
    awk -F "\t" 'BEGIN {OFS = "\t"} {print $1, $2 / 4}' \
  >> output/counts/inputCount.txt

