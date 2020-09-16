import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:digitalAligner/list.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  fb.UploadTask _uploadTask;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar usuário'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                if (_form.currentState.validate()) {
                  await FirebaseFirestore.instance.collection('form').add({
                    'nome': nome.text,
                    'email': email.text,
                    'rua': rua.text,
                    'complemento': complemento.text,
                    'numero': numero.text,
                    'estado': estado.text,
                    'cidade': cidade.text,
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
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'picker',
        elevation: 0,
        hoverElevation: 0,
        onPressed: () {
          uploadImage();
        },
        label: Row(
          children: <Widget>[
            Icon(Icons.file_upload),
            SizedBox(width: 10),
            Text('Adiconar Imagem')
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  uploadImage() async {
    // HTML input element
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen(
      (changeEvent) {
        final file = uploadInput.files.first;
        final reader = FileReader();
        // The FileReader object lets web applications asynchronously read the
        // contents of files (or raw data buffers) stored on the user's computer,
        // using File or Blob objects to specify the file or data to read.
        // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader

        reader.readAsDataUrl(file);
        // The readAsDataURL method is used to read the contents of the specified Blob or File.
        //  When the read operation is finished, the readyState becomes DONE, and the loadend is
        // triggered. At that time, the result attribute contains the data as a data: URL representing
        // the file's data as a base64 encoded string.
        // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader/readAsDataURL

        reader.onLoadEnd.listen(
          // After file finiesh reading and loading, it will be uploaded to firebase storage
          (loadEndEvent) async {
            uploadToFirebase(file);
          },
        );
      },
    );
  }

  uploadToFirebase(File imageFile) async {
    final filePath = 'images/${DateTime.now()}.png';
    setState(() {
      _uploadTask = fb
          .storage()
          .refFromURL('gs://digital-aligner-desafio.appspot.com/')
          .child(filePath)
          .put(imageFile);
    });
  }
}
