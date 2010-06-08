package Net::HTTP::Console::Dispatcher::Help;

use MooseX::Declare;

class Net::HTTP::Console::Dispatcher::Help with Net::HTTP::Console::Dispatcher {

    method pattern($input) {
        $input =~ /^help/ ? return $input : return 0;
    }

    method dispatch($input) {
        (my $cmd, my $cmd_name) = $input =~ /^help\s(\w+)?\s?(\w+)?/;

        if ($cmd) {
            if ($cmd eq 'command' && $cmd_name) {
                $self->_get_help_for_command($cmd_name);
            }
            elsif ($cmd eq 'command') {
                $self->_list_commands();
            }elsif($cmd eq 'view') {
                $self->_help_about_view();
            }elsif($cmd eq 'set') {
                $self->_help_about_set();
            }elsif($cmd eq 'request') {
                $self->_help_about_request();
            }elsif($cmd eq 'load') {
                $self->_help_about_load();
            }
        }
        else {
            $self->_display_help();
        }
        1;
    }

    method _display_help {
        print <<EOF
help command    -  help about a command
help request    -  help on how to write request
help set        -  help on how to set values
help view       -  help on how to view values
help load       -  help on how to load a lib
EOF
    }

    method _help_about_view {
        print <<EOF
view headers         -  show the headers of the last request
view content         -  show the last content
view defined_headers -  show the defined headers
EOF
    }

    method _help_about_set {
        print <<EOF
set header key value   -  set the value for a header (global)
EOF
    }

    method _help_about_request {
        print <<EOF
HTTP Method path    -  make a HTTP request on a path
EOF
    }

    method _help_about_load {
        print <<EOF
load libname    -  load a MooseX::Net::API library

        print "available commands:\n";
        map { print "- " . $_ . "\n" } @methods;
    }

    method _get_help_for_command($cmd_name) {
        my $method =
          $self->application->api_object->meta->find_net_api_method_by_name($cmd_name);

        if (!$method) {
            print "unknown method " . $cmd_name . "\n";
            return;
        }

        print $method->documentation;
    }
}

1;
