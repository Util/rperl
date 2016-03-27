//!/usr/bin/rperl

// Learning RPerl, Chapter 1, Exercise 3
// Foo Bar Arithmetic Example

// [[[ HEADER ]]]
#include <rperlprogram.h>
#ifndef __CPP__INCLUDED__RPerl__Learning__Chapter1__exercise_3_foo_bar_arithmetic_cpp
#define __CPP__INCLUDED__RPerl__Learning__Chapter1__exercise_3_foo_bar_arithmetic_cpp 0.001_000
# ifdef __CPP__TYPES

int main() {  // [[[ OPERATIONS HEADER ]]]



// [[[ OPERATIONS ]]]
    integer  foo = 21 + 12;
    integer  bar = 23 * 42 * 2;
    number  baz  = integer_to_number( bar) /  foo;
 print "have $foo = "<< To_string( foo)<< endl;
 print "have $bar = "<< To_string( bar)<< endl;
 print "have $baz = "<< To_string( baz)<< endl;



return 0; }  // [[[ OPERATIONS FOOTER ]]]

// [[[ FOOTER ]]]
# elif defined __PERL__TYPES
Purposefully_die_from_a_compile-time_error,_due_to____PERL__TYPES_being_defined.__We_need_to_define_only___CPP__TYPES_in_this_file!
# endif
#endif
