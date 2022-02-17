import '../model/base.dart';
import '../model/booking.dart';

class ScannerData {
  int? id;
  String? location;
  String? message;
  String? status;
  String? trackingId;
  Booking? booking;

  ScannerData(
      {this.id,
      this.location,
      this.message,
      this.status,
      this.trackingId,
      this.booking});

  ScannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    message = json['message'];
    status = json['status'];
    trackingId = json['trackingId'];
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location'] = location;
    data['message'] = message;
    data['status'] = status;
    data['trackingId'] = trackingId;
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    return data;
  }
}
