#!/usr/bin/perl

# [[[ PREPROCESSOR ]]]
# <<< PARSE_ERROR: 'ERROR ECOPAPL02' >>>

# [[[ HEADER ]]]
use RPerl;
use strict;
use warnings;
our $VERSION = 0.001_000;

# [[[ CRITICS ]]]
## no critic qw(ProhibitUselessNoCritic ProhibitMagicNumbers RequireCheckedSyscalls)  # USER DEFAULT 1: allow numeric values & print operator
## no critic qw(RequireInterpolationOfMetachars)  # USER DEFAULT 2: allow single-quoted control characters & sigils

# [[[ OPERATIONS ]]]

my string $foo  = 'howdy hello ahoy';
my integer $bar = $foo =~ m/owdy/msx;
my integer $bat = ( $foo =~ m/Hello/msx );
my integer $baz = ( $foo =~ m/\s[Aa]hoy$/msx );
my integer $bax = ( $foo =~ s/hoHO/gms );

print 'have $foo = ', $foo, "\n";
print 'have $bar = ', $bar, "\n";
print 'have $bat = ', $bat, "\n";
print 'have $baz = ', $baz, "\n";
print 'have $bax = ', $bax, "\n";

$foo = 'Alpha Bravo Charlie 123';
$bar = ( $foo !~ m/owdy/msx );
$bat = ( $foo !~ m/ravo/msx );
$baz = ( $foo !~ m/\s[Cc]harlie\s\d*$/msx );
$bax = ( $foo !~ s/ha/HAHA/gms );

print 'have $foo = ', $foo, "\n";
print 'have $bar = ', $bar, "\n";
print 'have $bat = ', $bat, "\n";
print 'have $baz = ', $baz, "\n";
print 'have $bax = ', $bax, "\n";
