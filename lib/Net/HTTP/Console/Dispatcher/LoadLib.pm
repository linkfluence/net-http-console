package Net::HTTP::Console::Dispatcher::LoadLib;

use Moose;
use namespace::autoclean;

with qw/Net::HTTP::Console::Dispatcher/;

sub dispatch {
    my ($self, $input) = @_;
    $self->application->load_api_lib($input);
}

sub pattern {
    my ($self, $input) = @_;
    $input =~ /load\s(.*)$/ ? $1 : 0;
}

1;
