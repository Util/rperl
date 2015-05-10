## no critic qw(Capitalization ProhibitMultiplePackages ProhibitReusedNames)  # SYSTEM DEFAULT 3: allow multiple & lower case package names
package rperltypes;
use strict;
use warnings;
use RPerl::Config;
our $VERSION = 0.000_102;

# START HERE: create tests for type() and types()
# START HERE: create tests for type() and types()
# START HERE: create tests for type() and types()

# NEED UPGRADE: create GrammarComponents
#use parent qw(RPerl::GrammarComponent)

# [[[ CRITICS ]]]
## no critic qw(ProhibitUselessNoCritic ProhibitMagicNumbers RequireCheckedSyscalls)  # USER DEFAULT 1: allow numeric values & print operator
## no critic qw(RequireInterpolationOfMetachars)  # USER DEFAULT 2: allow single-quoted control characters & sigils
## no critic qw(ProhibitExcessComplexity)  # SYSTEM SPECIAL 6: allow complex code inside subroutines, must be after line 1
## no critic qw(ProhibitPostfixControls)  # SYSTEM SPECIAL 7: PERL CRITIC UNFILED ISSUE, not postfix foreach or if
## no critic qw(ProhibitDeepNests)  # SYSTEM SPECIAL 8: allow deeply-nested code
## no critic qw(RequireBriefOpen)  # SYSTEM SPECIAL 10: allow complex processing with open filehandle
## no critic qw(ProhibitCascadingIfElse)  # SYSTEM SPECIAL 12: allow complex conditional logic

# [[[ NON-RPERL MODULES ]]]
use File::Copy qw(move);
use Scalar::Util qw(blessed);

# DEV NOTE, CORRELATION #08: can't use Exporter here
#use Exporter 'import';
#our @EXPORT = qw(type types);

# all following type lists lowest-to-highest level

# [[[ DATA TYPES ]]]
use RPerl::DataType::Void;
use RPerl::DataType::Integer;
use RPerl::DataType::Float;
use RPerl::DataType::Number;
use RPerl::DataType::Character;
use RPerl::DataType::String;
use RPerl::DataType::Scalar;
use RPerl::DataType::Unknown;
use RPerl::DataType::FileHandle;

# [[[ DATA STRUCTURES ]]]
use RPerl::DataStructure::Array;
use RPerl::DataStructure::Array::Reference;
use RPerl::DataStructure::Hash::Reference;
use RPerl::DataStructure::Hash::Reference;

#use RPerl::DataStructure::LinkedList;
#use RPerl::DataStructure::LinkedList::Node;
#use RPerl::DataStructure::Graph;
#use RPerl::DataStructure::Graph::Tree;
#use RPerl::DataStructure::Graph::Tree::Binary;
#use RPerl::DataStructure::Graph::Tree::Binary::Node;

# [[[ OBJECT-ORIENTED ]]]
use RPerl::Object;
use RPerl::CodeBlock::Subroutine::Method; # Method is the only item that is both a Data Type & a Grammar Rule???

# these types are currently implemented for all 3 primary RPerl modes: PERLOPS_PERLTYPES, CPPOPS_PERLTYPES, CPPOPS_CPPTYPES
# NEED REMOVE: hard-coded list
our string_arrayref $supported = [
    qw(
        void
        integer
        number
        string
        integer_arrayref
        number_arrayref
        string_arrayref
        integer_hashref
        number_hashref
        string_hashref
        )
];

# DEV NOTE, CORRELATION #08: export type() and types() to main:: namespace;
# can't achieve via Exporter due to circular dependency issue caused by Exporter in Config.pm and solved by 'require rperltypes;' in RPerl.pm
package main;
use Scalar::Util qw(blessed);

# for type-checking via SvIOKp(), SvNOKp(), and SvPOKp(); inside INIT to delay until after 'use MyConfig'
#INIT { RPerl::diag "in rperltypes.pm, loading C++ helper functions for type-checking...\n"; }
INIT {
    use RPerl::HelperFunctions_cpp;
    RPerl::HelperFunctions_cpp::cpp_load();
}

#my string $type = sub {
sub type {
    ( my unknown $variable, my integer $recurse_level ) = @_;
    if ( not defined $variable ) { return 'undef'; }
    if ( not defined $recurse_level ) { $recurse_level = 10; } # default to limited recursion
    my integer_hashref $is_type = build_is_type($variable);
    if    ( $is_type->{integer} ) { return 'integer'; }
    elsif ( $is_type->{number} )  { return 'number'; }
    elsif ( $is_type->{string} )  { return 'string'; }
    else {    # arrayref, hash, or blessed object
        my arrayref $types
            = types_recurse( $variable, $recurse_level, $is_type );
        return $types->[0]; # only return flat type string, discard nested type hashref
    }
}

#my string_hashref $types = sub {
sub types {
    ( my unknown $variable, my integer $recurse_level ) = @_;
    if ( not defined $variable ) { return 'undef'; }
    if ( not defined $recurse_level ) { $recurse_level = 10; } # default to limited recursion
    my integer_hashref $is_type = build_is_type($variable);
    if    ( $is_type->{integer} ) { return { 'integer' => undef }; }
    elsif ( $is_type->{number} )  { return { 'number'  => undef }; }
    elsif ( $is_type->{string} )  { return { 'string'  => undef }; }
    else {    # arrayref, hash, or blessed object
        my arrayref $types
            = types_recurse( $variable, $recurse_level, $is_type );
        return $types->[1]; # only return nested type hashref, discard flat type string
    }
}

#my integer_hashref build_is_type = sub {
sub build_is_type {
    ( my unknown $variable ) = @_;

    my integer_hashref $is_type = {
        integer  => main::RPerl_SvIOKp($variable),
        number   => main::RPerl_SvNOKp($variable),
        string   => main::RPerl_SvPOKp($variable),
        arrayref => main::RPerl_SvAROKp($variable),
        hashref  => main::RPerl_SvHROKp($variable),
        blessed  => 0,
        class    => blessed $variable
    };
    if ( defined $is_type->{class} ) { $is_type->{blessed} = 1; }

#    RPerl::diag 'in rperltypes::build_is_type(), have $is_type =' . "\n" . Dumper($is_type) . "\n";

    return $is_type;
}

#my string_hashref $types_recurse = sub {
sub types_recurse {
    (   my unknown $variable,
        my integer $recurse_level,
        my integer_hashref $is_type
    ) = @_;

#    RPerl::diag 'in rperltypes::types_recurse(), received $variable =' . "\n" . Dumper($variable) . "\n";

    if ( not defined $recurse_level ) { $recurse_level = 999; } # default to full recursion
    if ( not defined $is_type ) { $is_type = build_is_type($variable); }
#    RPerl::diag 'in rperltypes::types_recurse(), have $recurse_level = ' . $recurse_level . "\n";

#    RPerl::diag 'in rperltypes::types_recurse(), have $is_type =' . "\n" . Dumper($is_type) . "\n";

    my string $type          = undef;
    my string_hashref $types = undef;

    if    ( not defined $variable ) { $type = 'undef'; }
    elsif ( $is_type->{integer} )   { $type = 'integer'; }
    elsif ( $is_type->{number} )    { $type = 'number'; }
    elsif ( $is_type->{string} )    { $type = 'string'; }

    if ( defined $type ) {
#        RPerl::diag 'in rperltypes::types_recurse(), about to return undef or scalar $type = ' . $type . "\n";
        return [ $type, $types ];
    }
    elsif ( $recurse_level <= 0 ) {

      # blessed class must be tested first, because it also matches on hashref
        if ( $is_type->{blessed} ) {
            $type = 'object';
            $types = { $type => { '_CLASSNAME' => $is_type->{class} } };
        }
        elsif ( $is_type->{arrayref} ) { $type = 'arrayref'; }
        elsif ( $is_type->{hashref} )  { $type = 'hashref'; }
        else                           { $type = 'UNRECOGNIZED'; }
#        RPerl::diag 'in rperltypes::types_recurse(), max recurse reached, about to return unrecognized or non-scalar $type = ' . $type . "\n";
        return [ $type, $types ];
    }
    else {
        $recurse_level--;

      # blessed class must be tested first, because it also matches on hashref
        if ( $is_type->{blessed} ) {
            $type  = 'object';
            $types = {};
            $types->{$type} = { '_CLASSNAME' => $is_type->{class} };
            my string $subtype         = undef;
            my integer $is_homogeneous = 1;
#            RPerl::diag 'in rperltypes::types_recurse(), top of blessed class...' . "\n";

            foreach my $hash_key ( sort keys %{$variable} ) {
                my hashref $subtypes
                    = types_recurse( $variable->{$hash_key}, $recurse_level );
                if ( not defined $subtypes->[1] ) {

# for scalar subtypes or non-scalar subtypes w/ max recurse reached, discard undef nested type hashref
                    $types->{$type}->{$hash_key} = $subtypes->[0];
                }
                else {
# for non-scalar subtypes w/out max recurse reached, append nested subtype hashref to list of types for this arrayref
                    $types->{$type}->{$hash_key} = $subtypes->[1];
                }
                if ( not defined $subtype ) { $subtype = $subtypes->[0]; } # use first element's type as test for remaining element types
                elsif ( $is_homogeneous and ( $subtype ne $subtypes->[0] ) ) {
                    my string_arrayref $reverse_split_subtype
                        = [ reverse split /_/xms, $subtype ];
                    my string_arrayref $reverse_split_subtypes_0
                        = [ reverse split /_/xms, $subtypes->[0] ];
                    my string $new_subtype = q{};
                    for my integer $i (
                        0 .. ( scalar @{$reverse_split_subtype} ) - 1 )
                    {
#                        RPerl::diag 'in rperltypes::types_recurse(), inside blessed class, have $reverse_split_subtype->[' . $i . '] = ' . $reverse_split_subtype->[$i] . "\n";
#                        RPerl::diag 'in rperltypes::types_recurse(), inside blessed class, have $reverse_split_subtypes_0->[' . $i . '] = ' . $reverse_split_subtypes_0->[$i] . "\n";
                        if ( $reverse_split_subtype->[$i] eq
                            $reverse_split_subtypes_0->[$i] )
                        {
                            if ( $new_subtype eq q{} ) {
                                $new_subtype = $reverse_split_subtype->[$i];
                            }
                            else {
                                $new_subtype
                                    = $reverse_split_subtype->[$i] . '_'
                                    . $new_subtype;
                            }
                        }
                        else {
                            $is_homogeneous = 0.5; # partially homogeneous, mixed on some level
                        }
                    }
                    if ( $new_subtype ne q{} ) {
                        $subtype = $new_subtype;
                    }
                    else {
                        $is_homogeneous = 0;
                    }
                }
#                RPerl::diag 'in rperltypes::types_recurse(), inside blessed class, have $subtype = ' . $subtype . "\n";
            }
            if ($is_homogeneous) {
                my string $type_old = $type;
                if ( not defined $subtype ) { $subtype = 'undef' }
                elsif ( $is_homogeneous == 0.5 ) {
                    $subtype = 'mixed' . '_' . $subtype;
                }
                $type = $subtype . '_' . $type;
                $types->{$type} = $types->{$type_old};
                delete $types->{$type_old};
            }
            else {
                my string $type_old = $type;
                $type = 'mixed' . '_' . $type;
                $types->{$type} = $types->{$type_old};
                delete $types->{$type_old};
            }
#            RPerl::diag 'in rperltypes::types_recurse(), bottom of blessed class, have $type = ' . $type . "\n";
        }
        elsif ( $is_type->{arrayref} ) {
            $type           = 'arrayref';
            $types          = {};
            $types->{$type} = [];
            my string $subtype         = undef;
            my integer $is_homogeneous = 1;
#            RPerl::diag 'in rperltypes::types_recurse(), top of arrayref...' . "\n";

            foreach my $array_element ( @{$variable} ) {
                my hashref $subtypes
                    = types_recurse( $array_element, $recurse_level );
                if ( not defined $subtypes->[1] ) {

# for scalar subtypes or non-scalar subtypes w/ max recurse reached, discard undef nested type hashref
                    push @{ $types->{$type} }, $subtypes->[0];
                }
                else {
# for non-scalar subtypes w/out max recurse reached, append nested subtype hashref to list of types for this arrayref
                    push @{ $types->{$type} }, $subtypes->[1];
                }
                if ( not defined $subtype ) { $subtype = $subtypes->[0]; } # use first element's type as test for remaining element types
                elsif ( $is_homogeneous and ( $subtype ne $subtypes->[0] ) ) {
                    my string_arrayref $reverse_split_subtype
                        = [ reverse split /_/xms, $subtype ];
                    my string_arrayref $reverse_split_subtypes_0
                        = [ reverse split /_/xms, $subtypes->[0] ];
                    my string $new_subtype = q{};
                    for my integer $i (
                        0 .. ( scalar @{$reverse_split_subtype} ) - 1 )
                    {
#                        RPerl::diag 'in rperltypes::types_recurse(), inside arrayref, have $reverse_split_subtype->[' . $i . '] = ' . $reverse_split_subtype->[$i] . "\n";
#                        RPerl::diag 'in rperltypes::types_recurse(), inside arrayref, have $reverse_split_subtypes_0->[' . $i . '] = ' . $reverse_split_subtypes_0->[$i] . "\n";
                        if ( $reverse_split_subtype->[$i] eq
                            $reverse_split_subtypes_0->[$i] )
                        {
                            if ( $new_subtype eq q{} ) {
                                $new_subtype = $reverse_split_subtype->[$i];
                            }
                            else {
                                $new_subtype
                                    = $reverse_split_subtype->[$i] . '_'
                                    . $new_subtype;
                            }
                        }
                        else {
                            $is_homogeneous = 0.5; # partially homogeneous, mixed on some level
                        }
                    }
                    if ( $new_subtype ne q{} ) {
                        $subtype = $new_subtype;
                    }
                    else {
                        $is_homogeneous = 0;
                    }
                }
#                RPerl::diag 'in rperltypes::types_recurse(), inside arrayref, have $subtype = ' . $subtype . "\n";
            }
            if ($is_homogeneous) {
                my string $type_old = $type;
                if ( not defined $subtype ) { $subtype = 'undef' }
                elsif ( $is_homogeneous == 0.5 ) {
                    $subtype = 'mixed' . '_' . $subtype;
                }
                $type = $subtype . '_' . $type;
                $types->{$type} = $types->{$type_old};
                delete $types->{$type_old};
            }
            else {
                my string $type_old = $type;
                $type = 'mixed' . '_' . $type;
                $types->{$type} = $types->{$type_old};
                delete $types->{$type_old};
            }
#            RPerl::diag 'in rperltypes::types_recurse(), bottom of arrayref, have $type = ' . $type . "\n";
        }
        elsif ( $is_type->{hashref} ) {
            $type           = 'hashref';
            $types          = {};
            $types->{$type} = {};
            my string $subtype         = undef;
            my integer $is_homogeneous = 1;
#            RPerl::diag 'in rperltypes::types_recurse(), top of hashref...' . "\n";

            foreach my $hash_key ( sort keys %{$variable} ) {
                my hashref $subtypes
                    = types_recurse( $variable->{$hash_key}, $recurse_level );
                if ( not defined $subtypes->[1] ) {

# for scalar subtypes or non-scalar subtypes w/ max recurse reached, discard undef nested type hashref
                    $types->{$type}->{$hash_key} = $subtypes->[0];
                }
                else {
# for non-scalar subtypes w/out max recurse reached, append nested subtype hashref to list of types for this arrayref
                    $types->{$type}->{$hash_key} = $subtypes->[1];
                }
                if ( not defined $subtype ) { $subtype = $subtypes->[0]; } # use first element's type as test for remaining element types
                elsif ( $is_homogeneous and ( $subtype ne $subtypes->[0] ) ) {
                    my string_arrayref $reverse_split_subtype
                        = [ reverse split /_/xms, $subtype ];
                    my string_arrayref $reverse_split_subtypes_0
                        = [ reverse split /_/xms, $subtypes->[0] ];
                    my string $new_subtype = q{};
                    for my integer $i (
                        0 .. ( scalar @{$reverse_split_subtype} ) - 1 )
                    {
#                        RPerl::diag 'in rperltypes::types_recurse(), inside hashref, have $reverse_split_subtype->[' . $i . '] = ' . $reverse_split_subtype->[$i] . "\n";
#                        RPerl::diag 'in rperltypes::types_recurse(), inside hashref, have $reverse_split_subtypes_0->[' . $i . '] = ' . $reverse_split_subtypes_0->[$i] . "\n";
                        if ( $reverse_split_subtype->[$i] eq
                            $reverse_split_subtypes_0->[$i] )
                        {
                            if ( $new_subtype eq q{} ) {
                                $new_subtype = $reverse_split_subtype->[$i];
                            }
                            else {
                                $new_subtype
                                    = $reverse_split_subtype->[$i] . '_'
                                    . $new_subtype;
                            }
                        }
                        else {
                            $is_homogeneous = 0.5; # partially homogeneous, mixed on some level
                        }
                    }
                    if ( $new_subtype ne q{} ) {
                        $subtype = $new_subtype;
                    }
                    else {
                        $is_homogeneous = 0;
                    }
                }
#                RPerl::diag 'in rperltypes::types_recurse(), inside hashref, have $subtype = ' . $subtype . "\n";
            }
            if ($is_homogeneous) {
                my string $type_old = $type;
                if ( not defined $subtype ) { $subtype = 'undef' }
                elsif ( $is_homogeneous == 0.5 ) {
                    $subtype = 'mixed' . '_' . $subtype;
                }
                $type = $subtype . '_' . $type;
                $types->{$type} = $types->{$type_old};
                delete $types->{$type_old};
            }
            else {
                my string $type_old = $type;
                $type = 'mixed' . '_' . $type;
                $types->{$type} = $types->{$type_old};
                delete $types->{$type_old};
            }
#            RPerl::diag 'in rperltypes::types_recurse(), bottom of hashref, have $type = ' . $type . "\n";
        }
        else {
            $type = 'UNRECOGNIZED';
        }
        return [ $type, $types ];
    }
}
1;

# [[[ C++ TYPE CONTROL ]]]
package RPerl;
if ( not defined $RPerl::INCLUDE_PATH ) {
    our $INCLUDE_PATH = '/FAILURE/BECAUSE/RPERL/INCLUDE/PATH/NOT/YET/SET';
}
1;    # suppress warnings about typo in types_enable() below

package rperltypes;

#our void $types_input_enable = sub { (my $types_input) = @_;  # NEED FIX: RPerl typed functions not working in types.pm, must call as normal Perl function
sub types_enable {
    ( my $types_input ) = @_;

#	RPerl::diag "in rperltypes::types_enable(), received \$types_input = '$types_input'\n";

    my string $rperltypes_h_filename
        = $RPerl::INCLUDE_PATH . '/rperltypes_mode.h';

    #	my bool $rperltypes_h_modified = 0;
    my integer $rperltypes_h_modified = 0;

#	RPerl::diag "in rperltypes::types_enable(), have \$rperltypes_h_filename = '$rperltypes_h_filename'\n";

    my integer $open_close_retval = open my $TYPES_H_FILEHANDLE_IN, '<',
        $rperltypes_h_filename;
    if ( not $open_close_retval ) {
        croak(
            "ERROR XYZZY: Problem opening rperltypes_mode.h input file: $OS_ERROR, croaking"
        );
    }
    $open_close_retval = open my $TYPES_H_FILEHANDLE_OUT, '>',
        ( $rperltypes_h_filename . '.swap' );
    if ( not $open_close_retval ) {
        croak(
            "ERROR XYZZY: Problem opening rperltypes_mode.h.swap output file: $OS_ERROR, croaking"
        );
    }

    while ( defined( my $line_current = <$TYPES_H_FILEHANDLE_IN> ) ) {
        my string $types_current;

#		RPerl::diag "in rperltypes::types_enable(), have \$line_current =\n$line_current";
        if ( $line_current =~ /\#\s*define\s+\_\_(\w+)\_\_TYPES/xms ) {
            $types_current = $1;

#			RPerl::diag "in rperltypes::types_enable(), FOUND $types_current TYPES DEFINITION\n";

            if ( $line_current =~ /^\s*\/\//xms ) {

#				RPerl::diag "in rperltypes::types_enable(), FOUND $types_current TYPES DISABLED\n";
                if ( $types_current eq $types_input ) {

#					RPerl::diag "in rperltypes::types_enable(), ENABLE $types_current TYPES\n";
                    $line_current =~ s/\/\///xms; # remove first occurence of // comment
                    $rperltypes_h_modified = 1;
                }
            }
            elsif ( $line_current =~ /^\s*\#\s*define/xms ) {

#				RPerl::diag "in rperltypes::types_enable(), FOUND $types_current TYPES ENABLED\n";
                if ( $types_current ne $types_input ) {

#					RPerl::diag "in rperltypes::types_enable(), DISABLE $types_current TYPES\n";
                    $line_current          = q{//} . $line_current;
                    $rperltypes_h_modified = 1;
                }
            }
            else {
                $open_close_retval = close $TYPES_H_FILEHANDLE_IN;
                if ( not $open_close_retval ) {
                    croak(
                        "ERROR XYZZY: Problem while closing rperltypes_mode.h input file: $OS_ERROR, croaking"
                    );
                }

                $open_close_retval = close $TYPES_H_FILEHANDLE_OUT;
                if ( not $open_close_retval ) {
                    croak(
                        "ERROR XYZZY: Problem while closing rperltypes_mode.h.swap output file: $OS_ERROR, croaking"
                    );
                }
                croak(
                    'ERROR XYZZY: Found invalid __$types_current__TYPES definition in rperltypes_mode.h, neither properly disabled nor enabled, croaking'
                );
            }
        }
        print {$TYPES_H_FILEHANDLE_OUT} $line_current; # WRITE DATA BACK TO FILE
    }

    $open_close_retval = close $TYPES_H_FILEHANDLE_IN;
    if ( not $open_close_retval ) {
        croak(
            "ERROR XYZZY: Problem while closing rperltypes_mode.h input file: $OS_ERROR, croaking"
        );
    }

    $open_close_retval = close $TYPES_H_FILEHANDLE_OUT;
    if ( not $open_close_retval ) {
        croak(
            "ERROR XYZZY: Problem while closing rperltypes_mode.h.swap output file: $OS_ERROR, croaking"
        );
    }

    if ($rperltypes_h_modified) {
        move( $rperltypes_h_filename, ( $rperltypes_h_filename . '.orig' ) )
            or croak(
            "ERROR XYZZY: Problem moving (renaming) rperltypes_mode.h input file to rperltypes_mode.h.orig: $OS_ERROR, croaking"
            );
        move( ( $rperltypes_h_filename . '.swap' ), $rperltypes_h_filename )
            or croak(
            "ERROR XYZZY: Problem moving (renaming) rperltypes_mode.h.swap output file to rperltypes_mode.h: $OS_ERROR, croaking"
            );
    }

    return ();

    #};
}

1;
