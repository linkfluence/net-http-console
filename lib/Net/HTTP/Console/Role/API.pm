package Net::HTTP::Console::Role::API;

use MooseX::Declare;

role Net::HTTP::Console::Role::API {

    has api_lib => (
        isa     => 'Str',
        is      => 'rw',
        default => 'Net::HTTP::Console::Dummy'
    );

    has api_object => (
        isa     => 'Object',
        is      => 'rw',
        lazy    => 1,
        default => sub {
            my $self = shift;
            $self->load_api_lib($self->api_lib);
        },
    );

    method load_api_lib($lib) {
        Class::MOP::load_class($lib);
        $self->api_lib($lib);
        my $o = $lib->new();
        $o->api_base_url($self->url)            if $self->has_url;
        $o->api_format($self->format)           if $self->has_format;
        $o->api_format_mode($self->format_mode) if $self->has_format_mode;
        $o;
    }

}

1;
