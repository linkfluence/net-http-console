package Net::HTTP::Console::Dispatcher::View;

use MooseX::Declare;

class Net::HTTP::Console::Dispatcher::View with Net::HTTP::Console::Dispatcher {

    method pattern ($input) {
        $input =~ /^show/ ? return $input : return 0;
    }

    method dispatch ($input) {
        (my $key) = $input =~ /^show ([\w]+)/;

        if ($key eq 'headers') {
            $self->application->_show_last_headers;
        }
        elsif ($key eq 'content') {
            $self->application->_show_last_content;
        }
        elsif ($key eq 'defined_headers') {
            foreach ($self->application->all_headers) {
                print $_->[0] . ': ' . $_->[1] . "\n";
            }
        }
    }
}

1;
