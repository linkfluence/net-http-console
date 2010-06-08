package Net::HTTP::Console::Role::Prompt;

use MooseX::Declare;

role Net::HTTP::Console::Role::Prompt {

    has prompt => (
        isa     => 'Str',
        is      => 'rw',
        lazy    => 1,
        default => sub {
            my $self = shift;
            my $url  = $self->api_object->api_base_url;
            return ($url || '[no url defined!]') . '> ';
        }
    );

}

1;
