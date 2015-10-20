use ExtUtils::MakeMaker;

WriteMakefile(
    NAME           => 'Net::Cisco::MSE::REST',
    VERSION_FROM   => 'lib/Net/Cisco/MSE/REST.pm',
    ABSTRACT_FROM  => 'lib/Net/Cisco/MSE/REST.pm',
    LICENSE        => 'GPL_3',
    PREREQ_PM => {
        'JSON'           => 0,
        'LWP::UserAgent' => 0,
    },
    TEST_REQUIRES  => {
        'Test::More' => 0,
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        'resources' => {
            repository => {
                type => 'git',
                url  => 'git://github.com/fdurand/Net-Cisco-MSE-REST',
                web  => 'https://github.com/fdurand/Net-Cisco-MSE-REST'
            },
        }
    }
);
