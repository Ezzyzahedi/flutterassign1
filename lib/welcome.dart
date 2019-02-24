import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assign1/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:url_launcher/url_launcher.dart';


GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Constants.GOOGLE_API_KEY);

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _WelcomePage();
  }
}

class _WelcomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<_WelcomePage> {

  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];

  var displayName = '';

  void _onMapCreated(GoogleMapController controller, context) {
    setState(() {
      mapController = controller;
      _getLocation(context);
    });
  }

  _getLocation(context) async {

    new LocationManager.Location().getLocation().then((loc) {
      double lat, lng;
      LatLng myLocation;
      loc.forEach((k, v) {
        if (k.startsWith("latitude")) lat = v;
        if (k.startsWith("longitude")) lng = v;
      });

      print('lat: ' + lat.toString() + '; lng: ' + lng.toString());
      myLocation = LatLng(lat, lng);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: myLocation,
          tilt: 30.0,
          zoom: 16.0,
        ),
      ));

      getNearbyPlaces(myLocation, context);
    }).catchError((err) => print('err: ' + err));
  }


  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser()
      .then((user) {
        setState(() {
          this.displayName = user.displayName;
        });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome ${this.displayName}"
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _onMapCreated(controller, context);
              },
              options: GoogleMapOptions(
                myLocationEnabled: true,
                compassEnabled: true,
                zoomGesturesEnabled: true,
              ),
            ),
          )
        ],
      )
    );
  }

  void getNearbyPlaces(LatLng center, context) async {

    final location = Location(center.latitude, center.longitude);
    final result = await _places.searchNearbyWithRadius(
      location, 1500, keyword: "axis bank"
    );
    setState(() {
      if (result.status == "OK") {
        this.places = result.results;
        LatLng place;
        result.results.getRange(0, 1).forEach((f) {
          place = LatLng(f.geometry.location.lat, f.geometry.location.lng);
          final markerOptions = MarkerOptions(
            position: place,
            infoWindowText: InfoWindowText(
              "${f.name}", "${f.types?.first}"));
          mapController.addMarker(markerOptions);
        });

        _showDialog(place, context);
      }
    });
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showDialog(place, context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Navigate?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Navigate"),
              onPressed: () {
                _launchURL("google.navigation:q=${place.latitude},${place.longitude}");
              },
            ),
          ],
        );
      }
    );
  }

}