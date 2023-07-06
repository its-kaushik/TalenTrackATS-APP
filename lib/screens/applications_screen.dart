import 'package:flutter/material.dart';
import 'package:talentrackats/services/network_helper.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({Key? key}) : super(key: key);

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  List<dynamic> applications = [];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    try {
      NetworkHelper networkHelper = NetworkHelper();

      String url = '/applications/self';
      var response = await networkHelper.getData(url);

      if (response['statusCode'] == 200) {
        setState(() {
          applications = response['data']['data'];
        });
      } else {
        print('F');
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> _withdrawApplication(String applicationID) async {
    NetworkHelper networkHelper = NetworkHelper();

    String url = '/applications/$applicationID';

    var response = await networkHelper.deleteRequest(url);

    if (response['statusCode'] == 200) {
      _loadApplications();
    } else {
      print('F');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applications'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {
              // Perform action when the button is pressed
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: applications.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final application = applications[index];
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application['job']['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          application['job']['hr']['company'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('description : ' +
                            application['job']['description']),
                        SizedBox(height: 8),
                        Text('Salary Range : ' +
                            application['job']['salaryRange']),
                        SizedBox(height: 5),
                        Text(
                          'Status : ' + application['status'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Round : ' + application['round'].toString()),
                        Text('Applied on: ' +
                            application['createdAt'].substring(0, 10)),
                        Text('Last update: ' +
                            application['updatedAt'].substring(0, 10)),
                        SizedBox(height: 8),
                        ElevatedButton(
                            onPressed: () =>
                                _withdrawApplication(application['_id']),
                            child: Text('Withdraw'))
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
