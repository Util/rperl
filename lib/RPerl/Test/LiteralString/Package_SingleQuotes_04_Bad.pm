# [[[ TEST : 'ERROR ECVPAPC02' ]]]
# [[[ TEST : 'Perl::Critic::Policy::ValuesAndExpressions::RequireInterpolationOfMetachars' ]]]
# [[[ HEADER ]]]
package RPerl::Test::LiteralString::Package_SingleQuotes_04_Bad;
use strict;
use warnings;
use RPerl;
our $VERSION = 0.001_000;

# [[[ SUBROUTINES ]]]
our void $empty_sub = sub { '$"q{foo123}"'; };

1;                  # end of class