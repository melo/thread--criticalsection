#!perl -T

use strict;
use warnings;
use Test::More tests => 1;
use File::Temp qw/ :POSIX /;

use threads;
#use Threads::CriticalSection;

#my $cs = Threads::CriticalSection->new;

# create 50 pairs of threads, one increments, the other decrements a counter
# run each thread for 10.000 loops
# counter must be zero at the end

my $n_threads = 50;
my $n_loops = 100;
#my $cs = Threads::CriticalSection->new;

sub _unsafe_add_delta_to_counter {
  my ($delta, $n_loops, $counter_fn) = @_;
  
  while ($n_loops--) {
    my $counter = _counter_read($counter_fn);
    print "# got counter '$counter' from '$counter_fn', iter '$n_loops/$delta'\n";
    $counter += $delta;
    _counter_write($counter_fn, $counter);
  }
}

# sub _safe_add_delta_to_counter {
#   my ($delta, $n_loops, $counter_fn) = @_;
#   
#   while ($n_loops--) {
#     $cs->execute(sub {
#       my $counter = _counter_read($counter_fn);
# #      diag("got counter '$counter' from '$counter_fn', iter '$n_loops/$delta'");
#       $counter += $delta;
#       _counter_write($counter_fn, $counter);
#     });
#   }
# }


# Start the racers, unsafe race
my $value = _run_threads(\&_unsafe_add_delta_to_counter, $n_threads, $n_loops);
isnt($value, 0, 'Counter is not 0, not safe updates');

# Start the racers, safe race
# $value = _run_threads(\&_unsafe_add_delta_to_counter, $n_threads, $n_loops);
# is($value, 0, 'Counter is 0, safe updates');



##############
# Thread stuff

sub _run_threads {
  my ($sub, $n_threads, $n_loops) = @_;
  my @thrs;
  
  # Create and reset counter to 0
  my $counter_fn = tmpnam();
  _counter_write($counter_fn, 0);
  
  diag("Starting all $n_threads thread pairs");
  while ($n_threads--) {
    push @thrs, scalar(threads->create($sub, +1, $n_loops, $counter_fn));
    push @thrs, scalar(threads->create($sub, -1, $n_loops, $counter_fn));
  }
  
  diag("Waiting for all threads to join us");
  foreach my $thr (@thrs) {
    $thr->join;
  }
  
  return _counter_read($counter_fn);
}


###############
# Counter funcs

sub _counter_write {
  my ($fn, $value) = @_;
  
  if (open(my $fh, '>', $fn)) {
    print $fh "$value\n";
    return if close($fh);
  }
  
  die "Error writing new value to counter '$fn': $!,";
}

sub _counter_read {
  my ($fn) = @_;
  
  if (open(my $fh, '<', $fn)) {
    my $r = <$fh> || 0;
    chomp($r);
    return $r if close($fh);
  }
  
  die "Error reading value from counter '$fn': $!,";
}
