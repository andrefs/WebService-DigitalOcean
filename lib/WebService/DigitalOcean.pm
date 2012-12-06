package WebService::DigitalOcean 0.001;
use Moo;
extends 'WebService::DigitalOcean::Base';
use Data::Dump qw/dump/;

# ABSTRACT: Doesn't matter what it does, it is awesome anyway! (TODO: change this -- ups!)

sub droplets {
	my ($self) = @_;
	my $json = $self->do_request(api_action => 'droplets');
	[ map { WebService::DigitalOcean::Region->new(%$_) } @{$json->{droplets}} ];
}

sub show_droplet {
	my ($self,$droplet_id) = @_;
	my $json = $self->do_request(api_action => "droplets/$droplet_id");
	return WebService::DigitalOcean::Droplet->new($json->{droplet});
}

sub new_droplet {
	...
}

sub reboot_droplet {
	...
}

sub power_cycle_droplet {
	...
}

sub shut_down_droplet {
	...
}

sub power_off_droplet {
	...
}

sub power_on_droplet {
	...
}

sub reset_root_password {
	...
}

sub resize_droplet {
	...
}

sub snapshot_droplet {
	...
}

sub restore_droplet {
	...
}

sub rebuild_droplet {
	...
}

sub enable_automatic_backups {
	...
}

sub disable_automatic_backups {
	...
}

sub destroy_droplet {
	...
}

sub regions {
	my ($self) = @_;
	my $json = $self->do_request(api_action => 'regions');
	[ map { WebService::DigitalOcean::Region->new(%$_) } @{$json->{regions}} ];
}

sub images {
	my ($self,%args) = @_;
	my $json = $self->do_request(api_action => 'images',%args);
	[ map { WebService::DigitalOcean::Image->new(%$_) } @{$json->{images}} ];
}

sub show_image {
	my ($self,$image_id) = @_;
	my $json = $self->do_request(api_action => "images/$image_id");
	return WebService::DigitalOcean::Image->new($json->{image});
}

sub destroy_image {
	my ($self,$image_id) = @_;
	my $json = $self->do_request(api_action => "images/$image_id/destroy");
	#return WebService::DigitalOcean::Image->new($json->{image});
}

sub ssh_keys {
	my ($self) = @_;
	my $json = $self->do_request(api_action => 'ssh_keys');
	[ map { WebService::DigitalOcean::SSHKey->new(%$_) } @{$json->{ssh_keys}} ];
}
	
sub show_ssh_key {
	my ($self,$ssh_key_id) = @_;
	my $json = $self->do_request(api_action => "ssh_keys/$ssh_key_id");
	return WebService::DigitalOcean::SSHKey->new($json->{ssh_key});
}


sub add_ssh_key {
	...
}

sub edit_ssh_key {
	...
}

sub destroy_ssh_key {
	my ($self,$ssh_key_id) = @_;
	my $json = $self->do_request(api_action => "ssh_keys/$ssh_key_id/destroy");
	#return WebService::DigitalOcean::Image->new($json->{image});
}

sub sizes {
	my ($self,%args) = @_;
	my $json = $self->do_request(api_action => 'sizes',%args);
	[ map { WebService::DigitalOcean::Size->new(%$_) } @{$json->{sizes}} ];
}
	
package WebService::DigitalOcean::Droplet;
use Moo;

has backups_active	=> ( is => 'rw', required => 1 );
has id				=> ( is => 'rw', required => 1 );
has image_id		=> ( is => 'rw', required => 1 );
has name			=> ( is => 'rw', required => 1 );
has region_id		=> ( is => 'rw', required => 1 );
has size_id			=> ( is => 'rw', required => 1 );
has status			=> ( is => 'rw', required => 1 );

package WebService::DigitalOcean::Region;
use Moo;

has name			=> ( is => 'rw', required => 1 );
has id				=> ( is => 'rw', required => 1 );


package WebService::DigitalOcean::Image;
use Moo;

has distribution	=> ( is => 'rw', required => 1 );
has name			=> ( is => 'rw', required => 1 );
has id				=> ( is => 'rw', required => 1 );

package WebService::DigitalOcean::SSHKey;
use Moo;

has name			=> ( is => 'rw', required => 1 );
has id				=> ( is => 'rw', required => 1 );
has ssh_pub_key		=> ( is	=> 'rw', required => 0 );

package WebService::DigitalOcean::Size;
use Moo;

has name			=> ( is => 'rw', required => 1 );
has id				=> ( is => 'rw', required => 1 );

1;
