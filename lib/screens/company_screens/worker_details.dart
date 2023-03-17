import 'package:OMTECH/screens/company_screens/company_home.dart';
import 'package:OMTECH/screens/author_screens/engineer_projects.dart';
import 'package:OMTECH/screens/company_screens/worker_work_orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class BackPress extends ConsumerStatefulWidget {
  const BackPress({Key? key}) : super(key: key);

  @override
  ConsumerState<BackPress> createState() => _BackPressState();
}

class _BackPressState extends ConsumerState<BackPress> {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            width: 60,
            alignment: Alignment.bottomLeft,
            child: const Icon(Icons.arrow_back)));
  }
}

class WorkerDetails extends StatefulWidget {
  WorkerDetails(
      {Key? key,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.imgUrl})
      : super(key: key);

  String name;
  String email;
  String phone;
  String address;
  String imgUrl;

  @override
  State<WorkerDetails> createState() => _WorkerDetailsState();
}

class _WorkerDetailsState extends State<WorkerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Worker Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: BackPress()),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 600,
              width: double.infinity,
              color: const Color.fromRGBO(237, 245, 254, 1),
              padding: const EdgeInsets.only(top: 22, left: 10),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: getPic(),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '   Personal Information',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.name,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.email,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Tel Number',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.phone,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Address',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 120,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.address,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 42,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              WorkerWork(worker: widget.name)));
                    },
                    child: Container(
                      height: 50,
                      width: 285,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 174, 0, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'View Work Orders',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
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
    if (widget.imgUrl == '') {
      return SvgPicture.asset(
        'assets/images/image 3.svg',
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        widget.imgUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    }
  }
}
