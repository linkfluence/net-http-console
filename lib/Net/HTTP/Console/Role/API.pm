package Net::HTTP::Console::Role::API;

use MooseX::Declare;

role Net::HTTP::Console::Role::API {

    use Try::Tiny;

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
            $self->_load_api_lib($self->api_lib);
        },
    );

    method _load_api_lib($lib) {
        my $api;
        try {
            Class::MOP::load_class($lib);
            $self->api_lib($lib);
            $api = $lib->new();
            $api->api_base_url($self->url)  if $self->has_url;
            $api->api_format($self->format) if $self->has_format;
            $api->api_format_mode($self->format_mode)
              if $self->has_format_mode;
        }catch {
            $self->logger('error', "failed to load $lib: $_");
        };
        return $api if $api;
    }

    method load_api_lib($lib) {
        my $object = $self->_load_api_lib($lib);
        $self->api_object($object);
        $self->message("successfully loaded $lib");
    }

    method new_anonymous_method ($http_method, $path) {
        try {
            $self->api_object->meta->add_net_api_method(
                'anonymous',
                method => $http_method,
                path   => $path,
            );
        }catch {
            $self->logger('error', "failed to add anonymous method: ".$_);
        }
    }
}

1;
