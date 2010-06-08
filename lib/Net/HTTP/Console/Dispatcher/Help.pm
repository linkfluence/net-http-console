package Net::HTTP::Console::Dispatcher::Help;

use MooseX::Declare;

class Net::HTTP::Console::Dispatcher::Help with Net::HTTP::Console::Dispatcher {

    method dispatch($input) {
        (my $cmd, my $cmd_name) = $input =~ /^help\s(\w+)?\s?(\w+)?/;

        if ($cmd) {
            if ($cmd eq 'command' && $cmd_name) {
                $self->_get_help_for_command($cmd_name);
            }
            elsif ($cmd eq 'command') {
                $self->_list_commands();
            }
        }
        else {
            $self->_display_help();
        }
        1;
    }

    method pattern($input) {
        $input =~ /^help/ ? return $input : return 0;
    }

    method _display_help {
        print <<EOF
help command    -  help about a command
help request    -  help on how to write request
EOF
    }

      method _list_commands {
          my @methods =
            $self->application->api_object->meta->get_all_net_api_methods();

          if (!@methods) {
              print "no method available\n";
              return;
          }

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
