import 'dart:convert';
import 'dart:developer';

import '../api/scanner_api.dart';
import '../controller/booking_controller.dart';
import '../controller/sidebar_controller.dart';
import '../enums/booking_status_enum.dart';
import '../model/scanner_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanController extends GetxController {
  late QRViewController qrViewController;
  late BookingController parcelController;
  late SidebarController sidebarController;

  late bool isSending;
  late String status = "scanning qr";
  late String scannedData;

  // late Parcel parcelScanData;

  @override
  void onInit() {
    isSending = false;
    parcelController = Get.put(BookingController());
    sidebarController = Get.put(SidebarController());
    super.onInit();
  }

  @override
  void onClose() {
    qrViewController.dispose();
    super.onClose();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  Future<void> onQRViewCreated(QRViewController controller) async {
    qrViewController = controller;

    qrViewController.scannedDataStream.listen((scanData) async {
      qrViewController.pauseCamera();
      status = BookingStatus.pending;

      // isSending = true;
      update(["qr_scan"]);

      try {
        String orderId = parseDateFromQR(scanData)!;
        // Placemark currentPlace = await sidebarController.getCurrentAddress();
        // ScannerData scannerData = ScannerData(
        //     location: currentPlace.street,
        //     message:
        //         "Your product is now at " + currentPlace.locality.toString());
        // ScannerData? response =
        //     await ScannerApi.addNewScannerData(orderId, scannerData);
        // // isSending = false;
        // status = response!.status!;
        update(["qr_scan"]);
        // qrViewController.resumeCamera();
        // print(response.status);
      } catch (e) {
        status = "scaning qr";
        update(["qr_scan"]);
        print(e.toString());
      }
    });
  }

  String? parseDateFromQR(Barcode scanData) {
    try {
      String trackingId = scanData.code.toString();
      return trackingId.split("-")[0];
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<List<ScannerData>> getScanHistoy() {
    return ScannerApi.getAllScanHistory();
  }
}
