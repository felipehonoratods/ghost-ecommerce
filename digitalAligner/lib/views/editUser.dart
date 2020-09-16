import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalAligner/list.dart';
import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _form = GlobalKey<FormState>();

  var nome = TextEditingController();
  var email = TextEditingController();
  var rua = TextEditingController();
  var complemento = TextEditingController();
  var numero = TextEditingController();
  var cidade = TextEditingController();
  var estado = TextEditingController();

  int _city = 0;

  List<ListItem> _dropdownItems = [
    ListItem(0, "Selecione seu estado"),
    ListItem(1, "Rondônia"),
    ListItem(2, "Acre"),
    ListItem(3, "Amazonas"),
    ListItem(4, "Pará"),
    ListItem(5, "Amapá"),
    ListItem(6, "Maranhão"),
    ListItem(6, "Pernambuco"),
    ListItem(7, "Espírito Santo"),
    ListItem(8, "Rio de Janeiro"),
    ListItem(9, "Rio Grande do Sul"),
    ListItem(10, "São Paulo"),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  AsyncSnapshot<QuerySnapshot> snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar usuário'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                if (_form.currentState.validate()) {
                  await FirebaseFirestore.instance
                      .collection('form')
                      .doc('WaDvJtgX7imSgFu6Kfao')
                      .update({
                    'nome': nome.text,
                    'email': email.text,
                    'rua': rua.text,
                    'complemento': complemento.text,
                    'numero': numero.text,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Preencha o campo obrigatório';
                  }
                  return null;
                },
                controller: nome,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                controller: email,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Rua',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                controller: rua,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Complemento',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                controller: complemento,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Numero',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                controller: numero,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Estado'),
                ],
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(10.0),
                child: DropdownButton<ListItem>(
                  value: _selectedItem,
                  hint: Text('Selecione seu estado'),
                  onChanged: (value) {
                    setState(() {
                      _selectedItem = value;
                      estado.text = _selectedItem.name;
                    });
                  },
                  items: _dropdownMenuItems,
                ),
              ),
              Row(
                children: [
                  Text('Cidade'),
                ],
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(10.0),
                child: DropdownButton(
                    value: _city,
                    items: [
                      DropdownMenuItem(
                        child: Text('Selecione sua cidade'),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text("Abreu e Lima"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("Olinda"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text("Igarassu"),
                        value: 3,
                      ),
                      DropdownMenuItem(
                        child: Text("Recife"),
                        value: 4,
                      ),
                      DropdownMenuItem(
                        child: Text("Jaboatão dos Guararapes"),
                        value: 5,
                      ),
                      DropdownMenuItem(
                        child: Text("Araripina"),
                        value: 6,
                      ),
                      DropdownMenuItem(
                        child: Text("Salgueiro"),
                        value: 7,
                      ),
                      DropdownMenuItem(
                        child: Text("Caruaru"),
                        value: 8,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _city = value;
                        cidade.text = "Cidade";
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
