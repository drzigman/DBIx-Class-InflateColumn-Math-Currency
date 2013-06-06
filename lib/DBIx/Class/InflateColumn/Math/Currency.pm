package DBIx::Class::InflateColumn::Math::Currency;

use strict;
use warnings;
use base qw/DBIx::Class/;
use Math::Currency;
use namespace::autoclean;

# VERSION
# ABSTRACT: Automagically inflates decimal columns into Math::Currency objects

__PACKAGE__->load_components(qw/InflateColumn/);

sub register_column {
    my ($self, $column, $info, @rest) = @_;

    $self->next::method($column, $info, @rest);

    return unless $info->{data_type} eq 'decimal';

    $self->inflate_column(
        $column => {
            inflate => _inflate($value, $object),
            deflate => _default($value, $object),
        }
    );
}

sub _inflate {
    my ($value, $object) = @_;

    return Math::Currency->new($value);
}

sub _deflate {
    my ($value, $object) = @_;

    return $value->as_float;
}

1;

__END__           
