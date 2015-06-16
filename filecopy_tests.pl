#!/usr/bin/perl -w
#
use strict;

use XML::Simple;
use Data::Dumper;
use Time::Piece;
use threads;

my $download_output = 0;

sub downloader_thread {
  my $i = 0;
  print "Downloader Thread\n";
  while ($i < 5) {
    sleep (1);
    if ($download_output) {
      print "*";
    }
    $i++;
  }
}

my $a = { 
          "Camera1" => { uuid => '284aca4e-6d05-451a-b2d4-58e952ea42e8', lastimport => "16/06/2015" },
          "Camera2" => { uuid => '6feff0cd-d598-45e1-adcf-23522c5a5a0d', lastimport => "16/06/2015" } 
        
        };

my $xmlout = XMLout($a);

print "$xmlout";

my $b = XMLin($xmlout);

print Dumper($b);

foreach my $key (keys($b)) {
  print $key . "\n";
  if ($b->{$key}->{uuid} eq '6feff0cd-d598-45e1-adcf-23522c5a5a0d') {
    print $b->{$key}->{lastimport} . "\n";
  }
}

print "Add Camera: ";

my $cam = <STDIN>;
print "Add UUID: ";
my $uuid = <STDIN>;
chomp $uuid;
chomp $cam;
my $timedate = localtime();
$b->{$cam} = { uuid => $uuid, lastimport => $timedate->datetime, tzoffset => $timedate->tzoffset->hours };

$xmlout = XMLout($b);
print "$xmlout";

 # Create a thread with a specific context and stack size
my $thr = threads->create({ 'context' => 'list',
                            'stack_size' => 32*4096,
                            'exit' => 'thread_only' },
                            \&downloader_thread);

print "Enter Description: \n";
my $desc;
while (<STDIN>) {
    last if /^END$/;
    $desc .= $_;
}

print "Desc: $desc\n";
$download_output = 1;

 # Get thread's context
 #my $wantarray = $thr->wantarray();
# Check thread's state
while ($thr->is_running()) {
  sleep(1);
}

if ($thr->is_joinable()) {
  $thr->join();
}
# Send a signal to a thread
#$thr->kill('SIGUSR1');
# Exit a thread
#threads->exit();

my $dataDownload = {
  file1 => {
    fname => "filename",
    sum => "bdfd6cfa459da456e61c9ac7ee12caa3791a045d2432f672e965a0f9213a372d",
    descfile => "descfile",
  },
  file2 => {
    fname => "filename1",
    sum => "c6657d0f4b06440abf438e5bc63323daffbfc02ae8ca50085b9e9cb9fe91964c",
    descfile => "descfile",
  }
};

$xmlout = XMLout($dataDownload);

print "$xmlout";
