import 'package:flutter/material.dart';
import 'package:talentrackats/services/network_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> jobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      NetworkHelper networkHelper = NetworkHelper();

      String url = '/jobs?isActive=true';
      var response = await networkHelper.getData(url);

      if (response['statusCode'] == 200) {
        setState(() {
          jobs = response['data']['data'];
        });
      } else {
        print(response['data']['message']);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> _applyJob(BuildContext context, String jobID) async {
    try {
      String url = '/applications';
      var data = {'job': jobID};

      NetworkHelper networkHelper = NetworkHelper();
      var response = await networkHelper.postData(url, data);

      if (response['statusCode'] == 201) {
        _showPopupDialog(context, 'Success', 'Applied Successfully!');
      } else {
        _showPopupDialog(context, 'Failure', response['data']['message']);
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
          title: Text('Home'),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/applications');
                },
                child: Text('View Applications'),
              ),
            ),
            Expanded(
              child: jobs.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  job['hr']['company'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('description : ' + job['description']),
                                SizedBox(height: 8),
                                Text('Salary Range : ' + job['salaryRange']),
                                SizedBox(height: 8),
                                Text('Total Positions : ' +
                                    job['positions'].toString()),
                                SizedBox(height: 8),
                                Text('Total Rounds :' +
                                    job['totalRounds'].toString()),
                                SizedBox(height: 8),
                                Text('Posted by : ' + job['hr']['name']),
                                Text('Posted on: ' +
                                    job['createdAt'].substring(0, 10)),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      _applyJob(context, job['_id']),
                                  child: Text('Apply'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ));
  }
}
