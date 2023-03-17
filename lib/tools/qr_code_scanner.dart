import 'dart:typed_data';

import 'package:OMTECH/screens/company_screens/asset_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:async';

class ScanScreen extends ConsumerStatefulWidget {
  ScanScreen({this.from});
  @override
  _ScanScreenState createState() => _ScanScreenState();

  String? from;
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  String barcodeGet = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(42, 44, 55, 1),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        // onDetect: ((barcode, args) {
        //   barcode.format;
        //   barcode.rawValue;
        //   setState(() {
        //     print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
        //     barcodeGet = barcode.rawValue.toString();
        //     print(barcodeGet);
        //   });
        //   searchAsset(barcode.rawValue.toString());
        // }),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            searchAsset(barcode.rawValue.toString());
          }
        },
      ),
    );
  }

  String assetId = '',
      date = '',
      imgUrl = '',
      id = '',
      name = '',
      location = '',
      project = '',
      design = '',
      serial = '',
      model = '',
      status = '',
      system = '',
      subsystem = '',
      type = '',
      engineer = '',
      expectancy = '',
      details = '';

  void searchAsset(String bar) async {
    await FirebaseFirestore.instance
        .collection('assets')
        .where(
          'unique_id',
          isEqualTo: bar,
        )
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          assetId = doc.id;
          date = doc.get('date');
          id = doc.get('unique_id');
          imgUrl = '';
          name = doc.get('name');
          project = doc.get('project');
          design = doc.get('design');
          serial = doc.get('serial_number');
          location = doc.get('room_location');
          model = doc.get('model');
          status = doc.get('status');
          system = doc.get('system');
          subsystem = doc.get('subsystem');
          type = doc.get('type');
          engineer = doc.get('engineer');
          expectancy = doc.get('expectancy');
          details = doc.get('details');
        });
      }
    });
    if (assetId == '') {
      _showAssignDialog();
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AssetDetails(
              assetId: assetId,
              date: date,
              id: id,
              imgUrl: imgUrl,
              name: name,
              project: project,
              design: design,
              serial: serial,
              location: location,
              model: model,
              status: status,
              system: system,
              subsystem: subsystem,
              type: type,
              engineer: engineer,
              expectancy: expectancy,
              details: details)));
    }
  }

  Future<void> _showAssignDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          content: Align(
            alignment: Alignment.center,
            child: Container(
              height: 300,
              width: 321,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'No assets match your search',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                      child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 0.5,
                            width: double.infinity,
                            color: Colors.orange,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(right: 50),
                                    alignment: Alignment.center,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 70,
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )),
                              ),
                              Container(
                                width: 0.5,
                                height: 50,
                                color: Colors.orange,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(left: 50),
                                    alignment: Alignment.center,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 70,
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
