#!/bin/sh
fq1='/data/mengxuehong/20210813.FSZ.illumina/202111_R1.fq.gz'
fq2='/data/mengxuehong/20210813.FSZ.illumina/202111_R2.fq.gz'
fa='/data/mengxuehong/20210813.FSZ.illumina/hg19.fasta'
bed='/data/mengxuehong/20210813.FSZ.illumina/Illumina.bed'

od=$PWD
cov=('10X' '20X' '30X' '50X' '70X' '100X' '200X' '500X' '700X' '1000X')
num=(200000 350000 520000 900000 1200000 1800000 3500000 8800000 12000000 18000000)

length=${#cov[@]}
arr=`seq $length`
#echo $arr

for i in ${arr[@]};do
	let idx=i-1
	depth=${cov[$idx]}
	n=${num[$idx]}
	rep=`seq 6`
	for rep in ${rep[@]};do
		#echo "$depth $rep"
		outdir="$od/$depth/rep${rep}"
		echo $outdir
		if [ ! -d "$outdir" ];then
			`mkdir -p $outdir`
		fi
		name="$depth"\_"rep"$rep
		#echo "$depth $n $name"
		`perl /home/fulongfei/git_repo/subfq/subfq.pl -fq1 $fq1 -fq2 $fq2 -num $n -fa $fa -o $outdir -n $name -bed $bed`			
	done
done
