package Net::HTTP::Console::Dispatcher::HTTPRequest;

use Moose;
use Try::Tiny;

with qw/ Net::HTTP::Console::Dispatcher /;

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
    elsif ($input =~ /^show\s(headers|content)$/) {
        my $method = "_show_last_$1";
        $self->application->$method;
    }
    else {

        # XXX unsupporter method
    }
    return 1;
}

sub pattern {
    my ($self, $input) = @_;
    $input =~ /^(?:GET|POST|PUT|DELETE|HEAD|show)\s/ ? return $input : return 0;
}

sub _do_request {
    my ($self, $http_method, $path) = @_;
    $self->application->new_anonymous_method($http_method, $path);
    try {
        my ($content, $result) = $self->application->api_object->anonymous;
        $self->application->_set_and_show($content, $result);
    }catch{
        warn $_;
    };
}

sub _do_request_with_body {
    my ($self, $http_method, $path, $body) = @_;
    $self->application->new_anonymous_method($http_method, $path);

    # XXX clean handlers
    $self->application->api_object->api_useragent->add_handler(
        request_prepare => sub {
            my $request = shift;
            $request->header('Content-Type' => 'application/json');
            $request->content('{"foof":"bar"}');
        }
    );
    try {
        my ($content, $result) = $self->application->api_object->anonymous;
        $self->application->_set_and_show($content, $result);
    }catch{
        warn $_;
        use YAML::Syck;
        warn Dump $_->http_error;
    };
}

no Moose;

1;
