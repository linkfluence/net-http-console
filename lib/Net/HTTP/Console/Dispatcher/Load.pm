package Net::HTTP::Console::Dispatcher::Load;

use MooseX::Declare;

class Net::HTTP::Console::Dispatcher::Load with Net::HTTP::Console::Dispatcher {

    method dispatch($input) {
        $self->application->load_api_lib($input);
    }

    method pattern($input) {
        $input =~ /load\s(.*)$/ ? $1 : 0;
    }

}

1;
