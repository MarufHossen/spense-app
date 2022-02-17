import '../api/booking_api.dart';
import '../controller/sidebar_controller.dart';
import '../enums/booking_status_enum.dart';
import '../model/booking.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  Future<List<Booking>> getAllScoroBookings() {
    return BookingApi.getAllScoroBookings();
  }

  Future<List<Booking>> getAllPrintedBookings() {
    return BookingApi.getAllPrintedBookings();
  }

  Future<List<Booking>> getParcelListByStatus(String status) async {
    try {
      List<Booking> bookingList = await getAllScoroBookings();
      List<Booking> sentParcelList = [];
      for (Booking element in bookingList) {
        if (element.status == status) {
          sentParcelList.add(element);
        }
      }
      return sentParcelList;
    } catch (e) {
      return [];
    }
  }

  Future<List<Booking>> getBookingList() {
    SidebarController sidebarController = Get.put(SidebarController());
    try {
      switch (sidebarController.selectedPageIndex) {
        case 1:
          return getParcelListByStatus(BookingStatus.pending);
        // return getAllScoroBookings();
        case 2:
          return getParcelListByStatus(BookingStatus.completed);
        case 3:
          return getAllPrintedBookings();
        default:
          return Future.value([]);
      }
    } catch (e) {
      return Future.value([]);
    }
  }
}
