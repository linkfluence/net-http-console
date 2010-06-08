package Net::HTTP::Console::Dispatcher::Method;

use MooseX::Declare;

class Net::HTTP::Console::Dispatcher::Method with Net::HTTP::Console::Dispatcher {

    method dispatch($input) {
        (my $method, my $args) = $input =~ /^(\w+)\s(.*)$/;
        my ($content, $response) =
          $self->application->api_object->$method(%{JSON::decode_json($args)});
        $self->application->_set_and_show($content, $response);
        1;
    }

    method pattern($input) {
        (my $method) = $input =~ /^(\w+)/;

        # XXX find_api_method_by_name ?
        $self->application->api_object->meta->find_method_by_name($method)
          ? return $input
            : return 0;
    }

}

1;
