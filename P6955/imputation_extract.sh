#!/bin/bash -l
#SBATCH -A sens2017147
#SBATCH -t 72:00:00
#SBATCH -p core -n 8
#SBATCH -J impext
#SBATCH -o impext_%j.out
#SBATCH -e impext_error_%j.error
#SBATCH --mail-user susmita.malwade@ki.se
#SBATCH --mail-type=ALL
#SBATCH --get-user-env

module load bioinfo-tools
module load samtools/1.10
module load bcftools/1.10
module load plink/1.90b4.9
module load java/OpenJDK_11.0.2

Input="/home/susmita/kasp/kasp/Imputation/C4/out/*.vcf.gz"
for f in $Input
do
out="$f"
build=37 # build=37
declare -A reg=( ["37"]="6:31948000-31948000" ["38"]="chr6:31980223-31980223" )

bcftools index -ft "$out" && \
bcftools query -f "[%SAMPLE\t%ALT\t%GT\n]" "$out" -r ${reg[$build]} | tr -d '[<>]' | \
  awk -F"\t" -v OFS="\t" '{split($2,a,","); a["0"]="NA"; split($3,b,"|"); \
  print $1,a[b[1]],a[b[2]]}' > "$out.tsv"
done
