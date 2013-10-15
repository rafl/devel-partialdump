#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use constant CLASS => 'Devel::PartialDump';

use ok CLASS;

my $d = new_ok CLASS;

$d->pairs(0);
$d->list_delim(",");

is( $d->dump("foo", "bar"), '"foo","bar"', "list_delim" );

$d->pairs(1);
$d->pair_delim("=>");

is( $d->dump("foo" => "bar"), 'foo=>"bar"', "pair_delim" );

done_testing;
