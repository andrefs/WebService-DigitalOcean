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
	regions => {
		api_action 	=> "regions?",
		json		=> qq/{"status":"OK","ssh_keys":[{"id":10,"name":"office-imac"},{"id":11,"name":"macbook-air"}]}/,
	}
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
