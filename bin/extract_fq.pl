use strict;
use warnings;
use File::Basename;

my ($fq1,$fq2,$num,$name,$outdir) = @ARGV;

print "we will get $num reads from whole fq1/2 files\n";

# cal whole fq reads num
my $fq1_reads_num = int(`zcat $fq1 | wc -l`/4);
print "whole fq1 reads num is: $fq1_reads_num\n";

if ($num > $fq1_reads_num){
    print "[Warning:] the largest reads num you can get from whole fq is: $fq1_reads_num\n";
    $num = $fq1_reads_num;
}

my %sample_line_idx;
for my $i (1..$num){
    while(1){
        my $rand_num = int(rand($fq1_reads_num)) + 1; # [1,num]
        if (!exists $sample_line_idx{$rand_num}){
            $sample_line_idx{$rand_num} = 1;
            last; # end while loop
        }else{
            next; # redo while loop
        }
    }
}


# output files
my $sub_fq1 = "$outdir/$name\.subfq.R1.gz";
my $sub_fq2 = "$outdir/$name\.subfq.R2.gz";

if (-e $sub_fq1){
    `rm $sub_fq1`;
}
if (-e $sub_fq2){
    `rm $sub_fq2`;
}

open O1, "|gzip >$sub_fq1" or die;
open O2, "|gzip >$sub_fq2" or die;

my $line = 0;
open FQ1, "gunzip -dc $fq1 |" or die;
while (<FQ1>){
    my $header = $_;
    my $seq = <FQ1>;
    <FQ1>;
    my $qual = <FQ1>;
    $line += 1;
    if (exists $sample_line_idx{$line}){
        print O1 "$header";
        print O1 "$seq";
        print O1 "\+\n";
        print O1 "$qual";
    }
}
close FQ1;
close O1;

undef $line;
open FQ2, "gunzip -dc $fq2 |" or die;
while (<FQ2>){
    my $header = $_;
    my $seq = <FQ2>;
    <FQ2>;
    my $qual = <FQ2>;
    $line += 1;
    if (exists $sample_line_idx{$line}){
        print O2 "$header";
        print O2 "$seq";
        print O2 "\+\n";
        print O2 "$qual";
    }
}
close FQ2;
close O2;
