package Net::HTTP::Console::Dispatcher::Help;

use Moose;
with qw/Net::HTTP::Console::Dispatcher/;

sub dispatch {
    my ($self, $input) = @_;

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

sub pattern {
    my ($self, $input) = @_;
    $input =~ /^help/ ? return $input : return 0;
}

sub _display_help {
    print <<EOF
help command    -  help about a command
help request    -  help on how to write request
EOF
}

sub _list_commands {
    my $self = shift;
    my @methods =
      $self->application->api_object->meta->get_all_net_api_methods();

    if (!@methods) {
        print "no method available\n";
        return;
    }

    print "available commands:\n";
    map { print "- " . $_ . "\n" } @methods;
}

sub _get_help_for_command {
    my ($self, $cmd_name) = @_;

    my $method =
      $self->application->api_object->meta->find_net_api_method_by_name(
        $cmd_name);

    if (!$method) {
        print "unknown method " . $cmd_name . "\n";
        return;
    }

    print $method->documentation;
}

1;
