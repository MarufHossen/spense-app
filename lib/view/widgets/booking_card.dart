import '../../../constants.dart';
import '../../../enums/booking_status_enum.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatefulWidget {
  final int? scoroId;
  final String orderId;
  final String status;
  final String bookingDetails;
  const BookingCard(
      {Key? key,
      required this.scoroId,
      required this.orderId,
      required this.status,
      required this.bookingDetails})
      : super(key: key);

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        color: Colors.white,
        height: 200,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ORDER #" + widget.orderId,
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
              const Text(
                "DETAILS",
                style: textStyleRegular,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  0.0,
                  8.0,
                  0.0,
                  8.0,
                ),
                child: Text(
                  widget.bookingDetails,
                  style: textStyleLarge,
                ),
              ),
              ElevatedButton(onPressed: () {}, child: const Text("Print"))
            ])),
      ),
    );
  }
}
