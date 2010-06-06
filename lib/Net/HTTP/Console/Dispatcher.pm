package Net::HTTP::Console::Dispatcher;

use Moose::Role;

has application => (is => 'rw', isa => 'Net::HTTP::Console');

requires qw/dispatch pattern/;

around dispatch => sub {
    my $orig = shift;
    my $self = shift;
    my $in   = shift;

    if (my $r = $self->pattern($in)) {
        return $self->$orig($r);
    }else{
        return undef;
    }
};

1;
