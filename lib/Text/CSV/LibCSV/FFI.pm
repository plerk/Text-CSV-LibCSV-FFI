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

my $ffi = FFI::Platypus->new( api => 1 );

# use the code bundled with this dist
$ffi->bundle;

# translate the `struct csv_parser*` from C to a Text::CSV::LibCSV::FFI
$ffi->type('object(Text::CSV::LibCSV::FFI)' => 'csv_parser');

# remove the csv_ prefix for constructors and methods
$ffi->mangler(sub { 'csv_' . $_[0] });

# ABSTRACT: Comma-separated values manipulation routines (using FFI + libcsv)
# VERSION

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 CONSTRUCTOR

=head2 new

 my $parser = Text::CSV::LibCSV::FFI->new($options);

=cut

# we return an opaque from C and bless the class ourselves
# so that that this class can be inherited from
$ffi->attach( new => ['unsigned char'] => 'opaque' => sub {
  my($xsub, $class, $options) = @_;
  my $ptr = $xsub->($options // 0);
  bless \$ptr, $class;
});

$ffi->attach( DESTROY => ['csv_parser'] );

=head1 METHODS

=head2 opts

 my \%opts = $parser->opts;
 $parser->opts(\%opts);

Get or set the parser options.  Options are:

=over 4

=item C<'strict'>

=item C<'repall_nl'>

=item C<'strict_fini'>

=item C<'append_null'>

=item C<'empty_is_null'>

=back

=cut

my %opts = (
  'strict'        => CSV_STRICT,
  'repall_nl'     => CSV_REPALL_NL,
  'strict_fini'   => CSV_STRICT_FINI,
  'append_null'   => CSV_APPEND_NULL,
  'empty_is_null' => CSV_EMPTY_IS_NULL,
);

sub opts
{
  my($self, $new) = @_;

  my $opts;
  if($new and ref($new) eq 'HASH')
  {
    $opts = 0;
    foreach my $name (keys %opts)
    {
      $opts |= $opts{$name} if $new->{$name};
    }
    csv_set_opts($self, $opts);
  }
  else
  {
    $opts = csv_get_opts($self);
  }

  my %ret;

  foreach my $name (keys %opts)
  {
    $ret{$name} = 1 if ($opts & $opts{$name}) == $opts{$name};
  }

  \%ret;
}

=head1 FUNCTIONS

All functions and constants may be imported by request using the usual L<Exporter> interface.

=cut

# remove the csv_ prefix for constructors and methods
$ffi->mangler(sub { $_[0] });

=head2 csv_error

 my $ec = csv_error $parser;

Returns the error code:

=over 4

=item CSV_SUCCESS

No error.

=item CSV_EPARSE

Parse error in strict mode

=item CSV_ENOMEM

Out of memory while increasing buffer size

=item CSV_ETOOBIG

Buffer larger than SIZE_MAX needed

=item CSV_EINVALID

Invalid code,should never be received from csv_error

=cut

=back

=cut

$ffi->load_custom_type('::Enum', 'csv_error',
  { rev => 'int', package => __PACKAGE__, prefix => 'CSV_' },
  'success',
  'eparse',
  'enomem',
  'etoobig',
  'einvalid',
);

$ffi->attach( csv_error => ['csv_parser'] => 'csv_error' => '$' );

=head2 csv_strerror

 my $string = csv_strerror $ec;

Takes an error code from C<csv_error> and returns a stringified form of that error.

=cut

$ffi->attach( csv_strerror => ['csv_error'] => 'string' => '$' );

=head2 csv_get_opts

 my $opts = csv_get_opts $parser;

Gets the parser options, which is or'd together from these constants:

use constant CSV_STRICT        => 1;
use constant CSV_REPALL_NL     => 2;
use constant CSV_STRICT_FINI   => 4;
use constant CSV_APPEND_NULL   => 8;
use constant CSV_EMPTY_IS_NULL => 16;

=over 4

=item CSV_STRICT

=item CSV_REPALL_NL

=item CSV_STRICT_FINI

=item CSV_APPEND_NULL

=item CSV_EMPTY_IS_NULL

=back

Returns C<-1> on error.

=cut

$ffi->attach( csv_get_opts => ['csv_parser'] => 'int' => '$' );

=head2 csv_set_opts

 my $ret = csv_get_opts $parser, $opts;

Sets the options for the parser, (see C<csv_get_opts> above).  On success
C<0> is returned otherwise, C<-1> is returned.

=cut

$ffi->attach( csv_set_opts => ['csv_parser', 'unsigned char' ] => 'int' => '$$' );

our @EXPORT_OK = grep /^csv_/i, keys %Text::CSV::LibCSV::FFI::;
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

1;
