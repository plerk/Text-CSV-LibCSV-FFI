use Test2::V0 -no_srand => 1;
use Text::CSV::LibCSV::FFI qw( :all );

subtest basic => sub {

  my $parser = Text::CSV::LibCSV::FFI->new;
  isa_ok $parser, 'Text::CSV::LibCSV::FFI';

  is( csv_error $parser, 0 );
  is( csv_strerror 0, 'success' );
  is( csv_get_opts $parser, 0 );
  is( $parser->opts, { } );
  is( csv_set_opts($parser, CSV_STRICT | CSV_EMPTY_IS_NULL), 0);
  is( csv_get_opts $parser, CSV_STRICT | CSV_EMPTY_IS_NULL);
  is( $parser->opts, { strict => 1, empty_is_null => 1 } );
  is( $parser->opts({ repall_nl => 1, strict_fini => 1 }), { repall_nl => 1, strict_fini => 1 });
  is( csv_get_opts $parser, CSV_REPALL_NL | CSV_STRICT_FINI );
  is( $parser->opts, { repall_nl => 1, strict_fini => 1 });

};

done_testing;


