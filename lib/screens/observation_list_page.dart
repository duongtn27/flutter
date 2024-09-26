// lib/screens/observation_list_page.dart

import 'package:flutter/material.dart';
import '../databases/database_helper.dart';
import 'observation_form.dart';
import '../models/observation.dart';

class ObservationListPage extends StatefulWidget {
  final int hikeId;

  ObservationListPage({required this.hikeId});

  @override
  _ObservationListPageState createState() => _ObservationListPageState();
}

class _ObservationListPageState extends State<ObservationListPage> {
  late DatabaseHelper _dbHelper;
  List<Observation> _observations = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _refreshObservationList();
  }

  void _refreshObservationList() async {
    List<Observation> observations = await _dbHelper.getObservations(widget.hikeId);
    setState(() {
      _observations = observations;
    });
  }

  void _deleteObservation(int id) async {
    await _dbHelper.deleteObservation(id);
    _refreshObservationList();
  }

  void _navigateToObservationForm({Observation? observation}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ObservationForm(hikeId: widget.hikeId, observation: observation)),
    );
    if (result == true) {
      _refreshObservationList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Observations for Hike'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToObservationForm(),
          ),
        ],
      ),
      body: _observations.isEmpty
          ? Center(child: Text('No observations for this hike. Add an observation!'))
          : ListView.builder(
        itemCount: _observations.length,
        itemBuilder: (context, index) {
          Observation observation = _observations[index];
          return ListTile(
            title: Text(observation.observation),
            subtitle: Text('Time: ${observation.timeOfObservation.toLocal()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _navigateToObservationForm(observation: observation),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteObservation(observation.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
