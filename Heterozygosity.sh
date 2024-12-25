# 个体杂合度，可以分染色体计算后相加
# Consortium, 2020, nature

# heterozygosity = heterozygous calls / the whole callable genome

# 1. heterozygous calls: Heterozygous sites with GQ>10 && QUAL>30
call_het=`zcat sample.g.vcf.gz |awk '/^#/{next} $5!="<NON_REF>"&&$6>30 {print $10}'| awk -F":" '$4>10 {print $1}'| awk -F"/" '$1!=$2||$1!=$3||$1!=$4||$2!=$3||$2!=$4||$3!=$4'| wc -l`

# 2. the whole callable genome: Sites with GQ>10
call_ref=`zcat sample.g.vcf.gz |awk '/^#/{next} $1!=chr{a=$2;chr=$1;next} $5=="<NON_REF>"{split($NF,z,":");if(z[3]>10)tot+=$2-a; a=$2} END{print tot}'`
call_snp=`zcat sample.g.vcf.gz |awk '/^#/{next} $5!="<NON_REF>"{print $10}'| awk -F":" '$4>10' | wc -l`
Callable_site=`expr $call_ref + $call_snp`

# 杂合度
heterozygosity = call_het / Callable_site
