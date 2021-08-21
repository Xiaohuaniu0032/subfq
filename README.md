# subfq
downsampling reads from fastq1/2 files

# Usage
`perl /home/fulongfei/git_repo/subfq/subfq.pl -fq1 $fq1 -fq2 $fq2 -num $num -fa $fa -o $PWD -n ILMN -bed $bed`

`-fq1`: fq1 file
`-fq2`: fq2 file
`-num`: reads num to extract
`-len`: read length
`-n`  : name
`-fa` : ref fasta
`-bed`: BED file
`-o`  : output dir

# Output file
the output file is <name>.subfq.sh. you can `sh *.subfq.sh &` directly on linux.

# Steps
1) downsamping
2) bwa aln and convert SAM into BAM
3) samtools sort
4) markdup
5) samtools index
6) calculate target depth (need BED file)
7) calculate the theory depth based on: a)reads num; b)read length; c)target length

### Infer the theory depth based on the downsampled reads
A: theory depth = read_length * reads_num / target_length_bp

### Infer how many reads you should extract when you want to get a certain depth?
A: reads_num = target_length_bp * wanted_depth / target_length_bp
you can use `subfq/bin/reads2depth.pl` to calculate how many reads you should to extract.

##### Example
`perl /path/subfq/bin/reads2depth.pl 100 20`
`100`: read length
`20`: I want to get 20X mean coverage

```
perl /home/fulongfei/git_repo/subfq/bin/reads2depth.pl target.bed 100 20

# Below lines are STDOUT
BED file has 7964 targets
BED file length is 1763632(bp)
to get theory depth 20X, you should extract 352726 reads (100 bp)
```
