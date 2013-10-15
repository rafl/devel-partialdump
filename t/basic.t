#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use ok 'Devel::PartialDump';

my $d = Devel::PartialDump->new;

is( $d->dump("foo"), '"foo"', "simple value" );

is( $d->dump(undef), "undef", "undef" );

is( $d->dump("foo" => "bar"), 'foo: "bar"', "named params" );

is( $d->dump( \"foo" => "bar" ), '\\"foo", "bar"', "not named params" );

is( $d->dump( foo => "bar", gorch => [ 1, "bah" ] ), 'foo: "bar", gorch: [ 1, "bah" ]', "recursion" );

is( $d->dump("foo\nbar"), '"foo\nbar"', "newline" );

is( $d->dump("foo" . chr(1)), '"foo\x{1}"', "non printable" );

my $foo = "foo";
is( $d->dump(\substr($foo, 0)), '\\"foo"', "reference to lvalue");

is( $d->dump(\\"foo"), '\\\\"foo"', "reference to reference" );
