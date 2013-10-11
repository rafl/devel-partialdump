#!/usr/bin/perl -T

use strict;
use warnings;

use Test::More;

use constant CLASS => 'Devel::PartialDump';

use ok CLASS;

package My::Object::Hash;
{
    use overload '""' => \&stringify;

    sub new {
        my $class = shift;
        bless { value => $_[0] }, $class;
    }
    sub stringify { $_[0]->{value} }
}

package My::Object::Array;
{
    use overload '""' => \&stringify;

    sub new {
        my $class = shift;
        bless [$_[0]], $class;
    }
    sub stringify { $_[0]->[0] }
}

package My::Object::Scalar;
{
    use overload '""' => \&stringify;

    sub new {
        my $class = shift;
        bless \$_[0], $class;
    }
    sub stringify { ${$_[0]} }
}

package main;

my $hash = My::Object::Hash->new('foo');
my $array = My::Object::Array->new('foo');
my $scalar = My::Object::Scalar->new('foo');

my $d = new_ok CLASS;

is( $d->dump($hash), 'My::Object::Hash={ value: "foo" }', 'hash object dump' );
is( $d->dump($array), 'My::Object::Array=[ "foo" ]', 'array object dump' );
is( $d->dump($scalar), 'My::Object::Scalar=\"foo"', 'scalar object dump' );

$d = CLASS->new( objects => 0 );

like( $d->dump($hash), qr/^My::Object::Hash=HASH\(0x[a-z0-9]+\)$/,
    'hash object stringified' );
like( $d->dump($array), qr/^My::Object::Array=ARRAY\(0x[a-z0-9]+\)$/,
    'array object stringified' );
like( $d->dump($scalar), qr/^My::Object::Scalar=SCALAR\(0x[a-z0-9]+\)$/,
    'scalar object stringified' );

$d = CLASS->new( objects => 0, stringify => 1 );

is( $d->dump($hash), 'foo', 'hash object string overloaded' );
is( $d->dump($array), 'foo', 'array object string overloaded' );
is( $d->dump($scalar), 'foo', 'scalar object string overloaded' );

done_testing;
