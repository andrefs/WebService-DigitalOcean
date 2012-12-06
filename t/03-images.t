#!/usr/bin/perl
use strict;
use warnings;
use Test::Mock::LWP::Dispatch;
use JSON;
use Test::More tests => 1;

my $api_key		= 'fake_api_key';
my $client_id	= 'fake_client_id';

my $ua = LWP::UserAgent->new;

my $responses = {
	images => {
		api_action 	=> "droplets?",
		json		=> qq/{"status":"OK","images":[{"id":429,"name":"Real Backup 10242011","distribution":"Ubuntu"},{"id":430,"name":"test233","distribution":"Ubuntu"},{"id":431,"name":"test888","distribution":"Ubuntu"},{"id":442,"name":"tesah22","distribution":"Ubuntu"},{"id":443,"name":"testah33","distribution":"Ubuntu"},{"id":444,"name":"testah44","distribution":"Ubuntu"},{"id":447,"name":"ahtest55","distribution":"Ubuntu"},{"id":448,"name":"ahtest66","distribution":"Ubuntu"},{"id":449,"name":"ahtest77","distribution":"Ubuntu"},{"id":458,"name":"Rails3-1Ruby1-9-2","distribution":"Ubuntu"},{"id":466,"name":"NYTD Backup 1-18-2012","distribution":"Ubuntu"},{"id":478,"name":"NLP Final","distribution":"Ubuntu"},{"id":540,"name":"API - Final","distribution":"Ubuntu"},{"id":577,"name":"test1-1","distribution":"Ubuntu"},{"id":578,"name":"alec snapshot1","distribution":"Ubuntu"}]}/,
	},
};


foreach my $action (keys %$responses){
	my $url = 'https://api.digitalocean.com/'.$responses->{$action}{api_action}."client_id=$client_id&api_key=$api_key";
	$ua->map($url,HTTP::Response->new(200, 'OK', HTTP::Headers->new('Content-Type' => "application/json; charset=utf-8" ),$responses->{$action}{json}));
}

use WebService::DigitalOcean;
my $do = WebService::DigitalOcean->new(client_id => $client_id, api_key => $api_key, _ua => $ua);

 
foreach my $action (keys %$responses){
 	is_deeply($do->do_request(api_action => $responses->{$action}{api_action}),from_json($responses->{$action}{json}),$action);
}

done_testing;
