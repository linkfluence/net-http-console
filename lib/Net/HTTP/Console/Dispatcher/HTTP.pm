package Net::HTTP::Console::Dispatcher::HTTP;

use MooseX::Declare;

class Net::HTTP::Console::Dispatcher::HTTP with Net::HTTP::Console::Dispatcher {

    use Try::Tiny;

    method pattern($input) {
        $input =~ /^(?:GET|POST|PUT|DELETE|HEAD)\s/ ? return $input : return 0;
    }

    method dispatch($input) {
        $self->_clean_http_lib;

        my ($method, $path, $body);
        if (($method, $path) = $input =~ /^(GET|DELETE)\s(.*)$/) {
            $self->_do_request($method, $path);
        }
        elsif (($method, $path, $body) = $input =~ /^(POST|PUT)\s(.*)(?:\s(.*))$/) {
            $self->_do_request_with_body($method, $path, $body);
        }
        else {
            # XXX unsupporter method
        }
        return 1;
    }

    method _do_request($http_method, $path) {
        $self->application->new_anonymous_method($http_method, $path);
        try {
            my ($content, $result) = $self->application->api_object->anonymous;
            $self->application->_set_and_show($content, $result);
        }catch{
            # XXX error
        };
    }

    method _clean_http_lib {
        if ($self->application->api_lib eq "Net::HTTP::Console::Dummy") {
            map { $self->application->api_lib->meta->remove_net_api_method($_) }
              $self->application->api_lib->meta->get_all_net_api_methods();
        }
    }

    method _do_request_with_body($http_method, $path, $body) {
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
}

1;
