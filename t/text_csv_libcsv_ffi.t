use Test2::V0 -no_srand => 1;
use Text::CSV::LibCSV::FFI;

subtest basic => sub {

  my $parser = Text::CSV::LibCSV::FFI->new;
  isa_ok $parser, 'Text::CSV::LibCSV::FFI';

};

done_testing;


