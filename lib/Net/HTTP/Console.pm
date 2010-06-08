package Net::HTTP::Console;

use Moose;
use Try::Tiny;
use Method::Signatures::Simple;
use namespace::autoclean;

with qw/
  MooseX::Getopt
  Net::HTTP::Console::Role::APILib
  Net::HTTP::Console::Role::HTTP
  Net::HTTP::Console::Role::Headers
  /;

has url         => (isa => 'Str', is => 'rw', predicate => 'has_url');
has format      => (isa => 'Str', is => 'rw', predicate => 'has_format');
has format_mode => (isa => 'Str', is => 'rw', predicate => 'has_format_mode');
has prompt => (
    isa     => 'Str',
    is      => 'rw',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $url = $self->api_object->api_base_url;
        return ($url || '[no url defined!]') . '> ';
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
        for (qw/LoadLib HTTPRequest Help ExecuteMethod Headers/) {
            my $p = "Net::HTTP::Console::Dispatcher::" . $_;
            Class::MOP::load_class($p);
            my $o = $p->new(application => $self);
            push @p, $o;
        }
        \@p;
    },
);

method dispatch($input) {
    my $result;
    try {
        foreach ($self->all_plugins) {
            $result = $_->dispatch($input);
            last if $result;
        }
    }
    catch {
        print "[ERROR] : " . $_;
    };
}

method new_anonymous_method($http_method, $path) {
    $self->api_object->meta->add_net_api_method(
        'anonymous',
        method => $http_method,
        path   => $path,
    );
}

no Moose;

1;
