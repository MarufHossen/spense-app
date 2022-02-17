import '../../../constants.dart';
import '../../../controller/qr_scan_controller.dart';
import '../../../model/scanner_data.dart';
import '../../../view/widgets/booking_card.dart';
import '../../../view/widgets/scanner_info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanHistory extends StatefulWidget {
  const ScanHistory({Key? key}) : super(key: key);

  @override
  _ScanHistoryState createState() => _ScanHistoryState();
}

class _ScanHistoryState extends State<ScanHistory> {
  @override
  Widget build(BuildContext context) {
    // QRScanController parcelController = Get.put(QRScanController());
    return GetBuilder<QRScanController>(builder: (qrScanController) {
      return FutureBuilder(
          future: qrScanController.getScanHistoy(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ScannerData>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(color: colorPrimary));
              case ConnectionState.done:
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(color: colorPrimary));
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      padding: const EdgeInsets.all(3.0),
                      itemBuilder: (BuildContext context, int index) {
                        return ScannerInfoCard(
                          scoroId: snapshot.data![index].booking!.scoroId,
                          trackingId:
                              snapshot.data![index].trackingId.toString(),
                          location: snapshot.data![index].location.toString(),
                          status: snapshot.data![index].status.toString(),
                          bookingDetails: snapshot
                              .data![index].booking!.bookingDescription
                              .toString(),
                        );
                      });
                }
              default:
                return const Center(
                    child: CircularProgressIndicator(color: colorPrimary));
            }
          });
    });
  }
}
