import 'package:flutter/material.dart';
import '../databases/database_helper.dart';
import '../models/observation.dart';

class ObservationForm extends StatefulWidget {
  final int hikeId; // ID of the hike
  final Observation? observation;

  ObservationForm({required this.hikeId, this.observation});

  @override
  _ObservationFormState createState() => _ObservationFormState();
}

class _ObservationFormState extends State<ObservationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _observationController;
  late TextEditingController _additionalCommentsController;
  late DateTime _timeOfObservation;

  @override
  void initState() {
    super.initState();
    _observationController = TextEditingController(text: widget.observation?.observation ?? '');
    _additionalCommentsController = TextEditingController(text: widget.observation?.additionalComments ?? '');

    // Set the time of observation to now if it's a new observation
    _timeOfObservation = widget.observation?.timeOfObservation ?? DateTime.now();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Observation observation = Observation(
        id: widget.observation?.id,
        hikeId: widget.hikeId,
        observation: _observationController.text,
        timeOfObservation: _timeOfObservation,
        additionalComments: _additionalCommentsController.text,
      );
      if (widget.observation == null) {
        await DatabaseHelper().insertObservation(observation);
      } else {
        await DatabaseHelper().updateObservation(observation);
      }
      Navigator.pop(context, true);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_timeOfObservation),
    );
    if (picked != null) {
      // Update the time of observation based on the picked time
      setState(() {
        _timeOfObservation = DateTime(
          _timeOfObservation.year,
          _timeOfObservation.month,
          _timeOfObservation.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _timeOfObservation,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _timeOfObservation = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _timeOfObservation.hour,
          _timeOfObservation.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.observation == null ? 'Add Observation' : 'Edit Observation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _observationController,
                decoration: InputDecoration(labelText: 'Observation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an observation';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Display the formatted date
                    Expanded(
                      child: Text(
                        'Date: ${_timeOfObservation.toLocal().toIso8601String().split('T')[0]}', // Display date in YYYY-MM-DD format
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Button to select the date
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date'),
                    ),
                  ],
                ),
              ),
              // Display the formatted time
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Time: ${_timeOfObservation.hour.toString().padLeft(2, '0')}:${_timeOfObservation.minute.toString().padLeft(2, '0')}', // Display time in HH:MM format
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Button to select the time
                    TextButton(
                      onPressed: () => _selectTime(context),
                      child: Text('Select Time'),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _additionalCommentsController,
                decoration: InputDecoration(labelText: 'Additional Comments'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.observation == null ? 'Add Observation' : 'Update Observation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
