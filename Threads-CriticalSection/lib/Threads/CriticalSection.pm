package Threads::CriticalSection;

use warnings;
use strict;

use Thread::Semaphore;

sub new {
  my $class = shift;
  
  return bless {
    sem => Thread::Semaphore->new,
  }, $class;
}

sub execute {
  my ($self, $sub) = @_;
  my $sem = $self->{sem};
  
  my $wantarray = wantarray;
  my @result;
  
  $sem->down;
  
  eval {
    if ($wantarray) { @result    = $sub->() }
    else            { $result[0] = $sub->() }
  };

  my $e = $@;
  $sem->up;
  
  die $e if $e;
  
  return @result if $wantarray;
  return $result[0];
}


=head1 NAME

Threads::CriticalSection - The great new Threads::CriticalSection!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Threads::CriticalSection;

    my $foo = Threads::CriticalSection->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Pedro Melo, C<< <melo at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-threads-criticalsection at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Threads-CriticalSection>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Threads::CriticalSection


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Threads-CriticalSection>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Threads-CriticalSection>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Threads-CriticalSection>

=item * Search CPAN

L<http://search.cpan.org/dist/Threads-CriticalSection>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Pedro Melo, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Threads::CriticalSection
