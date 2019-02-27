import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assign1/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';
import 'package:platform/platform.dart' as PlatformManager;
import 'package:geolocation/geolocation.dart' as Geolocation;

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

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Constants.GOOGLE_API_KEY);
  String email = "";
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];

  var displayName = '';

  void _onMapCreated(GoogleMapController controller, context) {
    setState(() {
      mapController = controller;
      _checkLocationService();
    });
  }

  _checkLocationService() {
    var platform = PlatformManager.LocalPlatform();
    if (platform.isAndroid) {
      _getLocation(context);
    }
  }

  _openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  _getLocation(context) async {
    Geolocation.Geolocation.currentLocation(accuracy: Geolocation.LocationAccuracy.block)
      .listen((res) {
        if (res.isSuccessful) {
          print(res.location.toString());
          var center = LatLng(res.location.latitude, res.location.longitude);
          mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 270.0,
              target: center,
              tilt: 30.0,
              zoom: 16.0,
            ),
          )).then((animated) {
            _getNearbyPlaces(center, context);
          }).catchError((err) => print(err));
        } else {
          print(res.error.toString());
        }
      });
  }


  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser()
      .then((user) {
        setState(() {
          this.displayName = user.displayName;
          this.email = user.email;
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

  void _getNearbyPlaces(LatLng center, context) async {

    final location = Location(center.latitude, center.longitude);
    _places.searchNearbyWithRadius(
      location, 1500, keyword: "axis bank"
    ).then((result) {
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
      } else {
        print(result.errorMessage);
      }
    }).catchError((err) =>print(err));

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