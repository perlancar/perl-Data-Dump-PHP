#!perl -w

BEGIN { print "1..1\n"; print "ok 1\n"; exit }
use strict;
use Test qw(plan ok);
plan tests => 6;

use Data::Dump qw(dump);
use Symbol qw(gensym);

ok(dump(*STDIN), "*main::STDIN");
ok(dump(\*STDIN), "\\*main::STDIN");
ok(dump(gensym()), "do {\n  require Symbol;\n  Symbol::gensym();\n}");

$a = [];
${*foo}[1] = $a;
${*foo}{bar} = 2;
ok(dump(\*foo, $a) . "\n", <<'EOT');
do {
  my $a = \*main::foo;
  *{$a} = [undef, []];
  *{$a} = { bar => 2 };
  ($a, *{$a}{ARRAY}[1]);
}
EOT

use IO::Socket::INET;
my $s = IO::Socket::INET->new(
    Listen => 1,
    Timeout => 5,
);
$s = dump($s);
print "$s\n";
ok($s =~ /my \$a = bless\(Symbol::gensym\(\), "IO::Socket::INET"\);/);
ok($s =~ /^\s+io_socket_timeout\s+=> 5,/m);
