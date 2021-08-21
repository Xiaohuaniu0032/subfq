use strict;
use warnings;

my ($bed,$readlen,$cov) = @ARGV;

# infer how many reads should to extract to get a certain depth

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
close BED;

print "BED file has $target_n targets\n";
print "BED file length is $base_num\(bp)\n";

#assume dup rate is 0%
my $num = int($cov*$base_num/$readlen);
print "to get theory depth $cov\X, you should extract $num reads ($readlen bp)\n";
