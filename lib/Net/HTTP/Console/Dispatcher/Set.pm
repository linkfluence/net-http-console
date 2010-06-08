package Net::HTTP::Console::Dispatcher::Set;

use MooseX::Declare;

class Net::HTTP::Console::Dispatcher::Set with Net::HTTP::Console::Dispatcher {

    method dispatch($input) {
        (my $command, my $type, my $key, my $value) =
          $input =~ /^([\w_]+)(?:\s([\w_]+))(?:\s([\w_]+))(?:\s(.*))?$/;

        if ($command eq 'set') {
            $self->_set_header($key, $value) if $type eq 'header';
        }elsif($command eq 'unset') {
            $self->_unset_header($key) if $type eq 'header';
        }
    }

    method pattern($input) {
        $input =~ /^(un)?set/ ? return $input : return 0;
    }

    method _set_header($header, $value) {
        $self->application->set_header($header, $value);
        $self->application->print("header $header set to $value");
    }

    method _unset_header($header) {
        $self->application->delete_header($header);
        $self->application->print("header $header unset");
    }
}

1;
