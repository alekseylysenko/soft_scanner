import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_easy_permission/constants.dart';
import 'package:flutter_easy_permission/easy_permissions.dart';
import 'package:flutter_scankit/flutter_scankit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const _permissions = const [
  Permissions.READ_EXTERNAL_STORAGE,
  Permissions.CAMERA
];

const _permissionGroup = const [
  PermissionGroup.Camera,
  PermissionGroup.Photos
];

class _MyAppState extends State<MyApp> {
  late FlutterScankit scanKit;
  final codeController = TextEditingController();
  String code = "";
  @override
  void initState() {
    super.initState();
    scanKit = FlutterScankit();
    scanKit.addResultListen((val) {
      debugPrint("scanning result:$val");
      setState(() {
        codeController.text = val??"";
        code = val??"";
      });
    });

    FlutterEasyPermission().addPermissionCallback(
        onGranted: (requestCode, perms,perm) {
          startScan();
        },
        onDenied: (requestCode, perms,perm, isPermanent) {});
  }

  @override
  void dispose() {
    scanKit.dispose();
    super.dispose();
  }

  Future<void> startScan() async {
    try {
      await scanKit.startScan(scanTypes: [ScanTypes.ALL]);
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Добавить оборудование в рюкзак'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(right: 40, left: 40),
                child: TextField(
                  controller: codeController,
                  decoration: InputDecoration(helperText: "Введите серийный номер устройства", hintText: "S/N")
                  ),
              ),
              SizedBox(height: 32,),
              ElevatedButton(
                child: Text("Сканировать штрих-код"),
                onPressed: () async {
                  if (!await FlutterEasyPermission.has(perms: _permissions,permsGroup: _permissionGroup)) {
                    FlutterEasyPermission.request(perms: _permissions,permsGroup: _permissionGroup);
                  } else {
                    startScan();
                  }
                },
              ),
              SizedBox(height: 32,),
              SendButtonWidget(codeController : codeController)
            ],
          ),
        ),
      ),
    );
  }
}

class SendButtonWidget extends StatefulWidget {
  final TextEditingController codeController;
  SendButtonWidget({required this.codeController
  });

  @override
  _SendButtonWidgetState createState() => _SendButtonWidgetState();
}

class _SendButtonWidgetState extends State<SendButtonWidget> {
 
  @override
  Widget build(BuildContext context) {
    return
     widget.codeController.text != ""
    
    ?  ElevatedButton(onPressed: (){}, child: Text("Добавить в рюкзак"))
    : Container();
  }
}