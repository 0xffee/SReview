package SReview::Web::Controller::Config;

use Mojo::Base 'Mojolicious::Controller';

sub get_config {
	my $c = shift->openapi->valid_input;

	my $eventid = $c->eventid;
	my $config;
	if(defined($eventid)) {
		$config = { event => $c->eventid };
	} else {
		$config = {};
	}

	return $c->render(openapi => $config);
}

1;
