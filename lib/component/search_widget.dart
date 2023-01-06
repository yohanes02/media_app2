import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            isDense: true,
            hintText: "Search",
            alignLabelWithHint: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)))),
        controller: searchCtrl,
        onChanged: ((value) {}),
      ),
    );
  }
}
