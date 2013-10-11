#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use constant CLASS => 'Devel::PartialDump';

use ok CLASS;

# -----------------
# max_length

my @list = 1 .. 10;

my $d = CLASS->new;
$d->pairs(0);
$d->clear_max_elements;

$d->clear_max_length;
is( $d->dump(@list), '1, 2, 3, 4, 5, 6, 7, 8, 9, 10', 'max_length undefined' );

$d->max_length(100);
is( $d->dump(@list), '1, 2, 3, 4, 5, 6, 7, 8, 9, 10', 'max_length high' );

$d->max_length(10);
is( $d->dump(@list), '1, 2, 3...', 'max_length low' );

$d->max_length(0);
is( $d->dump(@list), '...', 'max_length zero' );

# -----------------
# max_elements

$d = CLASS->new;

$d->pairs(0);
{
    $d->clear_max_elements;
    is( $d->dump(@list), '1, 2, 3, 4, 5, 6, 7, 8, 9, 10',
        'list max_elements undefined' );

    $d->max_elements(100);
    is( $d->dump(@list), '1, 2, 3, 4, 5, 6, 7, 8, 9, 10',
        'list max_elements high' );

    $d->max_elements(6);
    is( $d->dump(@list), '1, 2, 3, 4, 5, 6, ...',
        'list max_elements low' );

    $d->max_elements(0);
    is( $d->dump(@list), '...', 'list max elements zero' );
}

$d->pairs(1);
{
    $d->clear_max_elements;
    is( $d->dump(@list), '1: 2, 3: 4, 5: 6, 7: 8, 9: 10',
        'pairs max_elements undefined' );

    $d->max_elements(100);
    is( $d->dump(@list), '1: 2, 3: 4, 5: 6, 7: 8, 9: 10',
        'pairs max_elements high' );

    $d->max_elements(3);
    is( $d->dump(@list), '1: 2, 3: 4, 5: 6, ...',
        'pairs max_elements low' );

    $d->max_elements(0);
    is( $d->dump(@list), '...', 'pairs max elements zero' );
}

# -----------------
# max_depth

$d = CLASS->new;

$d->max_depth(10);
is( $d->dump( [ { foo => ["bar"] } ] ),
    '[ { foo: [ "bar" ] } ]', 'max_depth high' );

$d->max_depth(2);
like( $d->dump( [ { foo => ["bar"] } ] ),
    qr/^\[ \{ foo: ARRAY\(0x[a-z0-9]+\) \} \]$/, 'max_depth low' );

$d->max_depth(0);
like( $d->dump( [ { foo => ["bar"] } ] ),
    qr/^ARRAY\(0x[a-z0-9]+\)$/, 'max_depth zero' );

done_testing;
