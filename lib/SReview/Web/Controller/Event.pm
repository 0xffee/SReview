package SReview::Web::Controller::Event;

use Mojo::Base 'Mojolicious::Controller';
use SReview::API::Helpers;
use Data::Dumper;

sub add {
	my $c = shift->openapi->valid_input or return;

	return add_with_json($c, $c->req->json, "events", $c->openapi->spec('/components/schemas/Event/properties'));
}

sub update {
	my $c = shift->openapi->valid_input or return;

	return update_with_json($c, $c->req->json, "events",  $c->openapi->spec('/components/schemas/Event/properties'));
}

sub delete {
	my $c = shift->openapi->valid_input or return;

	my $eventId = $c->param('eventId');
	my $query = "DELETE FROM events WHERE id = ?";

	return delete_with_query($c, $query, $eventId);
}

sub getById {
	my $c = shift->openapi->valid_input or return;

	my $eventId = $c->param("eventId");
	my $event = db_query($c->dbh, "SELECT row_to_json(events.*) FROM events WHERE id = ?", $eventId);

	if(scalar(@$event) < 1) {
		$c->res->code(404);
		$c->render(text => "not found");
		return;
	}

	$c->render(openapi => $event->[0]);
}

sub list {
	my $c = shift->openapi->valid_input or return;

	my $events = db_query($c->dbh, "SELECT row_to_json(events.*) FROM events");

	$c->render(openapi => $events);
}

1;
