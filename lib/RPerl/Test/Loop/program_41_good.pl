#!/usr/bin/perl

# Learning RPerl, Section 3.17: STDIN & Arrays

# [[[ HEADER ]]]
use RPerl;
use strict;
use warnings;
our $VERSION = 0.001_000;

# [[[ CRITICS ]]]
## no critic qw(ProhibitUselessNoCritic ProhibitMagicNumbers RequireCheckedSyscalls)  # USER DEFAULT 1: allow numeric values & print operator
## no critic qw(RequireInterpolationOfMetachars)  # USER DEFAULT 2: allow single-quoted control characters & sigils
## no critic qw(ProhibitExplicitStdin)  # USER DEFAULT 4: allow <STDIN> prompt

# [[[ OPERATIONS ]]]
my string_arrayref $input_strings = [];
print 'Please input zero or more strings, separated by <ENTER>, ended by <CTRL-D>:', "\n";
while (my string $input_string = <STDIN>) {
    chomp $input_string;
    push @{$input_strings}, $input_string;
}
print "\n";
print 'have $input_strings = ', string_arrayref_to_string($input_strings), "\n";
