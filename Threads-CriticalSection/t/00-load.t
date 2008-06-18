#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Threads::CriticalSection' );
}

diag( "Testing Threads::CriticalSection $Threads::CriticalSection::VERSION, Perl $], $^X" );
