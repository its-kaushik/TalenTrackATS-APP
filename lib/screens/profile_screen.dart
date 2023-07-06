import 'package:shared_preferences/shared_preferences.dart';
import 'package:talentrackats/services/network_helper.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _profile;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      NetworkHelper networkHelper = NetworkHelper();

      String url = '/auth/profile';

      var response = await networkHelper.getData(url);

      if (response['statusCode'] == 200) {
        setState(() {
          _profile = response['data']['data'];
        });
      }
    } catch (err) {
      print(err);
    }
  }

  void _showPopupDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: _profile == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_profile['name']),
                          Text(_profile['email']),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('accessToken');
                      await prefs.remove('isLogged');

                      _showPopupDialog(context, 'Success',
                          'You have been logged out successfully');
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
      ),
    );
  }
}
