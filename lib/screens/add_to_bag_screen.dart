import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_permission/easy_permissions.dart';
import 'package:flutter_scankit/flutter_scankit.dart';
import 'package:hive/hive.dart';
import 'package:soft_scanner/models/equipment.dart';
import 'package:soft_scanner/provider/barcode_provider.dart';
import 'package:provider/provider.dart';
import 'package:soft_scanner/widget/bottom_navigation_bar.dart';
import 'package:soft_scanner/widget/boxes.dart';

import 'bag_screen.dart';

class AddToBagScreen extends StatefulWidget {
  const AddToBagScreen({Key? key}) : super(key: key);

  @override
  _AddToBagScreenState createState() => _AddToBagScreenState();
}

@override
const _permissions = const [
  Permissions.READ_EXTERNAL_STORAGE,
  Permissions.CAMERA
];

const _permissionGroup = const [PermissionGroup.Camera, PermissionGroup.Photos];

class _AddToBagScreenState extends State<AddToBagScreen> {
  late FlutterScankit scanKit;
  final _formKey = GlobalKey<FormState>();
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
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.document_scanner),
            onPressed: () async {
              if (!await FlutterEasyPermission.has(
                  perms: _permissions, permsGroup: _permissionGroup)) {
                FlutterEasyPermission.request(
                    perms: _permissions, permsGroup: _permissionGroup);
              } else {
                startScan();
              }
            }),
        appBar: AppBar(
          title: Container(child: Text('Добавить в рюкзак')),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldName(nameController: nameController),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 40, left: 40),
                    child: TextFormField(
                        //Форма ввода серийного номера устройства
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста введите серийный номер';
                          }
                        },
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
                  SendButtonWidget(
                      codeController: codeController,
                      nameController: nameController,
                      formKey: _formKey)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldName extends StatelessWidget {
  // Поле ввода наиенования оборудования
  const TextFieldName({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return context.watch<BarCodeProvider>().newCode != "" &&
            context.watch<BarCodeProvider>().newCode.length >
                7 //Если строка с штрих кодом не пустая и больше 7 знаков то показывать форму Наименование
        ? Container(
            padding: EdgeInsets.only(right: 40, left: 40),
            child: TextFormField(
              controller: nameController,
              onChanged: (text) {
                context.read<BarCodeProvider>().mutationName(text);
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Это тоже нужно заполнить';
                }
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
  // Кнопка добавления данных в базу и перехода в рюкзак
  final TextEditingController codeController;
  final TextEditingController nameController;
  final GlobalKey<FormState> formKey;
  SendButtonWidget(
      {required this.codeController,
      required this.nameController,
      required this.formKey});

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
              if (widget.formKey.currentState!.validate()) {
                addEquipment(
                    BarCodeProvider().newName, BarCodeProvider().newCode);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavigationBarBag()));
              }
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
