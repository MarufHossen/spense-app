// import './controller/booking_controller.dart';
// import './enums/booking_status_enum.dart';
// import './model/booking.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:get/get.dart';

// void main() {
//   group('Controller Method Test', () {
//     BookingController parcelController = Get.put(BookingController());
//     test('Parcel history test', () async {
//       try {
//         List<Booking> parcelList = await parcelController.getAllScoroBookings();
//         expect(parcelList[0].orderId, 4);
//       } catch (e) {
//         fail("Failed with exeption");
//       }
//     });
//     test('Sent sms parcel history test', () async {
//       try {
//         List<Booking> parcelList =
//             await parcelController.getParcelListByStatus(BookingStatus.sent);
//         expect(parcelList[0].status, BookingStatus.pending);
//       } catch (e) {
//         fail("Failed with exeption");
//       }
//     });

//     // test('Test sending sms to test user', () async {
//     //   Parcel parcel = Parcel("testid1234", "test location",
//     //       "+8801995358872"); // phone number for twilio is fixed for trial. Dont change it.
//     //   try {
//     //     Parcel response = await parcelController.notifyCustomer(parcel);
//     //     expect(response.status, BookingStatus.sent);
//     //   } catch (e) {
//     //     fail("Failed with exeption");
//     //   }
//     // });
//   });
// }
