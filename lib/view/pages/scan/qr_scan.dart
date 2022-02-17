import 'dart:io';
import '../../../controller/qr_scan_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  // Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    // QRScanController qrScanController = Get.put(QRScanController());
    return Scaffold(
        body: GetBuilder<QRScanController>(
            id: "qr_scan",
            init: QRScanController(),
            builder: (QRScanController viewController) {
              return Column(
                children: <Widget>[
                  Expanded(flex: 4, child: _buildQrView(context)),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Text('Scan Parcel QR Label'),
                          Text(
                            'Last SMS status: ${viewController.status}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await viewController.qrViewController
                                        .resumeCamera();
                                  },
                                  child: const Text('Rescan',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    QRScanController qrScanController = Get.put(QRScanController());
    return QRView(
      key: qrKey,
      onQRViewCreated: qrScanController.onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.black,
          borderRadius: 8,
          borderLength: 30,
          borderWidth: 8,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) =>
          qrScanController.onPermissionSet(context, ctrl, p),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
