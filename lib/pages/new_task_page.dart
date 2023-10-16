import 'principal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewTaskPage extends StatefulWidget {
  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            ListTile(
              title: Text(
                  'Fecha de inicio: ${DateFormat('dd/MM/yyyy').format(_startDate)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _startDate = date;
                  });
                }
              },
            ),
            ListTile(
              title: Text(
                  'Fecha de fin: ${DateFormat('dd/MM/yyyy').format(_endDate)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _endDate = date;
                  });
                }
              },
            ),
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  List<String> tasks = prefs.getStringList('tasks') ?? [];
                  tasks.add(_nameController.text);
                  await prefs.setStringList('tasks', tasks);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Guardando tarea...')));
                  Navigator.pop(context);
                  MainScreen().createState().loadTasks();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
