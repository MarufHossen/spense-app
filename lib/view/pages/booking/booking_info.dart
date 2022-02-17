import '../../../constants.dart';
import '../../../controller/booking_controller.dart';
import '../../../controller/sidebar_controller.dart';
import '../../../model/booking.dart';
import '../../../view/widgets/booking_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingInfo extends StatefulWidget {
  final String? status;
  const BookingInfo({Key? key, this.status}) : super(key: key);

  @override
  _ParcelInfoState createState() => _ParcelInfoState();
}

class _ParcelInfoState extends State<BookingInfo> {
  @override
  Widget build(BuildContext context) {
    BookingController parcelController = Get.put(BookingController());
    return GetBuilder<SidebarController>(builder: (sidebarController) {
      return FutureBuilder(
          future: parcelController.getBookingList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
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
                        return BookingCard(
                          scoroId: snapshot.data![index].scoroId,
                          orderId: snapshot.data![index].orderId.toString(),
                          status: snapshot.data![index].status.toString(),
                          bookingDetails: snapshot
                              .data![index].bookingDescription
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
