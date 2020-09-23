# Text::CSV::LibCSV::FFI [![Build Status](https://travis-ci.org/plicease/Text-CSV-LibCSV-FFI.svg)](http://travis-ci.org/plicease/Text-CSV-LibCSV-FFI)

Comma-separated values manipulation routines (using FFI + libcsv)

# SYNOPSIS

# DESCRIPTION

# CONSTRUCTOR

## new

```perl
my $parser = Text::CSV::LibCSV::FFI->new($options);
```

# METHODS

## opts

```perl
my \%opts = $parser->opts;
$parser->opts(\%opts);
```

Get or set the parser options.  Options are:

- `'strict'`
- `'repall_nl'`
- `'strict_fini'`
- `'append_null'`
- `'empty_is_null'`

# FUNCTIONS

All functions and constants may be imported by request using the usual [Exporter](https://metacpan.org/pod/Exporter) interface.

## csv\_error

```perl
my $ec = csv_error $parser;
```

Returns the error code:

- CSV\_SUCCESS

    No error.

- CSV\_EPARSE

    Parse error in strict mode

- CSV\_ENOMEM

    Out of memory while increasing buffer size

- CSV\_ETOOBIG

    Buffer larger than SIZE\_MAX needed

- CSV\_EINVALID

    Invalid code,should never be received from csv\_error

## csv\_strerror

```perl
my $string = csv_strerror $ec;
```

Takes an error code from `csv_error` and returns a stringified form of that error.

## csv\_get\_opts

```perl
my $opts = csv_get_opts $parser;
```

Gets the parser options, which is or'd together from these constants:

use constant CSV\_STRICT        => 1;
use constant CSV\_REPALL\_NL     => 2;
use constant CSV\_STRICT\_FINI   => 4;
use constant CSV\_APPEND\_NULL   => 8;
use constant CSV\_EMPTY\_IS\_NULL => 16;

- CSV\_STRICT
- CSV\_REPALL\_NL
- CSV\_STRICT\_FINI
- CSV\_APPEND\_NULL
- CSV\_EMPTY\_IS\_NULL

Returns `-1` on error.

## csv\_set\_opts

```perl
my $ret = csv_get_opts $parser, $opts;
```

Sets the options for the parser, (see `csv_get_opts` above).  On success
`0` is returned otherwise, `-1` is returned.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
