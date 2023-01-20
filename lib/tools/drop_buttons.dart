import 'package:OMTECH/screens/author_screens/author_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../authentication/login.dart';

TextEditingController system = TextEditingController(text: '0');
TextEditingController subsystem = TextEditingController(text: '0');

class Drop extends StatefulWidget {
  const Drop({Key? key}) : super(key: key);

  @override
  State<Drop> createState() => _DropState();
}

String? mail;

String? value;

class _DropState extends State<Drop> {
  String dropdownValue = 'One';

  final authors = <String>[];

  Future<String> getData() async {
    //  final DocumentReference user =
    FirebaseFirestore.instance
        .collection("authors")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        authors.add(doc.get('name').toString());

        print('#####  ' + authors.first + '  #####');
      }
    });
    throw 'something went wrong';
  }

  Future<dynamic> getMail() async {
    //  final DocumentReference user =
    FirebaseFirestore.instance
        .collection("authors")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.get('name') == value) {
          mail = doc.get('email').toString();
          print('#####  ' + mail!);
        }
      }
    });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('authors').snapshots();

  @override
  void initState() {
    // getData();
    // getMail();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(mail);
    print(value);
    print(status);
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white, //background color of dropdown button
                    border: Border.all(
                        color: Colors.white,
                        width: 0), //border of dropdown button
                    borderRadius: BorderRadius.circular(8)));
          }
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              // hintText: "Email",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                value = newValue!;
                getMail();
              });
            },
            items: snapshot.data!.docs
                .map<DropdownMenuItem<String>>((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return DropdownMenuItem<String>(
                value: data['name'].toString(),
                child: Text(data['name'].toString()),
              );
            }).toList(),
          );
        });
  }
}

String? status;

class DropTwi extends StatefulWidget {
  const DropTwi({Key? key}) : super(key: key);

  @override
  State<DropTwi> createState() => _DropTwiState();
}

class _DropTwiState extends State<DropTwi> {
  @override
  Widget build(BuildContext context) {
    print(mail);
    print(value);
    print(status);
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: status,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        // hintText: "Email",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
        ),
      ),
      onChanged: (String? newValue) {
        setState(() {
          status = newValue!;
        });
      },
      items: <String>['Under Construction', 'Post Construction']
          .map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
    );
  }
}

String? type;

class ClientType extends StatefulWidget {
  const ClientType({Key? key}) : super(key: key);

  @override
  State<ClientType> createState() => _ClientTypeState();
}

class _ClientTypeState extends State<ClientType> {
  @override
  Widget build(BuildContext context) {
    print(mail);
    print(value);
    print(status);
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: type,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        // hintText: "Email",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
        ),
      ),
      onChanged: (String? newValue) {
        setState(() {
          type = newValue!;
        });
      },
      items: <String>['Agency', 'Other']
          .map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
    );
  }
}

String? engineerButton;

class EngineersDropDown extends StatefulWidget {
  const EngineersDropDown({Key? key}) : super(key: key);

  @override
  State<EngineersDropDown> createState() => _EngineersDropDownState();
}

class _EngineersDropDownState extends State<EngineersDropDown> {
  String dropdownValue = 'One';

  final authors = <String>[];

  Future<dynamic> getMail() async {
    //  final DocumentReference user =
    FirebaseFirestore.instance
        .collection("authors")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.get('name') == value) {
          mail = doc.get('email').toString();
          print('#####  ' + mail!);
        }
      }
    });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('engineers').snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(mail);
    print(value);
    print(status);
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white, //background color of dropdown button
                    border: Border.all(
                        color: Colors.white,
                        width: 0), //border of dropdown button
                    borderRadius: BorderRadius.circular(8)));
          }
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: engineerButton,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              // hintText: "Email",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                engineerButton = newValue!;
                getMail();
              });
            },
            items: snapshot.data!.docs
                .map<DropdownMenuItem<String>>((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return DropdownMenuItem<String>(
                value: data['name'].toString(),
                child: Text(data['name'].toString()),
              );
            }).toList(),
          );
        });
  }
}

String? clientButton;

class ClientsDropDown extends StatefulWidget {
  const ClientsDropDown({Key? key}) : super(key: key);

  @override
  State<ClientsDropDown> createState() => _ClientsDropDownState();
}

class _ClientsDropDownState extends State<ClientsDropDown> {
  String dropdownValue = 'One';

  final authors = <String>[];

  Future<String> getData() async {
    //  final DocumentReference user =
    FirebaseFirestore.instance
        .collection("clients")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        authors.add(doc.get('name').toString());

        print('#####  ' + authors.first + '  #####');
      }
    });
    throw 'something went wrong';
  }

  Future<dynamic> getMail() async {
    //  final DocumentReference user =
    FirebaseFirestore.instance
        .collection("authors")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.get('name') == value) {
          mail = doc.get('email').toString();
          print('#####  ' + mail!);
        }
      }
    });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('clients').snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white, //background color of dropdown button
                    border: Border.all(
                        color: Colors.white,
                        width: 0), //border of dropdown button
                    borderRadius: BorderRadius.circular(8)));
          }
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: clientButton,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              // hintText: "Email",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                clientButton = newValue!;
                getMail();
              });
            },
            items: snapshot.data!.docs
                .map<DropdownMenuItem<String>>((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return DropdownMenuItem<String>(
                value: data['name'].toString(),
                child: Text(data['name'].toString()),
              );
            }).toList(),
          );
        });
  }
}

String? companyAssign;

class CompaniesDropDown extends StatefulWidget {
  CompaniesDropDown({Key? key, required this.from}) : super(key: key);

  String from;

  @override
  State<CompaniesDropDown> createState() => _CompaniesDropDownState(from: from);
}

class _CompaniesDropDownState extends State<CompaniesDropDown> {
  _CompaniesDropDownState({required this.from});
  String from;
  String dropdownValue = 'One';

  final authors = <String>[];

  Future<String> getData() async {
    //  final DocumentReference user =
    FirebaseFirestore.instance
        .collection("companies")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        authors.add(doc.get('name').toString());

        print('#####  ' + authors.first + '  #####');
      }
    });
    throw 'something went wrong';
  }

  Future<dynamic> getMail() async {
    //  final DocumentReference user =
    FirebaseFirestore.instance
        .collection("authors")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.get('name') == value) {
          mail = doc.get('email').toString();
          print('#####  ' + mail!);
        }
      }
    });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('companies').snapshots();

  @override
  void initState() {
    // getData();
    // getMail();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (from == 'users') {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: Colors.white, //background color of dropdown button
            border: Border.all(
                color: Colors.white, width: 0), //border of dropdown button
            borderRadius: BorderRadius.circular(8)),
        child: Text(''),
      );
    }
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white, //background color of dropdown button
                    border: Border.all(
                        color: Colors.white,
                        width: 0), //border of dropdown button
                    borderRadius: BorderRadius.circular(8)));
          }
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: companyAssign,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Company',
              filled: true,
              fillColor: Colors.transparent,
              //prefixIcon: Icon(Icons.mail),
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black87, width: 0.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black87, width: 0.2),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                companyAssign = newValue!;
              });
            },
            items: snapshot.data!.docs
                .map<DropdownMenuItem<String>>((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return DropdownMenuItem<String>(
                value: data['name'].toString(),
                child: Text(data['name'].toString()),
              );
            }).toList(),
          );
        });
  }
}

String? systemButton;

class AssetSystems extends StatefulWidget {
  const AssetSystems({Key? key}) : super(key: key);

  @override
  State<AssetSystems> createState() => _AssetSystemsState();
}

class _AssetSystemsState extends State<AssetSystems> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('systems').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (snapshot.hasData) {
          } else {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black87, width: 0.2),
              ),
            );
          }
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: systemButton,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                hintText: 'System',
                filled: true,
                fillColor: Colors.transparent,
                //prefixIcon: Icon(Icons.mail),
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black87, width: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black87, width: 0.2),
                )),
            onChanged: (String? newValue) {
              setState(() {
                systemButton = newValue!;
                FirebaseFirestore.instance
                    .collection('drop_systems')
                    .where('name', isEqualTo: systemButton)
                    .get()
                    .then((value) {
                  for (var doc in value.docs) {
                    system.text = doc.id;
                    print(system.text);
                  }
                });
              });
            },
            items: snapshot.data!.docs
                .map<DropdownMenuItem<String>>((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return DropdownMenuItem<String>(
                value: data['name'].toString(),
                child: Text(data['name'].toString()),
              );
            }).toList(),
          );
        });
  }
}

String? subsystemButton;

String systemId = '0';

class AssetSubSystems extends StatefulWidget {
  AssetSubSystems({
    Key? key,
  }) : super(key: key);

  @override
  State<AssetSubSystems> createState() => _AssetSubSystemsState();
}

class _AssetSubSystemsState extends State<AssetSubSystems> {
  _AssetSubSystemsState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    system.addListener(() {
      setState(() {
        subsystemButton = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (systemButton == null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 0.2),
        ),
      );
    }

    if (subsystemButton != null) {
      return GestureDetector(
        onTap: () {
          setState(() {
            subsystemButton = null;
            subsystem.text = '';
          });
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black87, width: 0.2),
          ),
          child: Text(
            subsystemButton!,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      );
    }

    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('drop_systems')
        .doc(system.text)
        .collection('subsystems')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white, //background color of dropdown button
                    border: Border.all(
                        color: Colors.white,
                        width: 0), //border of dropdown button
                    borderRadius: BorderRadius.circular(8)));
          }

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            if (documents.length == 0) {
              return DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white, //background color of dropdown button
                      border: Border.all(
                          color: Colors.white,
                          width: 0), //border of dropdown button
                      borderRadius: BorderRadius.circular(8)));
            } else {
              return DropdownButtonFormField<String>(
                isExpanded: true,
                value: subsystemButton,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: Colors.black87),
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'Subsystem',
                    filled: true,
                    fillColor: Colors.transparent,
                    //prefixIcon: Icon(Icons.mail),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black87, width: 0.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black87, width: 0.2),
                    )),
                onChanged: (String? newValue) {
                  setState(() {
                    subsystemButton = newValue!;
                    FirebaseFirestore.instance
                        .collection('drop_systems')
                        .doc(system.text)
                        .collection('subsystems')
                        .where('name', isEqualTo: subsystemButton)
                        .get()
                        .then((value) {
                      for (var doc in value.docs) {
                        subsystem.text = doc.id;
                        print(subsystem.text);
                      }
                    });
                  });
                },
                items: documents
                    .map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return DropdownMenuItem<String>(
                    value: data['name'],
                    child: Text(data['name']!),
                  );
                }).toList(),
              );
            }
          }
          return DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white, //background color of dropdown button
                  border: Border.all(
                      color: Colors.white,
                      width: 0), //border of dropdown button
                  borderRadius: BorderRadius.circular(8)));
        });
  }
}

String? assetTypeButton;

class AssetTypes extends StatefulWidget {
  AssetTypes({
    Key? key,
    required this.action,
  }) : super(key: key);

  TextEditingController action;

  @override
  State<AssetTypes> createState() => _AssetTypesState(action: action);
}

class _AssetTypesState extends State<AssetTypes> {
  _AssetTypesState({required this.action});
  TextEditingController action;

  String temp = '18';

  String subsystemId = '18';

  @override
  void initState() {
    super.initState();
    subsystem.addListener(() {
      setState(() {
        if (subsystemButton == null) {
        } else {
          assetTypeButton = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // subsystem.addListener(() {
    //   setState(() {
    //     assetTypeButton = null;
    //   });
    // });
    if (subsystemButton == null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 0.2),
        ),
      );
    }

    if (assetTypeButton != null) {
      return GestureDetector(
        onTap: () {
          setState(() {
            assetTypeButton = null;
          });
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black87, width: 0.2),
          ),
          child: Text(
            assetTypeButton!,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      );
    }

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('drop_systems')
        .doc(system.text)
        .collection('subsystems')
        .doc(subsystem.text)
        .collection('asset_types')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown

          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white, //background color of dropdown button
                    border: Border.all(
                        color: Colors.white,
                        width: 0), //border of dropdown button
                    borderRadius: BorderRadius.circular(8)));
          }
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: assetTypeButton,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                hintText: 'Asset type',
                filled: true,
                fillColor: Colors.transparent,
                //prefixIcon: Icon(Icons.mail),
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black87, width: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black87, width: 0.2),
                )),
            onChanged: (String? newValue) {
              setState(() {
                assetTypeButton = newValue!;
              });
            },
            items: snapshot.data!.docs
                .map<DropdownMenuItem<String>>((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return DropdownMenuItem<String>(
                value: data['name'],
                child: Text(data['name']),
              );
            }).toList(),
          );
        });
  }
}

//document.id + '.' + ' ' +

DocumentSnapshot? projectsButton;
TextEditingController projectName = TextEditingController(text: '');
TextEditingController projectAuthor = TextEditingController(text: '');
TextEditingController projectClient = TextEditingController(text: '');
TextEditingController projectId = TextEditingController(text: '0');

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  Widget _customDropDownExample(BuildContext context, String item) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent, width: 0.0)),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, DocumentSnapshot item, bool isSelected) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black87, width: 0.2),
            ),
            child: Text(item.get('title'))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<DocumentSnapshot> documents = [];

  List<DocumentSnapshot> getList(
      TextEditingController controller, List<DocumentSnapshot> documentsList) {
    if (controller.text.length > 0) {
      documentsList = documentsList.where((element) {
        return element
            .get('title')
            .toString()
            .toLowerCase()
            .contains(controller.text.toLowerCase());
      }).toList();
    }
    return documentsList;
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('projects').snapshots();
  @override
  Widget build(BuildContext context) {
    TextEditingController projectSearchController = TextEditingController();
    projectSearchController.addListener(() {
      setState(() {});
    });
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white, //background color of dropdown button
                    border: Border.all(
                        color: Colors.white,
                        width: 0), //border of dropdown button
                    borderRadius: BorderRadius.circular(8)));
          }

          documents = snapshot.data!.docs;

          return DropdownSearch<DocumentSnapshot>(
            items: getList(projectSearchController, documents),
            itemAsString: (item) {
              return item.get('title');
            },
            selectedItem: projectsButton,
            onChanged: (value) {
              projectName.text = value?.get('title');
              projectAuthor.text = value?.get('managerName');
              projectClient.text = value?.get('client');
              projectId.text = value!.id;
              projectsButton = value;
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
              // suffixIcon:
              //     const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              filled: true,
              hoverColor: Colors.white70,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 0.8),
              ),
            )),
            popupProps: PopupProps.menu(
                emptyBuilder: _customDropDownExample,
                menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    controller: projectSearchController,
                    cursorColor: Colors.orange,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        //prefixIcon: Icon(Icons.vpn_key),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Search",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.black87, width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.orangeAccent, width: 0.8),
                        )),
                    textInputAction: TextInputAction.search),
                itemBuilder: _customPopupItemBuilderExample),
          );
        });
  }
}

String? priorityButton;

class Priority extends StatefulWidget {
  const Priority({Key? key}) : super(key: key);

  @override
  State<Priority> createState() => _PriorityState();
}

class _PriorityState extends State<Priority> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      isExpanded: true,
      value: priorityButton,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Priority',
        filled: true,
        fillColor: Colors.transparent,
        //prefixIcon: Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black87, width: 0.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black87, width: 0.2),
        ),
      ),
      onChanged: (String? newValue) {
        setState(() {
          priorityButton = newValue!;
        });
      },
      items: <String>['High', 'Medium', 'Low']
          .map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
    );
  }
}

DocumentSnapshot? roomsButton;
TextEditingController roomName = TextEditingController(text: '');

class Rooms extends StatefulWidget {
  Rooms({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  Widget _customDropDownExample(BuildContext context, String item) {
    return Container(
        decoration: BoxDecoration(
      border: Border.all(color: Colors.orange),
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ));
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, DocumentSnapshot item, bool isSelected) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 16,
            child: Text(item.get('name'))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectId.addListener(() {
      setState(() {});
    });
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('projects')
      .doc(projectId.text)
      .collection('addRooms')
      .snapshots();

  List<DocumentSnapshot> documents = [];

  List<DocumentSnapshot> getList(
      TextEditingController controller, List<DocumentSnapshot> documentsList) {
    if (controller.text.length > 0) {
      documentsList = documentsList.where((element) {
        return element
            .get('name')
            .toString()
            .toLowerCase()
            .contains(controller.text.toLowerCase());
      }).toList();
    }
    return documentsList;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController roomSearchController = TextEditingController();
    roomSearchController.addListener(() {
      setState(() {});
    });
    projectId.addListener(() {
      setState(() {});
    });
    projectName.addListener(() {
      setState(() {});
    });
    if (widget.title == '') {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 0.2),
        ),
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Safety check to ensure that snapshot contains data
            // without this safety check, StreamBuilder dirty state warnings will be thrown
            if (!snapshot.hasData) {
              return DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white, //background color of dropdown button
                      border: Border.all(
                          color: Colors.white,
                          width: 0), //border of dropdown button
                      borderRadius: BorderRadius.circular(8)));
            }

            documents = snapshot.data!.docs;

            return DropdownSearch<DocumentSnapshot>(
              items: getList(roomSearchController, documents),
              itemAsString: (item) {
                return item.get('name');
              },
              selectedItem: roomsButton,
              onChanged: (value) {
                roomName.text = value?.get('name');
                roomsButton = value!;
              },
              dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                // suffixIcon:
                //     const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                filled: true,
                hoverColor: Colors.white70,
                // icon: Icon(
                //   Icons.keyboard_arrow_down,
                //   size: 12,
                // ),
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: 'Room',
                // filled: true,
                // fillColor: Colors.transparent,
                // //prefixIcon: Icon(Icons.mail),
                // contentPadding:
                //     const EdgeInsets.fromLTRB(20, 15, 20, 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black87, width: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange, width: 0.4),
                ),
              )),
              popupProps: PopupProps.menu(
                  emptyBuilder: _customDropDownExample,
                  menuProps: MenuProps(
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                      controller: roomSearchController,
                      cursorColor: Colors.orange,
                      cursorWidth: 1,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          //prefixIcon: Icon(Icons.vpn_key),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Search",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.black87, width: 0.8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.orangeAccent, width: 0.8),
                          )),
                      textInputAction: TextInputAction.search),
                  itemBuilder: _customPopupItemBuilderExample),
            );
          });
    }
  }
}

class DropAuthorProjects extends StatefulWidget {
  const DropAuthorProjects({Key? key}) : super(key: key);

  @override
  State<DropAuthorProjects> createState() => _DropAuthorProjectsState();
}

class _DropAuthorProjectsState extends State<DropAuthorProjects> {
  Widget _customDropDownExample(BuildContext context, String item) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent, width: 0.0)),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, DocumentSnapshot item, bool isSelected) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black87, width: 0.2),
            ),
            child: Text(item.get('name'))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<DocumentSnapshot> documents = [];

  List<DocumentSnapshot> getList(
      TextEditingController controller, List<DocumentSnapshot> documentsList) {
    if (controller.text.length > 0) {
      documentsList = documentsList.where((element) {
        return element
            .get('name')
            .toString()
            .toLowerCase()
            .contains(controller.text.toLowerCase());
      }).toList();
    }
    return documentsList;
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('projects').snapshots();
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white, //background color of dropdown button
                    border: Border.all(
                        color: Colors.white,
                        width: 0), //border of dropdown button
                    borderRadius: BorderRadius.circular(8)));
          }

          documents = snapshot.data!.docs;
          return DropdownSearch<DocumentSnapshot>(
            items: getList(searchController, documents),
            itemAsString: (item) {
              projectAuthor.text = item.get('managerName');
              projectClient.text = item.get('client');
              return item.get('title');
            },
            selectedItem: assetButton,
            onChanged: (value) {
              assetButton = value!;
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
              // suffixIcon:
              //     const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              filled: true,
              hoverColor: Colors.white70,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 0.8),
              ),
            )),
            popupProps: PopupProps.menu(
                emptyBuilder: _customDropDownExample,
                menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    controller: searchController,
                    cursorColor: Colors.orange,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        //prefixIcon: Icon(Icons.vpn_key),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Search",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.black87, width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.orangeAccent, width: 0.8),
                        )),
                    textInputAction: TextInputAction.search),
                itemBuilder: _customPopupItemBuilderExample),
          );
        });
  }
}

String? expectancyButton;

class Expectancy extends StatefulWidget {
  const Expectancy({Key? key}) : super(key: key);

  @override
  State<Expectancy> createState() => _ExpectancyState();
}

class _ExpectancyState extends State<Expectancy> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      isExpanded: true,
      value: expectancyButton,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          hintText: 'Expectancy',
          filled: true,
          fillColor: Colors.transparent,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          )),
      onChanged: (String? newValue) {
        setState(() {
          expectancyButton = newValue!;
        });
      },
      items: <String>[
        '1 year',
        '2 years',
        '3 years',
        '4 years',
        '5 years',
        '6 years',
        '7 years',
        '8 years',
        '9 years',
        '10 years'
      ].map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
    );
  }
}

String? frequencyButton;
String? frequencyButtonTemp;

class Frequency extends StatefulWidget {
  const Frequency({Key? key}) : super(key: key);

  @override
  State<Frequency> createState() => _FrequencyState();
}

class _FrequencyState extends State<Frequency> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      isExpanded: true,
      value: frequencyButton,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Frequency',
        filled: true,
        fillColor: Colors.transparent,
        //prefixIcon: Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black87, width: 0.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black87, width: 0.2),
        ),
      ),
      onChanged: (String? newValue) {
        setState(() {
          frequencyButton = newValue!;
          frequencyButtonTemp = newValue;
        });
      },
      items: <String>[
        'Once',
        'Daily',
        'Weekly',
        '2 Weeks',
        'Monthly',
        '3 Months',
        '6 Months',
        'Annually'
      ].map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
    );
  }
}

String? natureButton;

class Nature extends StatefulWidget {
  const Nature({Key? key}) : super(key: key);

  @override
  State<Nature> createState() => _NatureState();
}

class _NatureState extends State<Nature> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      isExpanded: true,
      value: natureButton,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Nature',
        filled: true,
        fillColor: Colors.transparent,
        //prefixIcon: Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black87, width: 0.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black87, width: 0.2),
        ),
      ),
      onChanged: (String? newValue) {
        setState(() {
          natureButton = newValue!;
          textFrequency.text = natureButton!;
        });
      },
      items: <String>[
        'Preventative',
        'Reactive',
      ].map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
    );
  }
}

String? documentButton;
TextEditingController textFrequency = TextEditingController(text: '');

class DocumentType extends StatefulWidget {
  const DocumentType({Key? key}) : super(key: key);

  @override
  State<DocumentType> createState() => _DocumentTypeState();
}

class _DocumentTypeState extends State<DocumentType> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('document_types').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)));
          }

          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: documentButton,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              // hintText: "Email",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                documentButton = newValue!;
              });
            },
            items: snapshot.data!.docs
                .map<DropdownMenuItem<String>>((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return DropdownMenuItem<String>(
                value: data['name'].toString(),
                child: Text(data['name'].toString()),
              );
            }).toList(),
          );
        });
  }
}

DocumentSnapshot? assetButton;
TextEditingController assetName = TextEditingController(text: '');
TextEditingController assetIdController = TextEditingController(text: '');
TextEditingController assetDesignRef = TextEditingController(text: '');
TextEditingController uniqueAssetId = TextEditingController(text: '');

String assetId = '0';

class AssetDrop extends StatefulWidget {
  const AssetDrop({Key? key}) : super(key: key);

  @override
  State<AssetDrop> createState() => _AssetDropState();
}

class _AssetDropState extends State<AssetDrop> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('assets').snapshots();

  List<DocumentSnapshot> documents = [];

  Widget _customDropDownExample(BuildContext context, String item) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent, width: 0.0)),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, DocumentSnapshot item, bool isSelected) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black87, width: 0.2),
            ),
            child: Text(item.get('name'))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<DocumentSnapshot> getList(
      TextEditingController controller, List<DocumentSnapshot> documentsList) {
    if (controller.text.length > 0) {
      documentsList = documentsList.where((element) {
        return element
            .get('name')
            .toString()
            .toLowerCase()
            .contains(controller.text.toLowerCase());
      }).toList();
    }
    return documentsList;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
    final searchField = TextFormField(
        autofocus: false,
        controller: searchController,
        obscureText: false,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          return null;
        },
        onSaved: (value) {
          searchController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "What are you looking for?",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                const BorderSide(color: Colors.orangeAccent, width: 0.8),
          ),
        ));
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)));
          }

          documents = snapshot.data!.docs;

          return DropdownSearch<DocumentSnapshot>(
            items: getList(searchController, documents),
            itemAsString: (item) {
              return item.get('name');
            },
            selectedItem: assetButton,
            onChanged: (value) {
              assetName.text = value?.get('name');
              w_o_engineer.text = value?.get('engineer');
              w_o_category.text = value?.get('subsystem');
              assetIdController.text = value!.id;
              assetDesignRef.text = value.get('design');
              uniqueAssetId.text = value.get('unique_id');
              assetProject.text = value.get('project');
              assetLocation.text = value.get('room');
              assetButton = value;
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
              // suffixIcon:
              //     const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              filled: true,
              hoverColor: Colors.white70,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 0.8),
              ),
            )),
            popupProps: PopupProps.menu(
                emptyBuilder: _customDropDownExample,
                menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    controller: searchController,
                    cursorColor: Colors.orange,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        //prefixIcon: Icon(Icons.vpn_key),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Search",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.black87, width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.orangeAccent, width: 0.8),
                        )),
                    textInputAction: TextInputAction.search),
                itemBuilder: _customPopupItemBuilderExample),
          );
        });
  }
}

//   return DropdownButtonFormField<String>(
//     isExpanded: true,
//     value: assetButton,
//     icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
//     elevation: 16,
//     style: const TextStyle(color: Colors.black),
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//       // hintText: "Email",
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide(color: Colors.white, width: 1.5),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
//       ),
//     ),
//     onChanged: (dynamic newValue) {
//       setState(() {
//         assetButton = newValue!;
//         assetName.text = assetButton!;
//       });
//     },
//     items: snapshot.data!.docs
//         .map<DropdownMenuItem<String>>((DocumentSnapshot document) {
//       Map<String, dynamic> data =
//           document.data() as Map<String, dynamic>;
//       return DropdownMenuItem<String>(
//         value: data['name'],
//         child: Text(data['name']),
//       );
//     }).toList(),
//   );

TextEditingController assetProject = TextEditingController(text: '');
TextEditingController assetLocation = TextEditingController(text: '');
TextEditingController w_o_category = TextEditingController(text: '');
TextEditingController w_o_engineer = TextEditingController(text: '');

class AuthorAssetDrop extends StatefulWidget {
  const AuthorAssetDrop({Key? key}) : super(key: key);

  @override
  State<AuthorAssetDrop> createState() => _AuthorAssetDropState();
}

class _AuthorAssetDropState extends State<AuthorAssetDrop> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('assets')
      .where('author', isEqualTo: username)
      .snapshots();

  List<DocumentSnapshot> documents = [];

  Widget _customDropDownExample(BuildContext context, String item) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent, width: 0.0)),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, DocumentSnapshot item, bool isSelected) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black87, width: 0.2),
            ),
            child: Text(item.get('name'))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<DocumentSnapshot> getList(
      TextEditingController controller, List<DocumentSnapshot> documentsList) {
    if (controller.text.length > 0) {
      documentsList = documentsList.where((element) {
        return element
            .get('name')
            .toString()
            .toLowerCase()
            .contains(controller.text.toLowerCase());
      }).toList();
    }
    return documentsList;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
    final searchField = TextFormField(
        autofocus: false,
        controller: searchController,
        obscureText: false,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          return null;
        },
        onSaved: (value) {
          searchController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "What are you looking for?",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                const BorderSide(color: Colors.orangeAccent, width: 0.8),
          ),
        ));
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)));
          }

          documents = snapshot.data!.docs;

          return DropdownSearch<DocumentSnapshot>(
            items: getList(searchController, documents),
            itemAsString: (item) {
              return item.get('name');
            },
            selectedItem: assetButton,
            onChanged: (value) {
              assetName.text = value?.get('name');
              w_o_engineer.text = value?.get('engineer');
              w_o_category.text = value?.get('subsystem');
              assetIdController.text = value!.id;
              assetDesignRef.text = value.get('design');
              uniqueAssetId.text = value.get('unique_id');
              assetProject.text = value.get('project');
              assetLocation.text = value.get('room');
              assetButton = value;
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
              // suffixIcon:
              //     const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              filled: true,
              hoverColor: Colors.white70,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 0.8),
              ),
            )),
            popupProps: PopupProps.menu(
                emptyBuilder: _customDropDownExample,
                menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    controller: searchController,
                    cursorColor: Colors.orange,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        //prefixIcon: Icon(Icons.vpn_key),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Search",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.black87, width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.orangeAccent, width: 0.8),
                        )),
                    textInputAction: TextInputAction.search),
                itemBuilder: _customPopupItemBuilderExample),
          );
        });
  }
}

class ClientAssetDrop extends StatefulWidget {
  const ClientAssetDrop({Key? key}) : super(key: key);

  @override
  State<ClientAssetDrop> createState() => _ClientAssetDropState();
}

class _ClientAssetDropState extends State<ClientAssetDrop> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('assets')
      .where('client', isEqualTo: username)
      .snapshots();

  List<DocumentSnapshot> documents = [];

  Widget _customDropDownExample(BuildContext context, String item) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent, width: 0.0)),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, DocumentSnapshot item, bool isSelected) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black87, width: 0.2),
            ),
            child: Text(item.get('name'))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<DocumentSnapshot> getList(
      TextEditingController controller, List<DocumentSnapshot> documentsList) {
    if (controller.text.length > 0) {
      documentsList = documentsList.where((element) {
        return element
            .get('name')
            .toString()
            .toLowerCase()
            .contains(controller.text.toLowerCase());
      }).toList();
    }
    return documentsList;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
    final searchField = TextFormField(
        autofocus: false,
        controller: searchController,
        obscureText: false,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          return null;
        },
        onSaved: (value) {
          searchController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "What are you looking for?",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                const BorderSide(color: Colors.orangeAccent, width: 0.8),
          ),
        ));
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)));
          }

          documents = snapshot.data!.docs;

          return DropdownSearch<DocumentSnapshot>(
            items: getList(searchController, documents),
            itemAsString: (item) {
              return item.get('name');
            },
            selectedItem: assetButton,
            onChanged: (value) {
              assetName.text = value?.get('name');
              w_o_engineer.text = value?.get('engineer');
              w_o_category.text = value?.get('subsystem');
              assetIdController.text = value!.id;
              assetDesignRef.text = value.get('design');
              uniqueAssetId.text = value.get('unique_id');
              assetProject.text = value.get('project');
              assetLocation.text = value.get('room');
              assetButton = value;
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
              // suffixIcon:
              //     const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              filled: true,
              hoverColor: Colors.white70,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 0.8),
              ),
            )),
            popupProps: PopupProps.menu(
                emptyBuilder: _customDropDownExample,
                menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    controller: searchController,
                    cursorColor: Colors.orange,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        //prefixIcon: Icon(Icons.vpn_key),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Search",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.black87, width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.orangeAccent, width: 0.8),
                        )),
                    textInputAction: TextInputAction.search),
                itemBuilder: _customPopupItemBuilderExample),
          );
        });
  }
}
