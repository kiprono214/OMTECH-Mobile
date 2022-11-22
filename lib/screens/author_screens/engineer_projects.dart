import 'package:OMTECH/screens/author_screens/engineer_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EngineerProjects extends StatefulWidget {
  EngineerProjects({Key? key, required this.name}) : super(key: key);

  String name;

  @override
  State<EngineerProjects> createState() => _EngineerProjectsState();
}

class _EngineerProjectsState extends State<EngineerProjects> {
  List<DocumentSnapshot> documents = [];
  void getProjects() async {
    List projects = [];
    List engineerProjects = [];

    await FirebaseFirestore.instance.collection('projects').get().then((value) {
      for (var doc in value.docs) {
        projects.add(doc.id);
      }
    });

    for (var id in projects) {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(id)
          .collection('engineers')
          .get()
          .then((value) {
        List current = [];
        for (var doc in value.docs) {
          current.add(doc.get('name'));
        }
        if (current.contains(widget.name)) {
          engineerProjects.add(id);
          print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   ' +
              engineerProjects.length.toString());
        }
      });
    }

    await FirebaseFirestore.instance.collection('projects').get().then((value) {
      for (var doc in value.docs) {
        if (engineerProjects.contains(doc.id)) {
          documents.add(doc);
        }
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProjects();
  }

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          hintText: "Search",
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
    if (searchController.text.length > 0) {
      documents = documents.where((element) {
        return element
            .get('title')
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }).toList();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          widget.name + ' Projects',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      GestureDetector(
                          child: Container(
                              width: 60,
                              alignment: Alignment.bottomLeft,
                              child: const Icon(Icons.arrow_back)))
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(
                            1.2,
                            1.2,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ), //BoxShadow
                      ],
                    ),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: searchField,
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 5),
                          child: Container(
                              height: 36,
                              width: 36,
                              margin: const EdgeInsets.only(left: 280),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Color.fromRGBO(255, 204, 3, 1)),
                              child: SvgPicture.asset(
                                  'assets/images/Combined Shape.svg')),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: 600,
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: SingleChildScrollView(
                  child: Column(
                      children: documents
                          .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;

                            return ProjectView(
                                title: data['title'], address: data['address']);

                            // data['room_location']
                          })
                          .toList()
                          .cast()),
                ))

            // children:
          ],
        )),
      ),
    );
  }
}

class ProjectView extends StatefulWidget {
  ProjectView({Key? key, required this.title, required this.address})
      : super(key: key);

  String title;
  String address;

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  String imgUrl = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 120,
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.5),
          color: const Color.fromRGBO(0, 122, 255, 0.1)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.all(0.25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), child: getPic()),
            ),
            SizedBox(
              width: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 180,
                    height: 40,
                    child: Text(
                      widget.title,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 180,
                    height: 40,
                    child: Text(
                      widget.address,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getPic() {
    if (imgUrl == '') {
      return SvgPicture.asset(
        'assets/images/image 3.svg',
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        imgUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    }
  }
}
