package Net::HTTP::Console::Role::Headers;

use MooseX::Declare;

role Net::HTTP::Console::Role::Headers {
    
    has custom_headers => (
        traits  => ['Hash'],
        is      => 'ro',
        isa     => 'HashRef[Str]',
        default => sub { {} },
        handles => {
            set_header     => 'set',
            get_header     => 'get',
            has_no_headers => 'is_empty',
            delete_header  => 'delete',
            all_headers    => 'kv',
        },
    );
}

1;
