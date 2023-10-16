import 'about_page.dart';
import 'new_task_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menú'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Nueva tarea'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewTaskPage()));
            },
          ),
          ListTile(
            title: Text('Borrar todo'),
            onTap: () async {
              // Borra todas las tareas
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('tasks');
            },
          ),
          ListTile(
            title: Text('Acerca de'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),
          ListTile(
            title: Text('Salir'),
            onTap: () async {
              // Lleva a la pantalla de login
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
