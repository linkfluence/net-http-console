package Net::HTTP::Console::Role::DefaultMethod;

use Moose::Role;
use JSON;
use Method::Signatures::Simple;
use namespace::autoclean;

with qw/Net::HTTP::Console::Role::HTTP/;

method from_lib {
    my $input = shift;
    $input =~ /^(\w+)\s(.*)$/;
    my $method = $1;
    my $args   = $2;
    my $o      = $self->lib->new();
    my ($content, $response) = $o->$method(%{JSON::decode_json($args)});
    $self->_set_and_show($content, $response);
}

1;
