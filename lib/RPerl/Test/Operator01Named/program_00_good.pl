#!/usr/bin/perl
# [[[ HEADER ]]]
use strict;
use warnings;
use RPerl;
our $VERSION = 0.001_000;

# [[[ CRITICS ]]]
## no critic qw(ProhibitUselessNoCritic ProhibitMagicNumbers RequireCheckedSyscalls)  # USER DEFAULT 1: allow numeric values and print operator
## no critic qw(RequireInterpolationOfMetachars)  # USER DEFAULT 2: allow single-quoted control characters & sigils

# [[[ OPERATIONS ]]]
# NEED FIX: add all builtins
my number $op_sin = sin 2;
my number $op_cos = cos 2;

my integer__array_ref $frob = [];
my integer $frob_length = ( push @{$frob}, 21, 12, 23 );    # GOOD
print 'have $frob_length = ', $frob_length, "\n";

#print 'have quux = ', $quux, "\n";