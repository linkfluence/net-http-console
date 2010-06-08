package Net::HTTP::Console::Role::Plugins;

use MooseX::Declare;

role Net::HTTP::Console::Role::Plugins {

    has dispatchers => (
        is         => 'rw',
        isa        => 'ArrayRef[Str]',
        traits     => ['Array'],
        lazy       => 1,
        auto_deref => 1,
        default    => sub {
            [qw/Load HTTP Help Method Set/],
        }
    );

    has plugins => (
        traits  => ['Array'],
        is      => 'rw',
        isa     => 'ArrayRef[Object]',
        lazy    => 1,
        handles => {all_plugins => 'elements', add_plugin => 'push'},
        default => sub {
            my $self = shift;
            my @p;
            for ($self->dispatchers) {
                my $p = "Net::HTTP::Console::Dispatcher::" . $_;
                Class::MOP::load_class($p);
                my $o = $p->new(application => $self);
                push @p, $o;
            }
            \@p;
        },
    );
}

1;
