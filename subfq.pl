use strict;
use warnings;
use File::Basename;
use Getopt::Long;
use FindBin qw/$Bin/;

my ($fq1,$fq2,$num,$readlen,$name,$fasta,$markdup,$bed,$outdir);

GetOptions(
    "fq1:s" => \$fq1,              # fq1 file                                          [Need]
    "fq2:s" => \$fq2,              # fq2 file                                          [Need]
    "num:i" => \$num,              # how many reads to extract from whole fq           [Need]
    "len:i" => \$readlen,          # read len                                          [Default:100bp]
    "n:s"   => \$name,             # sample name                                       [Need]
    "fa:s"  => \$fasta,            # ref fasta                                         [Need]
    "bed:s" => \$bed,              # BED file. use to calculate target depth           [Optional]
    "o:s"   => \$outdir,           # outdir                                            [Need]
    ) or die "unknown options\n";

if (not defined $fq1 or not defined $fq2 or not defined $num or not defined $name or not defined $outdir){
    die "some args ars not specified, please check\n";
}

if (not defined $readlen){
    $readlen = 100;
}

my $runsh = "$outdir/$name.subfq.sh";
open SH, ">$runsh" or die;

# 1) extract fq
my $cmd = "perl $Bin/bin/extract_fq.pl $fq1 $fq2 $num $name $outdir";
print SH "$cmd\n\n";

# 2) bwa aln & SAM->BAM
my $sub_fq1 = "$outdir/$name\.subfq.R1.gz";
my $sub_fq2 = "$outdir/$name\.subfq.R2.gz";
my $sam = "$outdir/$name\.sam";
my $bam = "$outdir/$name\.bam";

$cmd = "bwa mem -M -R \"\@RG\\tID\:$name\\tSM\:$name\\tPL:illumina\" $fasta $sub_fq1 $sub_fq2 \| samtools view -bS - \>$bam";
print SH "$cmd\n\n";

# 3) samtools sort
my $sort_bam= "$outdir/$name\.sort.bam";
$cmd = "samtools sort -o $sort_bam $bam";
print SH "$cmd\n\n";

# 4) markdup
my $sort_markdup_bam = "$outdir/$name\.sort.markdup.bam";
$cmd = "$Bin/bin/sambamba markdup -t 6 --tmpdir $outdir $sort_bam $sort_markdup_bam";
print SH "$cmd\n\n";

# 5) samtools index
$cmd = "samtools index $sort_markdup_bam";
print SH "$cmd\n";

# 6) cal target depth [optional]
if (defined $bed){
    $cmd = "$Bin/bin/sambamba depth region -L $bed $sort_markdup_bam -t 12 >$outdir/$name\.target.depth.txt 2>$outdir/$name\.depth.log";
    print SH "\n";
    print SH "$cmd\n\n";
}

# 7) cal theory depth based on: 1) reads num; 2) read length; 3) target region
$cmd = "perl $Bin/bin/cal_theory_depth.pl $bed $readlen $num";
print SH "$cmd\n";

close SH;
