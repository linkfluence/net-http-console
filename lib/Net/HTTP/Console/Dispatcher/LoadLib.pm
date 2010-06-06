package Net::HTTP::Console::Dispatcher::LoadLib;

use Moose;
use namespace::autoclean;

with qw/Net::HTTP::Console::Dispatcher/;

sub dispatch {
    my ($self, $input) = @_;
    if (Class::MOP::load_class($input)) {
        print "loaded ".$input."\n";
        $self->application->lib($input);
        return 1;
    }
    # XXX error confess & co
}

sub pattern {
    my ($self, $input) = @_;
    $input =~ /load\s(.*)$/ ? $1 : 0;
}

1;
