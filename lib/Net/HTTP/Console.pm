package Net::HTTP::Console; # For PAUSE
our $VERSION = 0.01;

use MooseX::Declare;

class Net::HTTP::Console {
    use Try::Tiny;

    with 'MooseX::Getopt';
    with 'Net::HTTP::Console::Role::Headers';
    with 'Net::HTTP::Console::Role::Prompt';
    with 'Net::HTTP::Console::Role::Plugins';
    with 'Net::HTTP::Console::Role::API';
    with 'Net::HTTP::Console::Role::HTTP::Response';

    has url         => (isa => 'Str', is => 'rw', predicate => 'has_url');
    has format      => (isa => 'Str', is => 'rw', predicate => 'has_format');
    has format_mode => (isa => 'Str', is => 'rw', predicate => 'has_format_mode');

    method dispatch ($input)  {
        my $result;
        try {
            foreach ($self->all_plugins) {
                last if ($result = $_->dispatch($input));
            }
        }catch{
            print "[ERROR]: ".$_;
        };
    }

    method new_anonymous_method ($http_method, $path) {
        $self->api_object->meta->add_net_api_method(
            'anonymous',
            method => $http_method,
            path   => $path,
        );
    }
}

1;
