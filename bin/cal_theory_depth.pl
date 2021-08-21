use strict;
use warnings;

my ($bed,$readlen,$num) = @ARGV;

# cal theory depth based on read length/target length/reads number

# cal target base
my $base_num;
my $target_n;
open BED, "$bed" or die;
while (<BED>){
	chomp;
	my @arr = split /\t/;
	my $len = $arr[2] - $arr[1];
	$base_num += $len;
	$target_n += 1;
}
close IN;

print "BED file has $target_n targets\n";
print "BED file length is $base_num\(bp)\n";

#assume dup rate is 0%
my $depth = int($num*$readlen/$base_num);
my $n = $num * $readlen;
print "$readlen\,$num\,$n\n";
print "theory depth is $depth\X\n";
