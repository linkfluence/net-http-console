package Net::HTTP::Console::Dispatcher;

use MooseX::Declare;

role Net::HTTP::Console::Dispatcher {

    has application => (is => 'rw', isa => 'Net::HTTP::Console');

    requires qw/dispatch pattern/;

    around dispatch ($input) {
        if (my $r = $self->pattern($input)) {
            return $self->$orig($r);
        }
        else {
            return undef;
        }
    };

}

1;
