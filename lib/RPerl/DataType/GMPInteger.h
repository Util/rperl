using std::cout;  using std::cerr;  using std::endl;

#ifndef __CPP__INCLUDED__RPerl__DataType__GMPInteger_h
#define __CPP__INCLUDED__RPerl__DataType__GMPInteger_h 0.004_100

// NEED FIX: remove duplicate code
// DEV NOTE, CORRELATION #rp26: can't figure out how to get GMPInteger.cpp to include HelperFunctions.cpp without redefining errors
#define SvHROKp(input_hv_ref) (SvROK(input_hv_ref) && (SvTYPE(SvRV(input_hv_ref)) == SVt_PVHV))

# ifndef __CPP__INCLUDED__RPerl__DataType__GMPInteger_h__typedefs
#define __CPP__INCLUDED__RPerl__DataType__GMPInteger_h__typedefs 1
// [[[ TYPEDEFS ]]]
typedef mpz_class gmp_integer_retval;
typedef mpz_t gmp_integer;
// [[[ OO SUBCLASSES ]]]
#define gmp_integer_rawptr gmp_integer*
/* UNUSED?
typedef std::unique_ptr<gmp_integer> gmp_integer_ptr;
typedef std::vector<gmp_integer_ptr> gmp_integer_arrayref;
typedef std::unordered_map<string, gmp_integer_ptr> gmp_integer_hashref;
typedef std::unordered_map<string, gmp_integer_ptr>::iterator gmp_integer_hashref_iterator;
*/
# endif

// [[[ PRE-DECLARED TYPEDEFS ]]]
# ifndef __CPP__INCLUDED__RPerl__DataType__Boolean_h__typedefs
#define __CPP__INCLUDED__RPerl__DataType__Boolean_h__typedefs 1
typedef bool boolean;
# endif
# ifndef __CPP__INCLUDED__RPerl__DataType__UnsignedInteger_h__typedefs
#define __CPP__INCLUDED__RPerl__DataType__UnsignedInteger_h__typedefs 1
typedef unsigned long int unsigned_integer;
# endif
# ifndef __CPP__INCLUDED__RPerl__DataType__Integer_h__typedefs
#define __CPP__INCLUDED__RPerl__DataType__Integer_h__typedefs 1
// DEV NOTE, CORRELATION #rp01: keep track of all these hard-coded integer data types
#  ifdef __TYPE__INTEGER__LONG
typedef long integer;
#  elif defined __TYPE__INTEGER__LONG_LONG
typedef long long integer;
#  elif defined __TYPE__INTEGER____INT8
typedef __int8 integer;
#  elif defined __TYPE__INTEGER____INT16
typedef __int16 integer;
#  elif defined __TYPE__INTEGER____INT32
typedef __int32 integer;
#  elif defined __TYPE__INTEGER____INT64
typedef __int64 integer;
#  elif defined __TYPE__INTEGER____INT128
typedef __int128 integer;
#  elif defined __TYPE__INTEGER__INT8_T
typedef int8_t integer;
#  elif defined __TYPE__INTEGER__INT16_T
typedef int16_t integer;
#  elif defined __TYPE__INTEGER__INT32_T
typedef int32_t integer;
#  elif defined __TYPE__INTEGER__INT64_T
typedef int64_t integer;
#  elif defined __TYPE__INTEGER__INT128_T
typedef int128_t integer;
#  else
typedef long integer;  // default
#  endif
# endif
# ifndef __CPP__INCLUDED__RPerl__DataType__Number_h__typedefs
#define __CPP__INCLUDED__RPerl__DataType__Number_h__typedefs 1
#  ifdef __TYPE__NUMBER__DOUBLE
typedef double number;
#  elif defined __TYPE__NUMBER__LONG__DOUBLE
typedef long double number;
#  else
typedef double number;  // default
#  endif
# endif
# ifndef __CPP__INCLUDED__RPerl__DataType__Character_h__typedefs
#define __CPP__INCLUDED__RPerl__DataType__Character_h__typedefs 1
typedef char character;
# endif
# ifndef __CPP__INCLUDED__RPerl__DataType__String_h__typedefs
#define __CPP__INCLUDED__RPerl__DataType__String_h__typedefs 1
typedef std::string string;
typedef std::ostringstream ostringstream;
# endif

// [[[ INCLUDES ]]]
#include <rperltypes_mode.h> // for definitions of __PERL__TYPES or __CPP__TYPES

// [[[ OPERATIONS & DATA TYPES REPORTER ]]]
# ifdef __PERL__TYPES
SV* RPerl__DataType__GMPInteger__MODE_ID() { return(newSViv(1)); }  // CPPOPS_PERLTYPES is 1
# elif defined __CPP__TYPES
int RPerl__DataType__GMPInteger__MODE_ID() { return 2; }  // CPPOPS_CPPTYPES is 2
# else
Purposefully_die_from_a_compile-time_error,_due_to_neither___PERL__TYPES_nor___CPP__TYPES_being_defined.__We_need_to_define_exactly_one!
# endif

// [[[ TYPE-CHECKING SUBROUTINES ]]]
void gmp_integer_CHECK(SV* possible_gmp_integer);
void gmp_integer_CHECKTRACE(SV* possible_gmp_integer, const char* variable_name, const char* subroutine_name);

// [[[ TYPEMAP PACK/UNPACK FOR __CPP__TYPES ]]]
# ifdef __CPP__TYPES
gmp_integer_retval XS_unpack_gmp_integer_retval(SV* input_sv);
void XS_pack_gmp_integer_retval(SV* output_sv, gmp_integer_retval input_gmp_integer_retval);
# endif

// [[[ BOOLEANIFY ]]]
# ifdef __PERL__TYPES
SV* gmp_integer_to_boolean(SV* input_gmp_integer);
# elif defined __CPP__TYPES
boolean gmp_integer_to_boolean(gmp_integer_retval input_gmp_integer_retval);
# endif

// [[[ UNSIGNED INTEGERIFY ]]]
# ifdef __PERL__TYPES
SV* gmp_integer_to_unsigned_integer(SV* input_gmp_integer);
# elif defined __CPP__TYPES
unsigned_integer gmp_integer_to_unsigned_integer(gmp_integer_retval input_gmp_integer_retval);
# endif

// [[[ INTEGERIFY ]]]
# ifdef __PERL__TYPES
SV* gmp_integer_to_integer(SV* input_gmp_integer);
# elif defined __CPP__TYPES
integer gmp_integer_to_integer(gmp_integer_retval input_gmp_integer_retval);
# endif

// [[[ NUMBERIFY ]]]
# ifdef __PERL__TYPES
SV* gmp_integer_to_number(SV* input_gmp_integer);
# elif defined __CPP__TYPES
number gmp_integer_to_number(gmp_integer_retval input_gmp_integer_retval);
# endif

// [[[ CHARACTERIFY ]]]
# ifdef __PERL__TYPES
SV* gmp_integer_to_character(SV* input_gmp_integer);
# elif defined __CPP__TYPES
character gmp_integer_to_character(gmp_integer_retval input_gmp_integer_retval);
# endif

// [[[ STRINGIFY ]]]
# ifdef __PERL__TYPES
SV* gmp_integer_to_string(SV* input_gmp_integer);
# elif defined __CPP__TYPES
string gmp_integer_to_string(gmp_integer_retval input_gmp_integer_retval);
# endif
string gmp_integer_to_string_CPPTYPES(gmp_integer_retval input_gmp_integer_retval);

// [[[ GMP INTEGERIFY ]]]
# ifdef __PERL__TYPES
SV* boolean_to_gmp_integer(SV* input_boolean);
SV* unsigned_integer_to_gmp_integer(SV* input_unsigned_integer);
SV* integer_to_gmp_integer(SV* input_integer);
SV* number_to_gmp_integer(SV* input_number);
SV* character_to_gmp_integer(SV* input_character);
SV* string_to_gmp_integer(SV* input_string);
# elif defined __CPP__TYPES
gmp_integer_retval boolean_to_gmp_integer(boolean input_boolean);
gmp_integer_retval unsigned_integer_to_gmp_integer(unsigned_integer input_unsigned_integer);
gmp_integer_retval integer_to_gmp_integer(integer input_integer);
gmp_integer_retval number_to_gmp_integer(number input_number);
gmp_integer_retval character_to_gmp_integer(character input_character);
gmp_integer_retval string_to_gmp_integer(string input_string);
# endif

// [[[ TYPE TESTING ]]]
# ifdef __PERL__TYPES
SV* gmp_integer__typetest0();
SV* gmp_integer__typetest1(SV* lucky_gmp_integer);
# elif defined __CPP__TYPES
gmp_integer_retval gmp_integer__typetest0();
gmp_integer_retval gmp_integer__typetest1(gmp_integer_retval lucky_gmp_integer_retval);
# endif

#endif
