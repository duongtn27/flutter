import 'package:flutter/material.dart';
import '../databases/database_helper.dart';
import 'hike_form.dart';  // Import HikeForm for navigating to the form
import '../models/hike.dart';
import 'observation_list_page.dart';

class HikeListPage extends StatefulWidget {
  @override
  _HikeListPageState createState() => _HikeListPageState();
}

class _HikeListPageState extends State<HikeListPage> {
  late DatabaseHelper _dbHelper;
  List<Hike> _hikes = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _refreshHikeList();  // Load the list of hikes when the page is initialized
  }

  // Fetch all hikes from the database
  void _refreshHikeList() async {
    List<Hike> hikes = await _dbHelper.getHikes();
    setState(() {
      _hikes = hikes;
    });
  }

  // Delete a specific hike by its ID
  void _deleteHike(int id) async {
    await _dbHelper.deleteHike(id);
    _refreshHikeList();  // Refresh the list after deletion
  }

  // Delete all hikes from the database
  void _deleteAllHikes() async {
    await _dbHelper.deleteAllHikes();
    _refreshHikeList();  // Refresh the list after deletion
  }

  // Navigate to the hike form to add or edit a hike
  void _navigateToHikeForm({Hike? hike}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HikeForm(hike: hike)),
    );
    if (result == true) {
      _refreshHikeList();  // Refresh the list if a hike is added/edited
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hikes List'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _deleteAllHikes,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _hikes.length,
        itemBuilder: (context, index) {
          Hike hike = _hikes[index];
          return ListTile(
            title: Text(hike.name),
            subtitle: Text(hike.location),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _navigateToHikeForm(hike: hike),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteHike(hike.id!),
                ),
                IconButton(
                  icon: Icon(Icons.visibility), // Add an icon to represent viewing observations
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ObservationListPage(hikeId: hike.id!),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToHikeForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
