import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spense_app/model/store.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final Function() onTap;
  const StoreCard({Key? key, required this.store, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: store.image,
              height: 80,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              store.name,
              style: const TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              store.cashbackAmount.toString() + "%",
              style: const TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            // const Text(
            //   "Cashback",
            //   style: TextStyle(
            //       fontFamily: "Nunito",
            //       fontSize: 20,
            //       color: Colors.black54,
            //       fontWeight: FontWeight.bold),
            // )
          ],
        ),
      ),
    );
  }
}
