package Net::HTTP::Console;

use Moose;
use Try::Tiny;
use Method::Signatures::Simple;
use namespace::autoclean;

with qw/MooseX::Getopt/;

has url         => (isa => 'Str', is => 'rw');
has format      => (isa => 'Str', is => 'rw', default => 'json');
has format_mode => (isa => 'Str', is => 'rw', default => 'content-type');
has lib => (
    isa     => 'Str',
    is      => 'rw',
    default => sub {
        Class::MOP::load_class('Net::HTTP::Console::Dummy');
        'Net::HTTP::Console::Dummy';
    },
    handles => qr/.*/,
);
has prompt => (
    isa     => 'Str',
    is      => 'rw',
    lazy    => 1,
    default => sub {
        my $self = shift;
        # FIXME
#        my $url = $self->lib->api_base_url ? $self->lib->api_base_url : $self->url;
#        my $url= "http";
        return $self->url . '> ';
    }
);
has plugins => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef[Object]',
    lazy    => 1,
    handles => {all_plugins => 'elements', add_plugin => 'push'},
    default => sub {
        my $self = shift;
        my @p;
        for (qw/LoadLib HTTPRequest Help ExecuteMethod/) {
            my $p = "Net::HTTP::Console::Dispatcher::" . $_;
            Class::MOP::load_class($p);
            my $o = $p->new(application => $self);
            push @p, $o;
        }
        \@p;
    },
);

sub BUILDARGS {
    my ($class, %args) = @_;
    if ($args{lib}) {
        Class::MOP::load_class($args{lib});
    }
    return {%args};
}

method dispatch($input) {
    my @plugins = $self->all_plugins();
      my $result;
      foreach (@plugins) {
        $result = $_->dispatch($input);
        last if $result;
    }
    # if (!$result) {
    # try {

    # }
    # catch {
    #     warn $_;
    #     print "no command found!\n" unless $result;
    # };
#}
}

method new_lib($http_method, $path) {
    my $lib = $self->lib->new(
        api_base_url    => $self->url,
        api_format      => $self->format,
        api_format_mode => $self->format_mode,
    );
    $lib->meta->add_net_api_method(
        'anonymous',
        method => $http_method,
        path   => $path,
    );
    return $lib;
}

no Moose;

1;
