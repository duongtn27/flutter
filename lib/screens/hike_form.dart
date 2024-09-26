import 'package:flutter/material.dart';
import '../databases/database_helper.dart';
import '../models/hike.dart';

class HikeForm extends StatefulWidget {
  final Hike? hike;

  HikeForm({this.hike});

  @override
  _HikeFormState createState() => _HikeFormState();
}

class _HikeFormState extends State<HikeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _lengthController;
  late TextEditingController _difficultyController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  String? _parkingAvailable;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.hike?.name ?? '');
    _locationController = TextEditingController(text: widget.hike?.location ?? '');
    _lengthController = TextEditingController(text: widget.hike?.length ?? '');
    _difficultyController = TextEditingController(text: widget.hike?.difficulty ?? '');
    _descriptionController = TextEditingController(text: widget.hike?.description ?? '');
    _parkingAvailable = widget.hike?.parkingAvailable ?? 'Yes';
    _selectedDate = widget.hike?.date != null ? DateTime.parse(widget.hike!.date!) : null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Hike hike = Hike(
        id: widget.hike?.id,
        name: _nameController.text,
        location: _locationController.text,
        date: _selectedDate?.toIso8601String() ?? '',
        parkingAvailable: _parkingAvailable!,
        length: _lengthController.text,
        difficulty: _difficultyController.text,
        description: _descriptionController.text,
      );
      if (widget.hike == null) {
        await DatabaseHelper().insertHike(hike);
      } else {
        await DatabaseHelper().updateHike(hike);
      }
      Navigator.pop(context, true);
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hike == null ? 'Add Hike' : 'Edit Hike'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Hike Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the hike name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Pick Date of Hike'
                    : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              TextFormField(
                controller: _lengthController,
                decoration: InputDecoration(labelText: 'Length (e.g., 5 km)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the hike length';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _difficultyController,
                decoration: InputDecoration(labelText: 'Level of Difficulty'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the difficulty level';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _parkingAvailable,
                onChanged: (value) {
                  setState(() {
                    _parkingAvailable = value;
                  });
                },
                items: ['Yes', 'No'].map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                decoration: InputDecoration(labelText: 'Parking Available'),
                validator: (value) => value == null ? 'Please select an option' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.hike == null ? 'Add Hike' : 'Update Hike'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
