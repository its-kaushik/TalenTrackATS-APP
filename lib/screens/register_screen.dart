import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String filePath = '';

  Future<void> _Register(BuildContext context) async {
    try {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      String url = 'http://192.168.0.175:4000/v1/auth/register';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;

      if (filePath != '') {
        String? mimeType = mime(filePath);
        print(mimeType);

        var file = await http.MultipartFile.fromPath('resume', filePath,
            contentType: MediaType.parse(mimeType!));
        request.files.add(file);
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        _showPopupDialog(context, 'Registered Successfully',
            'You have been registered successfully', true);
      } else {
        _showPopupDialog(context, 'Failure', 'Not Registered', false);
      }
    } catch (err) {
      _showPopupDialog(context, 'Failure', 'User not registered', false);
      print(err);
    }
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;

        //_file = File(path!);

        filePath = file.path!;
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
                  Navigator.pushReplacementNamed(context, '/login');
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
        title: Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              ElevatedButton(
                onPressed: _selectFile,
                child: Text('Select Resume'),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () => _Register(context), child: Text('Register'))
            ],
          ),
        ),
      ),
    );
  }
}
