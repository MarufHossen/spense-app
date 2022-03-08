import 'package:flutter/material.dart';
import 'package:spense_app/constants.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: colorSearchBarBackground,
                  borderRadius: BorderRadius.circular(5)),
              child: const Center(
                child: TextField(
                  showCursor: true,
                  // cursorRadius: const Radius.circular(10.0),
                  style: TextStyle(
                      fontFamily: "Nunito", fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      border: InputBorder.none),
                ),
              ),
            );
  }
}