package Net::HTTP::Console::Role::Plugins;

use MooseX::Declare;

role Net::HTTP::Console::Role::Plugins {

    use Try::Tiny;

    has dispatchers => (
        is         => 'rw',
        isa        => 'ArrayRef[Str]',
        traits     => ['Array'],
        lazy       => 1,
        auto_deref => 1,
        default    => sub {
            [qw/Load HTTP Help Method Set View/],
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
}

1;
