#!/usr/bin/perl

use strict;
use Test::More tests => 14;

my $class;
BEGIN {
    $class = 'Net::Appliance::Phrasebook';
    use_ok($class);
}

my $pb = undef;
eval {$pb = $class->new};
like( $@, qr/^missing argument to Net::Appliance::Phrasebook::new/, 'Bare new failed' );

$pb = $class->new(platform => 'FWSM3');
isa_ok( $pb, 'Data::Phrasebook::Generic', 'New with platform');
is_deeply( [$pb->dict], ['FWSM3','FWSM','PIXOS'], 'dict search 1');

$pb = $class->new(platform => 'FWSM');
is_deeply( [$pb->dict], ['FWSM','PIXOS'], 'dict search 2');
$pb = $class->new(platform => 'PIXOS');
is_deeply( [$pb->dict], ['PIXOS'], 'dict search 3');
$pb = $class->new(platform => 'Aironet');
is_deeply( [$pb->dict], ['Aironet','IOS'], 'dict search 4');
$pb = $class->new(platform => 'IOS');
is_deeply( [$pb->dict], ['IOS'], 'dict search 5');

eval {$pb = $class->new(platform => 'ABCDE')};
like( $@, qr/^unknown platform: ABCDE, could not find dictionary/, 'bogus dict');

$pb = $class->new(platform => 'FWSM3');

is( $pb->fetch('paging'), 'terminal pager lines', 'fetch 1');
is( $pb->fetch('prompt'), '/[\/a-zA-Z0-9.-]+ ?(?:\(config[^)]*\))? ?[#>]/', 'fetch 2');

eval {$pb->fetch('FGHIJ')};
like( $@, qr/^No mapping for 'FGHIJ'/, 'bogus fetch');

$pb = $class->new(platform => 'FWSM');

is( $pb->fetch('paging'), 'pager lines', 'fetch 3');
is( $pb->fetch('prompt'), '/[\/a-zA-Z0-9.-]+ ?(?:\(config[^)]*\))? ?[#>]/', 'fetch 4');

