#!/usr/bin/perl
use strict;
use warnings;
use Test::Mock::LWP::Dispatch;
use JSON;
use Test::More;

my $api_key		= 'fake_api_key';
my $client_id	= 'fake_client_id';
my $droplet_id	= 100823;
my $droplet_name = 'test';
my $size_id		= 32;
my $image_id	= 419;
my $region_id	= 2;
my $snapshot_name = 'fake_snapshot_name';

my $ua = LWP::UserAgent->new;
my $responses = {
	droplets => {
		api_action 	=> "droplets?",
		json		=> qq/{"status":"OK","droplets":[{"backups_active":null,"id":100823,"image_id":420,"name":"test222","region_id":1,"size_id":33,"status":"active"}]}/
	},
	show_droplet	=> {
		api_action	=>	"droplets/$droplet_id/?", 
		json		=>	qq/{"status":"OK","droplet":{"backups_active":null,"id":100823,"image_id":420,"name":"test222","region_id":1,"size_id":33,"status":"active"}}/,
	},
};

my $todo = {
	new_droplet	=> {
		api_action	=>	"droplets/new?name=$droplet_name&size_id=$size_id&image_id=$image_id&region_id=$region_id&",
		json		=>	qq/{"status":"OK","droplet":{"id":100824,"name":"test","image_id":419,"size_id":32,"event_id":7499}}/,
	},
	reboot	=> {
		api_action	=>	"droplets/$droplet_id/reboot/?",
		json	=>	qq/{"status":"OK","event_id":7501}/,
	},
	power_cycle	=> {
		api_action	=>	"droplets/$droplet_id/power_cycle/?",
		json		=>	qq/{"status":"OK","event_id":7501}/,
	},
	shut_down	=> {
		api_action	=>	"droplets/$droplet_id/shut_down/?",
		json		=>	qq/{"status":"OK","event_id":7501}/,
	},
	power_off	=> {
		api_action	=>	"droplets/$droplet_id/power_off/?",
		json		=>	qq/{"status":"OK","event_id":7501}/,
	},
	power_on	=> {
		url			=>	"droplets/$droplet_id/power_on/?",
		json		=>	qq/{"status":"OK","event_id":7501}/,
	},
	reset_root_password	=> {
		api_action	=>	"droplets/$droplet_id/reset_root_password/?",
		json		=>	qq/{"status":"OK","event_id":7501}/,
	},
	resize	=> {
		api_action	=>	"droplets/$droplet_id/resize/?size_id=$size_id&",
		json		=>	qq/{"status":"OK","event_id":7501}/,
	},
	snapshot	=> {
		api_action	=>	"droplets/$droplet_id/snapshot/?name=$snapshot_name&",
		json		=>	qq/{"status":"OK","event_id":7504}/,
	},
	restore	=> {
		api_action	=>	"droplets/$droplet_id/restore/?image_id=$image_id&",
		json		=>	qq/{"status":"OK","event_id":7504}/,
	},
	rebuild	=> {
		api_action	=>	"droplets/$droplet_id/rebuild/?image_id=$image_id&",
		json		=>	qq/{"status":"OK","event_id":7504}/,
	},
	enable_backups	=> {
		api_action	=>	"droplets/$droplet_id/enable_backups/?",
		json		=>	qq/{"status":"OK","event_id":7504}/,
	},
	disable_backups	=> {
		api_action	=>	"droplets/$droplet_id/disable_backups/?",
		json		=>	qq/{"status":"OK","event_id":7504}/,
	},
	destroy	=> {
		api_action	=>	"droplets/$droplet_id/destroy/?",
		json		=>	qq/{"status":"OK","event_id":7504}/,
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

TODO: {
	todo_skip "Not yet implemented.", 0+(keys %$todo);
	foreach my $action (keys %$todo){
	 	is_deeply($do->do_request(api_action => $todo->{$action}{api_action}),from_json($todo->{$action}{json}),$action);
	}
}

done_testing;
