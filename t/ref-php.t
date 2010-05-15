#!perl -w

use strict;
use Test qw(plan ok);

plan tests => 1;

use Data::Dump::PHP qw(dump_php quote_php);

my %a = (a => 1, b => 2, c => 3);
$a{a} = \%a;
ok(dump_php(\%a), "call_user_func(create_function('', ".quote_php(<<'EOT')."))");
  $a = array( "a" => 'fix', "b" => 2, "c" => 3 );
  $a["a"] =& $a;
  return $a;
EOT

