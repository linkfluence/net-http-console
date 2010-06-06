package Net::HTTP::Console::Dispatcher::ExecuteMethod;

use Moose;
with qw/
  Net::HTTP::Console::Dispatcher
  Net::HTTP::Console::Role::HTTP
  /;

sub dispatch {
    my ($self, $input) = @_;
    $input =~ /^(\w+)\s(.*)$/;
    my $method = $1;
    my $args   = $2;
    my $o      = $self->lib->new();
    my ($content, $response) = $o->$method(%{JSON::decode_json($args)});
    $self->_set_and_show($content, $response);
}

sub pattern {
    my ($self, $input) = @_;
    $input =~ /^(\w+)/;
    my $method = $1;
    # find_api_method_by_name ?
    if ($self->application->lib->meta->find_method_by_name($method)) {
        return 1;
    }else{
        return 0;
    }
}

1;
