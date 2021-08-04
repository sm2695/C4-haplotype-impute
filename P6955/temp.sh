#!/bin/bash -l

#module load bioinfo-tools
#module load samtools/1.10
#module load bcftools/1.10
#module load plink/1.90b4.9
#module load java/OpenJDK_11.0.2

Input="/home/susmita/kasp/kasp/Imputation/C4/vcf_files/raw/*.vcf.gz"
for f in $Input
do
echo "Processing $f file..."
vcf="$f"
out="/home/susmita/kasp/kasp/Imputation/C4/out/$(basename -s .clean.dedup.recal.bam.raw.annotated.vcf.gz $f)"
echo "$out"
done
