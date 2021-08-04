#!/bin/bash -l
#SBATCH -A sens2017147
#SBATCH -t 72:00:00
#SBATCH -p core -n 10
#SBATCH -J imp
#SBATCH -o imp_%j.out
#SBATCH -e imp_error_%j.error
#SBATCH --mail-user susmita.malwade@ki.se
#SBATCH --mail-type=ALL
#SBATCH --get-user-env

module load bioinfo-tools
module load samtools/1.10
module load bcftools/1.10
module load plink/1.90b4.9
module load java/OpenJDK_11.0.2

Input="/home/susmita/kasp/kasp/Imputation/C4/vcf_files/raw/*.vcf.gz"
for f in $Input
do 
echo "Processing $f file..."
vcf="$f"
out="/home/susmita/kasp/kasp/Imputation/C4/out/$(basename -s .clean.dedup.recal.bam.raw.annotated.vcf.gz $f)"
build=37
declare -A reg=( ["37"]="6:24894177-33890574" ["38"]="chr6:24893949-33922797" )

bcftools view --no-version "$vcf" -r ${reg[$build]} | \
  java -Xmx16g -jar /home/susmita/kasp/kasp/Imputation/C4/res/beagle.25Nov19.28d.jar gt=/dev/stdin \
  ref=/home/susmita/kasp/kasp/Imputation/C4/res/MHC_haplotypes_CEU_HapMap3_ref_panel.GRCh$build.vcf.gz out="$out" \
  map=<(bcftools query -f "%CHROM\t%POS\n" "/home/susmita/kasp/kasp/Imputation/C4/res/MHC_haplotypes_CEU_HapMap3_ref_panel.GRCh$build.vcf.gz" | \
  awk '{print $1"\t.\t"$2/1e7"\t"$2}')

done
