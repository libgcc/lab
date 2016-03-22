#!/usr/bin/perl
use strict;
use warnings;
use Storable;
use LWP::UserAgent;
use List::Util qw/sum/;
use HTML::TreeBuilder;
use Data::Dumper;
 
use 5.010;
my @citys = qw/wuhan shanghai nanjing hangzhou chongqing chengdu changsha nanchang hefei guangzhou shenzheng/;
my @years = (2011..2015);
 
my @dates=();
foreach my $y (@years)
{
    my @d = map {$y.'0'.$_} (6..9);
    push(@dates , @d);
}
 
# Create a user agent object
my $ua = LWP::UserAgent->new();
 
my @h=();
foreach my $city (@citys)
{
    my @highs=();
    my @lows=();
    foreach my $date (@dates)
    {
        my $resp = $ua->get("http://lishi.tianqi.com/$city/$date.html");
        die $resp->status_line() unless $resp->is_success();

        my $html = HTML::TreeBuilder->new();
        $html->parse($resp->decoded_content());
        $html->eof();
 
        my $div = $html->look_down(_tag=>'div', class=>'tqtongji2');
        die "no data response " unless $div;
 
        my @content = $div->content_list();
        shift(@content);
        foreach(@content)
        {
            my @item = ($_->content_list())[1,2];
            push(@highs, $item[0]->as_text);
            push(@lows, $item[1]->as_text);
            #say "high: ", $item[0]->as_text, " low: ", $item[1]->as_text;
        }

        $html->delete();
    }
    push(@h, {name=>$city, high=>\@highs, low=>\@lows}); 
}   #foreach

store(\@h, 'weather.dat');
