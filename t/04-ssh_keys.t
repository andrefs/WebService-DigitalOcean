#!/usr/bin/perl
use strict;
use warnings;
use Test::Mock::LWP::Dispatch;
use JSON;
use Test::More tests => 1;

my $api_key		= 'fake_api_key';
my $client_id	= 'fake_client_id';

my $ua = LWP::UserAgent->new;
$ua->map(
	"https://api.digitalocean.com/ssh_keys/?client_id=$client_id&api_key=$api_key",
	HTTP::Response->new(200, 'OK', HTTP::Headers->new('Content-Type' => "application/json; charset=utf-8" ),
		qq/{"status":"OK","ssh_keys":[{"id":10,"name":"office-imac"},{"id":11,"name":"macbook-air"}]}/
	)
);

use WebService::DigitalOcean;
my $do = WebService::DigitalOcean->new(client_id => $client_id, api_key => $api_key, _ua => $ua);

is_deeply($do->do_request(api_action => 'ssh_keys'),{
  ssh_keys => [
                { id => 10, name => "office-imac" },
                { id => 11, name => "macbook-air" },
              ],
  status   => "OK",
}, $do->_apiurl.'ssh_keys'); 
