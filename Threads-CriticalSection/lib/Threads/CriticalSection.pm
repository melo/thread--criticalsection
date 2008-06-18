package Threads::CriticalSection;

use warnings;
use strict;
use Thread::Semaphore;

our $VERSION = '0.01';


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


42; # End of Threads::CriticalSection


=head1 NAME

Threads::CriticalSection - Run a coderef inside a critical section

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use threads;
    use Threads::CriticalSection;
    
    my $cs = Threads::CriticalSection->new;
    
    $cs->execute(sub {
      # your code is protected by $cs
    });
    
    # you can also return stuff
    my $result = $cs->execute(sub {
      # do work in a cosy critical section
      return $result;
    });
    
    # and you can even use wantarray
    my @victims = $cs->execute(sub {
      # do work in a cosy critical section
      return wantarray? @result : \@result;
    });


=head1 STATUS

As of 2008/06/18, this module is considered beta quality. The interface
should not suffer any changes but its a young module with very little use.


=head1 DESCRIPTION

The Threads::CriticalSection module allows you to run a coderef inside a
critical section.

All the details of entering and leaving the critical section are taken care
of by the C<execute()> method.

You can have several critical sections simultaneously inside your program.
The usual care and feeding regarding deadlocks should be taken when calling
execute recursively.


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
