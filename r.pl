#!/usr/bin/perl
use strict;
use warnings;
use Storable;
use List::Util qw/sum/;
use Chart::Gnuplot;

use 5.010;

my $h = retrieve('weather.dat');
my @d;
foreach (@$h)
{
    my $name = $_->{name};
    my $highs = $_->{high};
    my $lows = $_->{low};
    my $avgH = sum(@$highs)/@$highs;
    my $avgL = sum(@$lows)/@$lows;
    my @over28 = grep {$_>=28} @$lows;
    my @over33 = grep {$_>=33} @$highs;
    push(@d, {name=>$name, h=>$avgH, l=>$avgL, over28=>\@over28, over33=>\@over33});
}

sub p
{
    foreach (@_)
    {
        printf("city: %12s  avgH: %5.2f   avgL: %5.2f  over28: %2d  over33 %2d, \n", $_->{name}, $_->{h}, $_->{l}, scalar(@{$_->{over28}}), scalar(@{$_->{over33}}) );
    }
}

say "sort by h:";
p(sort {$a->{h} <=> $b->{h}} @d);

say "sort by l:";
p(sort {$a->{l} <=> $b->{l}} @d);

say "sort by over28:";
p(sort {scalar(@{$a->{over28}}) <=> scalar(@{$b->{over28}}) } @d);

# Create chart object and specify the properties of the chart
my $chart = Chart::Gnuplot->new(
    output => "simple.png",
    title  => "Simple testing",
    xlabel => "My x-axis label",
    ylabel => "My y-axis label",
);

my @x = map {$_->{name}} @d;
my @y = map {scalar(@{$_->{over28}})} @d;
# Create dataset object and specify the properties of the dataset
my $dataSet = Chart::Gnuplot::DataSet->new(
    xdata => \@x,
    ydata => \@y,
    title => "Plotting a line from Perl arrays",
    style => "linespoints",
);

$chart->plot2d($dataSet);
 

