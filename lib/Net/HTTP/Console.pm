package Net::HTTP::Console; # For PAUSE
our $VERSION = 0.01;

use MooseX::Declare;

class Net::HTTP::Console {

    with 'MooseX::Getopt';
    with 'Net::HTTP::Console::Role::Headers';
    with 'Net::HTTP::Console::Role::Prompt';
    with 'Net::HTTP::Console::Role::Plugins';
    with 'Net::HTTP::Console::Role::API';
    with 'Net::HTTP::Console::Role::HTTP::Response';

    has url         => (isa => 'Str', is => 'rw', predicate => 'has_url');
    has format      => (isa => 'Str', is => 'rw', predicate => 'has_format');
    has format_mode => (isa => 'Str', is => 'rw', predicate => 'has_format_mode');
}

1;
