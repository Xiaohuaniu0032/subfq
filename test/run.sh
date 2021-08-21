fq1='/path/to/202111_R1.fq.gz'
fq2='/path/to/202111_R2.fq.gz'
fa='/path/to/hg19.fasta'
num=1000000
bed='/path/to/target.bed'

perl /home/fulongfei/git_repo/subfq/subfq.pl -fq1 $fq1 -fq2 $fq2 -num $num -fa $fa -o $PWD -n ILMN -bed $bed
