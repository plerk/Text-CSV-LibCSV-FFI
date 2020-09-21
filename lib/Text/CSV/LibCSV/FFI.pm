package Text::CSV::LibCSV::FFI;

use strict;
use warnings;
use 5.010;
use FFI::CheckLib qw( find_lib_or_die );
use FFI::Platypus 1.00;
use Carp qw( croak );
use constant CSV_STRICT        => 1;
use constant CSV_REPALL_NL     => 2;
use constant CSV_STRICT_FINI   => 4;
use constant CSV_APPEND_NULL   => 8;
use constant CSV_EMPTY_IS_NULL => 16;
use base qw( Exporter );

# ABSTRACT: Comma-separated values manipulation routines (using FFI + libcsv)
# VERSION

my $ffi = FFI::Platypus->new( api => 1 );

# use the code bundled with this dist
$ffi->bundle;

# translate the `struct csv_parser*` from C to a Text::CSV::LibCSV::FFI
$ffi->type('object(Text::CSV::LibCSV::FFI)' => 'csv_parser');

# All of our functions have a csv_ prefix
$ffi->mangler(sub { 'csv_' . $_[0] });

# we return an opaque from C and bless the class ourselves
# so that that this class can be inherited from
$ffi->attach( new => ['unsigned char'] => 'opaque' => sub {
  my($xsub, $class, $options) = @_;
  my $ptr = $xsub->($options // 0);
  bless \$ptr, $class;
});

$ffi->attach( DESTROY => ['csv_parser'] );

our @EXPORT_OK = grep /^csv_/i, keys %Text::CSV::LibCSV::FFI::;
our @EXPORT_TAGS = ( all => \@EXPORT_OK );

1;
