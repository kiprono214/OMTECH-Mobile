import 'package:OMTECH/screens/author_screens/author_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

TextEditingController system = TextEditingController(text: '0');
TextEditingController subsystem = TextEditingController(text: '0');

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
                    color: Colors.white, //background color of dropdown button
                    border: Border.all(
                        color: Colors.white,
                        width: 0), //border of dropdown button
                    borderRadius: BorderRadius.circular(8)));
          }
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: systemButton,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "System",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black87, width: 0.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
              ),
            ),
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
              color: Colors.white, //background color of dropdown button
              border: Border.all(
                  color: Colors.white, width: 0), //border of dropdown button
              borderRadius: BorderRadius.circular(8)));
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
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Sub System ",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black87, width: 0.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 0.1),
                  ),
                ),
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
        assetTypeButton = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (subsystemButton == null) {
      return DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white, //background color of dropdown button
              border: Border.all(
                  color: Colors.white, width: 0), //border of dropdown button
              borderRadius: BorderRadius.circular(8)));
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
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Asset Type",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black87, width: 0.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
              ),
            ),
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

String? roomsButton;

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  State<Rooms> createState() => _RoomsState();
}

String projectId = '0';

class _RoomsState extends State<Rooms> {
  Future<void> getProjId() async {
    List<List> temp = [];
    await FirebaseFirestore.instance
        .collection('projects')
        .where('title', isEqualTo: titleClick)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          projectId = doc.id;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getProjId();
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('addRooms')
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
            value: roomsButton,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "(Room)",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black87, width: 0.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                roomsButton = newValue!;
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
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Life Expectancy",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black87, width: 0.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.orangeAccent, width: 0.1),
        ),
      ),
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

String? documentButton;

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
