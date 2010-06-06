package Net::HTTP::Console::Dispatcher::Help;

use Moose;
with qw/Net::HTTP::Console::Dispatcher/;

sub dispatch {
    my ($self, $input) = @_;
    $input =~ /^help\s(.*)?/;
    my $cmd = $1;
    if ($cmd) {
    }else{
        print <<EOF
help command    -  help about a command
help request    -  help about request
EOF

    }
}

sub pattern {
    my ($self, $input) = @_;
    $input =~ /^help/ ? return $input : return 0;
}

1;
