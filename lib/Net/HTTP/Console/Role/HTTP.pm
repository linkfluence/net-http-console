package Net::HTTP::Console::Role::HTTP;

use Moose::Role;

has _last_http_response => (
    is      => 'rw',
    isa     => 'Object',
    clearer => '_clear_last_http_response',
);
has _last_http_content => (
    is      => 'rw',
    isa     => 'Str',
    clearer => '_clear_last_http_content',
);
has _json => (
    is      => 'rw',
    isa     => 'Object',
    lazy    => 1,
    default => sub { JSON->new; },
);

sub _show_last_content {
    my $self = shift;
    print $self->_last_http_content;
}

sub _show_last_headers {
    my $self = shift;
    foreach my $k (keys %{$self->_last_http_response->headers}) {
        print "$k: ".$self->_last_http_response->header($k)."\n";
    }
}

sub _set_and_show {
    my ($self, $content, $response) = @_;
    my $json = $self->_json->pretty->encode($content);
    $self->_last_http_content($json);
    $self->_last_http_response($response);
    $self->_show_last_content;
}

1;
