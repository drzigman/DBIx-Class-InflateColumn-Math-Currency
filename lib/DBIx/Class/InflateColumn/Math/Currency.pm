package DBIx::Class::InflateColumn::Math::Currency;

use strict;
use warnings;

use base qw/DBIx::Class/;

use Math::Currency;
use Scalar::Util qw(looks_like_number);
use Carp;

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
            inflate => \&_inflate,
            deflate => \&_deflate,
        }
    );
}

sub _inflate {
    my $value = shift;

    if(ref $value eq "Math::Currency") {
        return $value;
    }
    elsif(looks_like_number($value)) {
        return Math::Currency->new($value);
    }
    else {
        croak "Failed to inflate " . $value
            . ".  This value is not a Math::Currency object nor does it look like a number";
    }
}

sub _deflate {
    my $value = shift;

    if(ref $value eq "Math::Currency") {
        return $value->as_float;
    }
    elsif(looks_like_number($value)) {
        return $value;
    }
    else {
        croak "Failed to deflate " . $value
            . ".  This value is not a Math::Currency object nor does it look like a number";
    }
}

1;

__END__           
