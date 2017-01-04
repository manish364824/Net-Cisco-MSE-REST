package Net::Cisco::MSE::REST;

use warnings;
use strict;

use Carp;
use LWP::UserAgent;
use JSON;
use HTTP::Request;

our $VERSION = 0.2;

sub new {
    my ($class, %params) = @_;

    my $url   = $params{url} || 'http://localhost:8083/';

    my $user = $params{user} || 'cisco';
    my $pass = $params{pass} || 'cisco';

    my $agent = LWP::UserAgent->new();

    $agent->timeout($params{timeout})
        if $params{timeout};
    $agent->ssl_opts(%{$params{ssl_opts}})
        if $params{ssl_opts} && ref $params{ssl_opts} eq 'HASH';

    my $req = new HTTP::Request;
    $req->authorization_basic($user,$pass);
    $req->header(Accept => " application/json");
    my $self = {
        url   => $url,
        agent => $agent,
        req => $req,
    };
    bless $self, $class;

    return $self;
}

sub maps {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/maps");
}

sub maps_count {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/maps/count");
}


sub maps_info {
    my ($self, $args) = @_;

    croak "missing campusName parameter" unless $args->{campusName};
    croak "missing buildingName parameter" unless $args->{buildingName};
    croak "missing floorName parameter" unless $args->{floorName};

    return $self->_get("/api/contextaware/v1/maps/info/$args->{campusName}/$args->{buildingName}/$args->{floorName}");
}

sub maps_image {
    my ($self, $args) = @_;

    croak "missing campusName parameter" unless $args->{campusName};
    croak "missing buildingName parameter" unless $args->{buildingName};
    croak "missing floorName parameter" unless $args->{floorName};

    return $self->_get("/api/contextaware/v1/maps/image/$args->{campusName}/$args->{buildingName}/$args->{floorName}");
}

sub maps_image_source {
    my ($self, $args) = @_;

    croak "missing imageName parameter" unless $args->{imageName};

    return $self->_get_bin("/api/contextaware/v1/maps/imagesource/$args->{imageName}");
}

sub real_time_localisation_for_client {
    my ($self, $args) = @_;

    croak "missing id parameter" unless $args->{id};

    return $self->_get("/api/contextaware/v1/location/clients/$args->{id}");
}

sub real_time_localisation_for_client_count {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/clients/count");
}

sub real_time_localisation_for_tags {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/tags");
}

sub real_time_localisation_for_tags_count {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/tags/count");
}

sub real_time_localisation_for_rogueaps {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/rogueaps");
}

sub real_time_localisation_for_rogueaps_count {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/rogueaps/count");
}

sub real_time_localisation_for_rogueclients {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/rogueclients");
}

sub real_time_localisation_for_rogueclients_count {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/rogueclients/count");
}

sub real_time_localisation_for_interferers {
    my ($self, $args) = @_;

    croak "missing id parameter" unless $args->{id};

    return $self->_get("/api/contextaware/v1/location/interferers/$args->{id}");
}

sub real_time_localisation_for_interferers_count {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/interferers/count");
}

sub localisation_history_for_client {
    my ($self, $args) = @_;

    croak "missing id parameter" unless $args->{id};

    return $self->_get("/api/contextaware/v1/location/history/clients/$args->{id}");
}

sub localisation_history_for_client_count {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/history/clients/count");
}

sub localisation_history_for_tags {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/history/tags/");
}

sub localisation_history_for_tags_count {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/history/tags/count");
}

sub localisation_history_for_rogueaps {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/history/rogueaps");
}

sub localisation_history_for_rogueaps_count {
    my ($self, $args) = @_;

    croak "missing id parameter" unless $args->{id};

    return $self->_get("/api/contextaware/v1/location/history/rogueaps/$args->{id}/count");
}

sub localisation_history_for_rogueclients {
    my ($self) = @_;

    return $self->_get("/api/contextaware/v1/location/history/rogueclients");
}

sub localisation_history_for_rogueclients_count {
    my ($self, $args) = @_;

    croak "missing id parameter" unless $args->{id};

    return $self->_get("/api/contextaware/v1/location/history/rogueclients/count");
}

sub localisation_history_for_interferers {
    my ($self) = @_;


    return $self->_get("/api/contextaware/v1/location/history/interferers");
}

sub localisation_history_for_interferers_count {
    my ($self, $args) = @_;

    croak "missing id parameter" unless $args->{id};

    return $self->_get("/api/contextaware/v1/location/history/interferers/$args->{id}/count");
}

sub notification_create {
    my ($self, $args) = @_;

    return $self->_put("/api/contextaware/v1/notifications",$args);
}

sub notification_view {
    my ($self, $args) = @_;

    return $self->_get("/api/contextaware/v1/notifications/",$args);
}

sub notification_delete {
    my ($self, $args) = @_;

    return $self->_delete("/api/contextaware/v1/notifications/$args->{name}");
}

sub _get_bin {
    my ($self, $path, %params) = @_;

    $self->{req}->method("GET");
    $self->{req}->uri($self->{url} . $path);
    $self->{req}->header(Accept => "image/jpeg");

    my $response = $self->{agent}->request($self->{req});

    if ($response->is_success()) {
        return $response->content;
    } else {
        croak "communication error: " . $response->message()
    }
}

sub _get {
    my ($self, $path, %params) = @_;

    $self->{req}->method("GET");
    $self->{req}->uri($self->{url} . $path);

    my $response = $self->{agent}->request($self->{req});

    my $result = eval { from_json($response->content()) };

    if ($response->is_success()) {
        return $result;
    } else {
        if ($result) {
            croak "server error: " . $result->{error};
        } else {
            croak "communication error: " . $response->message()
        }
    }
}

sub _put {
    my ($self, $path, $params) = @_;

    $self->{req}->method("PUT");
    $self->{req}->uri($self->{url} . $path);

    my $json = to_json($params);

    $self->{req}->header( 'Content-Type' => 'application/json' );
    $self->{req}->content( $json );

    my $response = $self->{agent}->request($self->{req});

    my $result = eval { from_json($response->content()) };

    if ($response->is_success()) {
        return $result;
    } else {
        if ($result) {
            croak "server error: " . $result->{error};
        } else {
            croak "communication error: " . $response->message()
        }
    }
}

sub _delete {
    my ($self, $path, $params) = @_;

    $self->{req}->method("DELETE");
    $self->{req}->uri($self->{url} . $path);

    my $response = $self->{agent}->request($self->{req});

    my $result = eval { from_json($response->content()) };

    if ($response->is_success()) {
        return $result;
    } else {
        if ($result) {
            croak "server error: " . $result->{error};
        } else {
            croak "communication error: " . $response->message()
        }
    }
}


1;
__END__

=encoding utf8

=head1 NAME

Net::Cisco::MSE::REST - REST interface for Cisco MSE

=head1 DESCRIPTION

This module provides a Perl interface for communication with Cisco MSE
using REST interface.

=head1 SYNOPSIS

    use Net::Cisco::MSE::REST;

    my $rest = Net::Cisco::MSE::REST->new(
        url => 'https://my.mse:8034',
        user => 'cisco',
        pass => 'cisco'
    ):
    my $location = $rest->real_time_localisation_for_client({id => '2c:1f:23:ca:1a:cf'});


=head1 CLASS METHODS

=head2 Net::Cisco::MSE::REST->new(url => $url, [ssl_opts => $opts, timeout => $timeout], user => 'cisco', pass => 'cisco')

Creates a new L<Net::Cisco::MSE::Rest> instance.

=head1 INSTANCE METHODS

=head2 $rest->create_session(username => $username, password => $password)

Creates a new session token for the given user.


=head2 $rest->maps

The maps object returns detailed map information about campuses, buildings, floors, access points, map dimensions, regions, zones, GPS marker, image information, etc.

=head2 $rest->maps_count

The mapscount returns maps count specifying the number of Campuses, Buildings, and Floors known to MSE.

=head2 $rest->maps_info

The mapsinfo object returns all the floor information associated with the campusName -> buildingName -> floorName. This includes floor dimension, Access Points and their information, GPS Markers etc.

Parameters:
* floorname—Name of the required floor
* buildingname—Name of the required building
* campusname—Name of the required campus

=head2 $rest->maps_image

The mapsimage object returns the floor image data associated with the particular campusName -> buildingName -> floorName.

Parameters:

* floorname—Name of the required floor
* buildingname—Name of the required building
* campusname—Name of the required campus

=head2 $rest->maps_image_source

The mapsimagesource object returns the image associated with the specified image name.

Parameters:

* imageName—Name of the required image.

=head2 $rest->real_time_localisation_for_client

The location clients object returns the current location of the wireless client for the specified device ID. The ID can be MAC address, IP address, or Username.

Parameters:

* id: Mac address, IP Address, or Username of the wireless client.

=head2 $rest->real_time_localisation_for_client_count

The locationclientscount object returns count or location of wireless clients on the MSE. Results are filtered based on the specified query param conditions.

=head2 $rest->real_time_localisation_for_tags

Returns a list of Location of Tags for the specified query conditions.

=head2 $rest->real_time_localisation_for_tags_count

The location tags count object returns a count of Tags on MSE based on the specified Query Param conditions.

Parameters:

* []: Defines query conditions for the tag.

=head2 $rest->real_time_localisation_for_rogueaps

Returns a list of Location of Rogue APs for the specified query conditions.

Parameters:

* []: Defines query conditions for the rogue AP.

=head2 $rest->real_time_localisation_for_rogueaps_count

Returns a count of Rogue APs on MSE based on the specified Query Param conditions.
Returns a list of Location of Rogue APs for the specified query conditions.

Parameters:

* []: Defines query conditions for the rogue AP.

=head2 $rest->real_time_localisation_for_rogueclients

Returns the Location of Rogue Client for the specified id.

Parameters:

* id: MAC address of the rogue client.

=head2 $rest->real_time_localisation_for_rogueclients_count

Returns a count of Rogue Clients on MSE based on the specified Query Param conditions.

Parameters:

* []: Defines query conditions for the rogue client.

=head2 $rest->real_time_localisation_for_interferers

Returns the Location of Interferer for the specified id.
Returns a count of Rogue Clients on MSE based on the specified Query Param conditions.

Parameters:

* id: MAC address of the interferer.

=head2 $rest->real_time_localisation_for_interferers_count

Returns a count of Interferers on MSE based on the specified Query Param conditions.

Parameters:

* []: Defines query conditions for the interferers.

=head2 $rest->localisation_history_for_client

Returns a list of historical Location records of Wireless Client for the specified id and query conditions

Parameters:

* id: MAC address, IP address, or username of the wireless client.
* []: Defines query conditions for the wireless client

=head2 $rest->localisation_history_for_client_count

Returns a count of historical Location records of Wireless Clients on MSE based on the specified Query Param conditions.

Parameters:

* []: Defines query conditions for the wireless client.

=head2 $rest->localisation_history_for_tags

Returns a list of the historical Location records of Tag for the specified id and query conditions

Parameters:

* id: MAC address of the tag
* []: Defines query conditions for the tag.


=head2 $rest->localisation_history_for_tags_count

Returns a count of historical location records of Tags on MSE based on the specified Query Param conditions.

Parameters:

* []: Defines query conditions for the interferers.

=head2 $rest->localisation_history_for_rogueaps

Returns a list of historical records of Location of Rogue APs for the specified query conditions.

Parameters:

* []: Defines query conditions for the rogue AP.

=head2 $rest->localisation_history_for_rogueaps_count

Returns a count of historical Location records of Rogue APs based on the specified Query Param conditions.

Parameters:

* []: Defines query conditions for the rogue AP.

=head2 $rest->localisation_history_for_rogueclients

Returns a list of historical Location records of Rogue Clients for the specified query conditions.

Parameters:

* []: Defines query conditions for the rogue client.

=head2 $rest->localisation_history_for_rogueclients_count

Returns a count of Historical Location records of Rogue Clients on MSE based on the specified Query Param conditions.

Parameters:

* []: Defines query conditions for the rogue client.

=head2 $rest->localisation_history_for_interferers

Returns a list of historical Location records of Interferers for the specified query conditions.

Parameters:

* []: Defines query conditions for the interferers.

=head2 $rest->localisation_history_for_interferers_count

Returns a count of historical Location records of Interferers for the specified id and query conditions.

Parameters:

* []: Defines query conditions for the interferers.

=head2 $rest->notification_create

Create and subscribe to a notification

Parameters:

* {"NotificationSubscription"=> {
     "name"=> "OutIn",
     "notificationType"=> "EVENT_DRIVEN",
     "dataFormat"=> "JSON",
     "subscribedEvents"=>    [
              {
           "type"=> "ContainmentEventTrigger",
           "eventEntity"=> "WIRELESS_CLIENTS",
           "boundary"=> "INSIDE",
           "zoneHierarchy" => "Buiding>8th level>Network-Zone",
           "zoneTimeout" => 10,
        },
        {
           "type"=> "ContainmentEventTrigger",
           "eventEntity"=> "WIRELESS_CLIENTS",
           "boundary"=> "OUTSIDE",
           "zoneHierarchy" => "Building>8th level>Network-Zone",
           "zoneTimeout" => 10,
        }
     ],
     "NotificationReceiverInfo"=> {"transport"=>    {
        "type"=> "TransportHttp",
        "hostAddress"=> "192.168.0.1",
        "port"=> 9292,
        "macScramblingEnabled"=> false,
        "urlPath"=> "/mse/",
        "https"=> false
     }}
  }};

=head2 $rest->notification_view

View all notification created by the current logged user

Parameters:

* []: Defines query conditions for the interferers.

=head2 $rest->notification_delete

Delete specific notification

Parameters:

* name: name of the notification


=head1 LICENSE

Copyright (c) 2016 Inverse.inc.
This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

