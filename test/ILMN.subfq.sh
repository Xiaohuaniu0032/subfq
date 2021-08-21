perl /home/fulongfei/git_repo/subfq/bin/extract_fq.pl /path/to/202111_R1.fq.gz /path/to/202111_R2.fq.gz 1000000 ILMN /home/fulongfei/git_repo/subfq/test

bwa mem -M -R "@RG\tID:ILMN\tSM:ILMN\tPL:illumina" /path/to/hg19.fasta /home/fulongfei/git_repo/subfq/test/ILMN.subfq.R1.gz /home/fulongfei/git_repo/subfq/test/ILMN.subfq.R2.gz | samtools view -bS - >/home/fulongfei/git_repo/subfq/test/ILMN.bam

samtools sort -o /home/fulongfei/git_repo/subfq/test/ILMN.sort.bam /home/fulongfei/git_repo/subfq/test/ILMN.bam

/home/fulongfei/git_repo/subfq/bin/sambamba markdup -t 6 --tmpdir /home/fulongfei/git_repo/subfq/test /home/fulongfei/git_repo/subfq/test/ILMN.sort.bam /home/fulongfei/git_repo/subfq/test/ILMN.sort.markdup.bam

samtools index /home/fulongfei/git_repo/subfq/test/ILMN.sort.markdup.bam

/home/fulongfei/git_repo/subfq/bin/sambamba depth region -L /path/to/target.bed /home/fulongfei/git_repo/subfq/test/ILMN.sort.markdup.bam -t 12 >/home/fulongfei/git_repo/subfq/test/ILMN.target.depth.txt 2>/home/fulongfei/git_repo/subfq/test/ILMN.depth.log

perl /home/fulongfei/git_repo/subfq/bin/cal_theory_depth.pl /path/to/target.bed 100 1000000
