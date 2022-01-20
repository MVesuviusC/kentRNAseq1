#!/bin/sh
#SBATCH --account=gdkendalllab
#SBATCH --array=0-17
#SBATCH --error=slurmOut/countAligned.txt
#SBATCH --output=slurmOut/countAligned.txt
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --job-name countAligned
#SBATCH --wait
#SBATCH --time=1-00:00:00


module load GCC/9.3.0 \
            SAMtools/1.10

fileArray=(output/aligned/*.bam)

for i in "${!fileArray[@]}"
do
    fileArray[$i]="${fileArray[$i]##output/aligned/}"
    fileArray[$i]="${fileArray[$i]%.bam}"
done

samtools view output/aligned/${fileArray[${SLURM_ARRAY_TASK_ID}]}.bam | \
    cut -f 1 | \
    perlUnique.pl | \
    wc -l \
       > output/aligned/counts/${fileArray[${SLURM_ARRAY_TASK_ID}]##*/}_counts.txt
