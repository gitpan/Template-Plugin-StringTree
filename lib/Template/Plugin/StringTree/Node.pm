package Template::Plugin::StringTree::Node;

# This package implements the actual nodes in the StringTree.
# We need to be very careful not to pollute this namespace with methods.

use strict;
use Scalar::Util ();
use overload '""'   => '__get';
use overload 'bool' => sub { 1 };

use vars qw{$VERSION};
BEGIN {
	$VERSION = '0.04';
}

# Create the data store for the Nodes
use vars qw{%STRING};
BEGIN {
	%STRING = ();
}

# Create a new node, with an optional value
sub __new {
	my $class = ref $_[0] ? ref shift : shift;
	my $self = bless {}, $class;

	if ( defined $_[0] and ! ref $_[0] ) {
		# The value for this node
		$STRING{Scalar::Util::refaddr $self} = shift;
	}

	$self;
}

# Get the value for this node
sub __get {
	my $self = ref $_[0] ? shift : return undef;
	$STRING{Scalar::Util::refaddr $self};
}

# Set the value for this node
sub __set {
	my $self = ref $_[0] ? shift : return undef;
	if ( defined $_[0] ) {
		$STRING{Scalar::Util::refaddr $self} = shift;
	} else {
		delete $STRING{Scalar::Util::refaddr $_[0]};
	}

	1;
}

# Unfortunately, we have no choice but to use this name.
# To prevent pollution, we'll throw an error should we ever try to set
# a value using a DESTROY segment in a path.
sub DESTROY {
	delete $STRING{Scalar::Util::refaddr $_[0]} if ref $_[0];
}

1;
