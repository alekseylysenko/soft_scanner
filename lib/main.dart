import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_easy_permission/constants.dart';
import 'package:flutter_easy_permission/easy_permissions.dart';
import 'package:flutter_scankit/flutter_scankit.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:soft_scanner/models/equipment.dart';
import 'package:soft_scanner/provider/barcode_provider.dart';
import 'package:soft_scanner/screens/add_to_bag.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soft_scanner/widget/boxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EquipmentAdapter());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BarCodeProvider()),
      ],
      child: MyApp(),
    ),
  );

  await Hive.openBox<Equipment>('equipment');
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

@override
const _permissions = const [
  Permissions.READ_EXTERNAL_STORAGE,
  Permissions.CAMERA
];

const _permissionGroup = const [PermissionGroup.Camera, PermissionGroup.Photos];

class _MyAppState extends State<MyApp> {
  late FlutterScankit scanKit;
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  String code = "";
  @override
  void initState() {
    super.initState();
    scanKit = FlutterScankit();
    scanKit.addResultListen((val) {
      debugPrint("scanning result:$val");
      setState(() {
        codeController.text = val ?? "";
        code = val ?? "";
        context.read<BarCodeProvider>().mutationCode(val);
      });
    });

    FlutterEasyPermission().addPermissionCallback(
        onGranted: (requestCode, perms, perm) {
          startScan();
        },
        onDenied: (requestCode, perms, perm, isPermanent) {});
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
          title: Container(
              child: Text('Мой рюкзак')),
        ),
        floatingActionButton: FloatButton(),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldName(nameController: nameController),
                SizedBox(
                  height: 32,
                ),
                Container(
                  padding: EdgeInsets.only(right: 40, left: 40),
                  child: TextField(
                      autofocus: true,
                      controller: codeController,
                      onChanged: (text) {
                        context.read<BarCodeProvider>().mutationCode(text);
                      },
                      decoration: InputDecoration(
                          helperText: "Введите серийный номер устройства",
                          hintText: "S/N")),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  child: Text("Сканировать штрих-код"),
                  onPressed: () async {
                    if (!await FlutterEasyPermission.has(
                        perms: _permissions, permsGroup: _permissionGroup)) {
                      FlutterEasyPermission.request(
                          perms: _permissions, permsGroup: _permissionGroup);
                    } else {
                      startScan();
                    }
                  },
                ),
                SizedBox(height: 32),
                SendButtonWidget(
                    codeController: codeController,
                    nameController: nameController)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FloatButton extends StatelessWidget {
  const FloatButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.business_center),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddToBagScreen()));
      },
    );
  }
}

class TextFieldName extends StatelessWidget {
  const TextFieldName({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return context.watch<BarCodeProvider>().newCode != "" &&
            context.watch<BarCodeProvider>().newCode.length > 7
        ? Container(
            padding: EdgeInsets.only(right: 40, left: 40),
            child: TextField(
              controller: nameController,
              onChanged: (text) {
                context.read<BarCodeProvider>().mutationName(text);
              },
              decoration: InputDecoration(
                  helperText: "Введите название устройства",
                  hintText: "Название"),
            ),
          )
        : Container();
  }
}

class SendButtonWidget extends StatefulWidget {
  final TextEditingController codeController;
  final TextEditingController nameController;
  SendButtonWidget(
      {required this.codeController, required this.nameController});

  @override
  _SendButtonWidgetState createState() => _SendButtonWidgetState();
}

class _SendButtonWidgetState extends State<SendButtonWidget> {
  Future? addEquipment(String name, String code) {
    final equipment = Equipment()
      ..name = widget.nameController.text
      ..code = widget.codeController.text
      ..applicationNumber = 0
      ..dateReceiving = DateTime.now()
      ..dateInstallation = DateTime.now()
      ..deleteEquipment = false;

    final box = Boxes.getEquipment();
    box.add(equipment);
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<BarCodeProvider>().newCode != "" &&
            context.watch<BarCodeProvider>().newCode.length > 7
        ? ElevatedButton(
            onPressed: () {
              addEquipment(
                  BarCodeProvider().newName, BarCodeProvider().newCode);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddToBagScreen()));
            },
            child: Text("Добавить в рюкзак"))
        : Container();
  }

  @override
  void dispose() {
    Hive.box('equipment').close();
    super.dispose();
  }
}
