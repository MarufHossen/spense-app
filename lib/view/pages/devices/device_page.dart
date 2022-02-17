import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  // ignore: prefer_typing_uninitialized_variables
  var _device;
  bool _connected = false;
  bool _pressed = false;
  late String pathImage;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // initSavetoPath();
  }

  // initSavetoPath() async {
  //   //read and write
  //   //image max 300px X 300px
  //   const filename = 'yourlogo.png';
  //   var bytes = await rootBundle.load("assets/images/yourlogo.png");
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   writeToFile(bytes, '$dir/$filename');
  //   setState(() {
  //     pathImage = '$dir/$filename';
  //   });
  // }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
      bluetooth.onRead();
      print(devices);
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name!),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected!) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void _tesPrint() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        bluetooth.printNewLine();
        bluetooth.printCustom("HEADER", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printImage(pathImage); //path of your image/logo
        bluetooth.printNewLine();
        //bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        bluetooth.printLeftRight("LEFT", "RIGHT", 0);
        bluetooth.printLeftRight("LEFT", "RIGHT", 1);
        bluetooth.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", 2);
        bluetooth.printLeftRight("LEFT", "RIGHT", 3);
        bluetooth.printLeftRight("LEFT", "RIGHT", 4);
        bluetooth.printNewLine();
        bluetooth.print3Column("Col1", "Col2", "Col3", 1);
        bluetooth.print3Column("Col1", "Col2", "Col3", 1,
            format: "%-10s %10s %10s %n");
        bluetooth.printNewLine();
        bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1);
        bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1,
            format: "%-8s %7s %7s %7s %n");
        bluetooth.printNewLine();
        String testString = " čĆžŽšŠ-H-ščđ";
        bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
        bluetooth.printLeftRight("Številka:", "18000001", 1,
            charset: "windows-1250");
        bluetooth.printCustom("Body left", 1, 0);
        bluetooth.printCustom("Body right", 0, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You", 2, 1);
        bluetooth.printNewLine();
        bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Device:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton(
                items: _getDeviceItems(),
                onChanged: (value) => setState(() => _device = value),
                value: _device,
              ),
              ElevatedButton(
                onPressed: _pressed
                    ? null
                    : _connected
                        ? _disconnect
                        : _connect,
                child: Text(_connected ? 'Disconnect' : 'Connect'),
                // style: ,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
          child: ElevatedButton(
            onPressed: _connected ? _tesPrint : null,
            child: const Text('Test Print'),
          ),
        ),
      ],
    );
  }
}
