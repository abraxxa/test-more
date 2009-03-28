#!/usr/bin/perl -w

BEGIN {
    if( $ENV{PERL_CORE} ) {
        chdir 't';
        @INC = ( '../lib', 'lib' );
    }
    else {
        unshift @INC, 't/lib';
    }
}

use strict;
use warnings;

use Test::Builder::NoOutput;

use Test::More 'no_plan'; # tests => 2;

{
    my $tb = Test::Builder::NoOutput->create;

    $tb->plan( tests => 7 );
    for( 1 .. 3 ) {
        $tb->ok( $_, "We're on $_" );
        $tb->diag("We ran $_");
    }
    {
        my $indented = $tb->child;
        $indented->plan('no_plan');
        $indented->ok( 1, "We're on 1" );
        $indented->ok( 1, "We're on 2" );
        $indented->ok( 1, "We're on 3" );
        $indented->finalize;
    }
    for( 7, 8, 9 ) {
        $tb->ok( $_, "We're on $_" );
    }

    $tb->reset_outputs;
    is $tb->read, <<'END', 'Output should nest properly';
1..7
ok 1 - We're on 1
# We ran 1
ok 2 - We're on 2
# We ran 2
ok 3 - We're on 3
# We ran 3
    ok 1 - We're on 1
    ok 2 - We're on 2
    ok 3 - We're on 3
    1..3
ok 4 - Child of t/Nested/basic.t
ok 5 - We're on 7
ok 6 - We're on 8
ok 7 - We're on 9
END
}

