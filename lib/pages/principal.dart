import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_menu.dart'; // importa drawer_menu.dart aquí
import 'dart:async';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> tasks = [];
  final StreamController<List<String>> _streamController =
      StreamController<List<String>>();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tasks = prefs.getStringList('tasks') ?? [];
    _streamController.add(tasks);
  }

  void removeTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tasks.removeAt(index);
    prefs.setStringList('tasks', tasks);
    _streamController.add(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To Do List')),
      drawer: DrawerMenu(),
      body: StreamBuilder<List<String>>(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmar'),
                            content: Text(
                                '¿Estás seguro de que quieres eliminar esta tarea?'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('Aceptar'),
                                onPressed: () {
                                  removeTask(index);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
