import '../../../constants.dart';
import '../../../enums/booking_status_enum.dart';
import 'package:flutter/material.dart';

class ScannerInfoCard extends StatefulWidget {
  final int? scoroId;
  final String trackingId;
  final String location;
  final String status;
  final String bookingDetails;
  const ScannerInfoCard(
      {Key? key,
      required this.scoroId,
      required this.trackingId,
      required this.location,
      required this.status,
      required this.bookingDetails})
      : super(key: key);

  @override
  State<ScannerInfoCard> createState() => _ScannerInfoCardState();
}

class _ScannerInfoCardState extends State<ScannerInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        color: Colors.white,
        height: 150,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TRACK #" + widget.trackingId,
                    style: textStyleLarge,
                  ),
                  Chip(
                    label: Text(widget.status.toUpperCase(),
                        style: textStyleRegular),
                    backgroundColor: widget.status == BookingStatus.pending
                        ? Colors.yellow
                        : Colors.greenAccent,
                  ),
                ],
              ),
              Text(
                "Location: " + widget.location,
                style: textStyleLarge,
              ),
              Text(
                "Info: " + widget.bookingDetails,
                style: textStyleLarge,
              ),
            ])),
      ),
    );
  }
}
