#!/usr/bin/perl -w

# Load test the Template::Plugin::StringTree module and do some super-basic tests

use strict;
use lib ();
use UNIVERSAL 'isa';
use File::Spec::Functions ':ALL';
BEGIN {
	$| = 1;
	unless ( $ENV{HARNESS_ACTIVE} ) {
		require FindBin;
		chdir ($FindBin::Bin = $FindBin::Bin); # Avoid a warning
		lib->import( catdir( updir(), updir(), 'modules') );
	}
}





# Does everything load?
use Test::More 'tests' => 14;
BEGIN {
	ok( $] >= 5.005, 'Your perl is new enough' );
}

use_ok( 'Template::Plugin::StringTree' );





# Creation and null stuff and support methods
my $TPS = "Template::Plugin::StringTree";
my $Tree = $TPS->new;
isa_ok( $Tree, $TPS );
is( $Tree->freeze, 'null', "Null freeze returns expected value" );
is_deeply( $Tree->_path('a'), [ 'a' ], "Basic path returns correctly" );
is_deeply( $Tree->_path('a.b.c'), [ 'a', 'b', 'c' ], "Longer path returns correctly" );

# Basic get/set
ok( $Tree->set('foo', 'bar'), "Trival set returns true" );
is( $Tree->get('foo'), 'bar', "Trivial get returns the set value" );
is( $Tree->get('bad'), undef, "Non-existant get returns undef" );

# More complex
ok( $Tree->set('foo.a', 'b'), "More complex set returns true" );
is( $Tree->get('foo'), 'bar', "Trival set value stays the same" );
is( $Tree->get('foo.a'), 'b', "More complex get returns the set value" );

# Long
ok( $Tree->set('a.b.c.d.e.f.g', "foo"), "Long set returns true" );
is( $Tree->get('a.b.c.d.e.f.g'), "foo", "Long get returns the set value" );

1;
