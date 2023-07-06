import 'package:flutter/material.dart';
import 'package:talentrackats/services/network_helper.dart';

class SendEmailPage extends StatefulWidget {
  const SendEmailPage({Key? key}) : super(key: key);

  @override
  State<SendEmailPage> createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _handleReset(BuildContext context) async {
    try {
      NetworkHelper networkHelper = NetworkHelper();

      String url = '/auth/forgot-password';
      String email = _emailController.text;

      var data = {'email': email};

      var response = await networkHelper.postData(url, data);

      if (response['statusCode'] == 200) {
        _showPopupDialog(context, 'Success', 'Reset Code Sent To Email', true);
      } else {
        _showPopupDialog(context, 'Failed', response['data']['message'], false);
      }
    } catch (err) {
      print(err);
    }
  }

  void _showPopupDialog(
      BuildContext context, String title, String message, bool redirect) {
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
                if (redirect) {
                  Navigator.pushReplacementNamed(context, '/reset-password');
                }
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
        title: Text('Forgot Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Reset Password'),
              onPressed: () => _handleReset(context),
            ),
          ],
        ),
      ),
    );
  }
}
