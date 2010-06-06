package Net::HTTP::Console::Dispatcher::HTTPRequest;

use Moose;
use Try::Tiny;

with qw/
  Net::HTTP::Console::Dispatcher
  Net::HTTP::Console::Role::HTTP
  /;

sub _clean_http_lib {
    my $self = shift;
    if ($self->application->lib eq "Net::HTTP::Console::Dummy") {
        map { $self->application->lib->meta->remove_net_api_method($_) }
          $self->application->lib->meta->get_all_api_methods();
    }
}

sub dispatch {
    my ($self, $input) = @_;

    $self->_clean_http_lib;

    if ($input =~ /^(GET|DELETE)\s(.*)$/) {
        $self->_do_request($1, $2);
    }
    elsif ($input =~ /^(POST|PUT)\s(.*)(?:\s(.*))$/) {
        $self->_do_request_with_body($1, $2, $3);
    }
    elsif($input =~ /^show\s(headers|content)$/) {
        my $method = "_show_last_$1";
        $self->$method;
    }
    else {
        # XXX unsupporter method
    }
    return 1;
}

sub pattern {
    my ($self, $input) = @_;
    $input =~ /^(?:GET|POST|PUT|DELETE|HEAD|show)/ ? return $input : return 0;
}

sub _do_request {
    my ($self, $http_method, $path) = @_;
    my $http_console = $self->application->new_lib($http_method, $path);
    try {
        my ($content, $result) = $http_console->anonymous;
        $self->_set_and_show($content, $result);
    };
}

sub _do_request_with_body {
    my ($self, $http_method, $path, $body) = @_;
    my $http_console = $self->application->new_lib($http_method, $path);
    $http_console->api_useragent->add_handler(
        request_prepare => sub {
            my $request = shift;
            $request->content($body);
        }
    );
    try {
        my ($content, $result) = $http_console->anonymous;
        $self->_set_and_show($content, $result);
    };
}

no Moose;

1;
