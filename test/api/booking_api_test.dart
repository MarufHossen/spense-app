import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:spense_app/api/booking_api.dart';
import 'package:spense_app/model/booking.dart';

void main() {
  var logger = Logger();
  group('Booking API Testing', () {
    test('Get All Bookings from Scoro', () async {
      try {
        List<Booking> bookingList = await BookingApi.getAllScoroBookings();
        logger.i(bookingList[0].orderId);
        expect(bookingList[0].orderId, "1");
      } catch (e) {
        fail("10001: Failed with exeption");
      }
    });

    test('Get All Printed Bookings', () async {
      try {
        List<Booking> bookingList = await BookingApi.getAllPrintedBookings();
        logger.i(bookingList[0].trackingId);
        expect(bookingList[0].trackingId, "2-AT1XE4M2G5");
      } catch (e) {
        fail("10002: Failed with exeption");
      }
    });

    // test('Test sending sms to test user', () async {
    //   Parcel parcel = Parcel("testid1234", "test location",
    //       "+8801995358872"); // phone number for twilio is fixed for trial. Dont change it.
    //   try {
    //     Parcel response = await parcelController.notifyCustomer(parcel);
    //     expect(response.status, BookingStatus.sent);
    //   } catch (e) {
    //     fail("Failed with exeption");
    //   }
    // });
  });
}
