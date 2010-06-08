package Net::HTTP::Console::Role::HTTP::Response;

use MooseX::Declare;

role Net::HTTP::Console::Role::HTTP::Response {

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

    method _show_last_content {
        $self->print($self->_last_http_content);
    }

    method _show_last_headers {
        foreach my $k (keys %{$self->_last_http_response->headers}) {
            $self->print("$k: ".$self->_last_http_response->header($k));
        }
    }

    method _set_and_show($content, $response) {
        $self->_last_http_content($self->_json->pretty->encode($content));
        $self->_last_http_response($response);
        $self->_show_last_content;
    }

}

1;
