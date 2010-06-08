package Net::HTTP::Console::Dispatcher::Headers;

use Moose;
with qw/Net::HTTP::Console::Dispatcher/;

sub dispatch {
    my ($self, $input) = @_;

    (my $command, my $header, my $value) =
      $input =~ /^([\w_]+)(?:\s([\w-]+))?(?:\s(.*))?$/;

    if ($command eq 'unset_header') {
        $self->_unset_header($header);
    }
    elsif ($command eq 'set_header') {
        $self->_set_header($header, $value);
    }
    elsif ($command eq 'show_defined_headers') {
        $self->_show_defined_headers();
    }
}

sub pattern {
    my ($self, $input) = @_;
    $input =~ /(un)?set_header|show_defined_headers/
      ? return $input
      : return 0;
}

sub _unset_header {
    my ($self, $header) = @_;
    $self->application->delete_header($header);
    print "header $header unset\n";
}

sub _set_header {
    my ($self, $header, $value) = @_;
    $self->application->set_header($header, $value);
    print "header $header set to $value\n";
}

sub _show_defined_headers{
    my $self = shift;
    foreach ($self->application->all_headers) {
        print $_->[0].": ".$_->[1]."\n";
    }
}

1;
