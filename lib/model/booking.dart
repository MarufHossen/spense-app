class Booking {
  int? id;
  String? trackingId;
  int? scoroId;
  String? orderId;
  int? personId;
  String? personEmail;
  String? ownerEmail;
  String? bookingDescription;
  String? status;

  Booking(
      {this.id,
      this.trackingId,
      this.scoroId,
      this.orderId,
      this.personId,
      this.personEmail,
      this.ownerEmail,
      this.bookingDescription,
      this.status});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackingId = json['trackingId'];
    scoroId = json['scoroId'];
    orderId = json['orderId'];
    personId = json['personId'];
    personEmail = json['personEmail'];
    ownerEmail = json['ownerEmail'];
    bookingDescription = json['bookingDescription'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trackingId'] = trackingId;
    data['scoroId'] = scoroId;
    data['orderId'] = orderId;
    data['personId'] = personId;
    data['personEmail'] = personEmail;
    data['ownerEmail'] = ownerEmail;
    data['bookingDescription'] = bookingDescription;
    data['status'] = status;
    return data;
  }
}

// import './model/base.dart';

// class Booking {
//   int? id;
//   String trackingId;
//   int scoroId;
//   String orderId;
//   int personId;
//   String personEmail;
//   String ownerEmail;
//   String bookingDescription;
//   String status;

//   Booking(
//     this.trackingId,
//     this.scoroId,
//     this.orderId,
//     this.personId,
//     this.personEmail,
//     this.ownerEmail,
//     this.bookingDescription,
//     this.status,
//   );

//   Booking.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         trackingId = json['trackingId'],
//         scoroId = json['scoroId'],
//         orderId = json['orderId'],
//         personId = json['personId'],
//         personEmail = json['personEmail'],
//         ownerEmail = json['ownerEmail'],
//         bookingDescription = json['bookingDescription'],
//         status = json['status'];

//   // Map<String, dynamic> toJson() {
//   //   final Map<String, dynamic> data = <String, dynamic>{};
//   //   data['id'] = id;
//   //   data['trackingId'] = trackingId;
//   //   data['scoroId'] = scoroId;
//   //   data['orderId'] = orderId;
//   //   data['personId'] = personId;
//   //   data['personEmail'] = personEmail;
//   //   data['ownerEmail'] = ownerEmail;
//   //   data['bookingDescription'] = bookingDescription;
//   //   data['status'] = status;
//   //   return data;
//   // }
// }
