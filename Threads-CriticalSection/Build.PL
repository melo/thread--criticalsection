use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Threads::CriticalSection',
    license             => 'perl',
    dist_author         => 'Pedro Melo <melo@cpan.org>',
    dist_version_from   => 'lib/Threads/CriticalSection.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Threads-CriticalSection-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
