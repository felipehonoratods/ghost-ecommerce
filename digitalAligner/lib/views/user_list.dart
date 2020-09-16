import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalAligner/views/editUser.dart';
import 'package:flutter/material.dart';

import 'addUser.dart';

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('form');

    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder(
        stream: users.snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Text('Não há usuários cadastrados!'),
            );
          }

          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Container(
                color: Colors.white,
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  title: Text(document.data()['nome']),
                  subtitle: Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4.0, 0),
                          child: Text(document.data()['email']),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                              child: Text('Endereço:'),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                              child: Text(document.data()['rua']),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                              child: Text(document.data()['complemento']),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                              child: Text(document.data()['numero']),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(','),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                              child: Text(document.data()['cidade']),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                              child: Text(document.data()['estado']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.orange,
                          onPressed: () => {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new EditUser()))
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => users.doc(document.id).delete(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddUser()))
        },
        tooltip: 'Novo usuário',
        child: Icon(Icons.add),
      ),
    );
  }
}
