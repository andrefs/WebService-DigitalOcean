package WebService::DigitalOcean::Base 0.001;
use Moose;
use LWP::UserAgent;
use JSON;
use Try::Tiny;
use feature qw/say/;
use Moose::Util::TypeConstraints;

class_type 'Test::MockObject';
class_type 'LWP::UserAgent';

has '_ua' 	=> (
	is 			=> 'ro',
	isa 		=> 'LWP::UserAgent|Test::MockObject',
	required	=> 1,
	default		=>	sub { my $self = shift; LWP::UserAgent->new(agent => ref($self).'/'.$self->VERSION) }, 
);

has api_key => (
	is 			=> 'rw',
	isa			=> 'Str',
	required	=> 1,
);

has client_id => (
	is			=> 'rw',
	isa			=> 'Str',
	required	=> 1,
);

has _debug 	=> (
	is 			=> 'rw',
	isa			=> 'Bool',
	default		=> 0,
);

has _apiurl	=> (
	is			=> 'rw',
	isa			=> 'Str',
	default 	=> 'https://api.digitalocean.com/',
);
	

sub do_request {
	my ($self,%args) = @_;
	my $response = $self->send_request(%args);
	my $result;
	try {
		$result = $self->parse_response($response);
	}
	catch {
		my $error_msg = $_->{code}.': '.$_->{message};
		$error_msg.= "\n".$_->{content} if $_->{code} == 200;
		die $error_msg;
	}
}

sub send_request {
	my ($self, %args) = @_;
	$args{api_key} 		//= $self->api_key;
	$args{client_id}	//= $self->client_id;
	my $api_action = delete($args{api_action});	
	$api_action =~ 's/\/$//';
	my $url = URI->new($self->_apiurl.$api_action.'/');
	$url->query_form(%args);
	return $self->_ua->get($url);
}

sub parse_response {
	my ($self,$response) = @_;
	if ($response->code == 200){
		my $json = from_json($response->content);
		my $status = $json->{status};
		if ($status =~ /error/i){
			die { code => $response->code, message => $response->message, content => $response->content };
		} else {
			return $json;
		}
	}
	else {
		die { code => $response->code, message => $response->message, content => $response->content };
	}
	return;
}

1;
