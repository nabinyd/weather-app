// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:weatherapi/api/api_service.dart';

class SearchBarExample extends StatefulWidget {
  SearchBarExample({super.key, required this.city});
  String city = '';
  @override
  _SearchBarExampleState createState() => _SearchBarExampleState();
}

class _SearchBarExampleState extends State<SearchBarExample> {
  String city = '';
  final TextEditingController _controller = TextEditingController();

  /* ----------------------------- list of cities ----------------------------- */
  List<String> items = [
    'london',
    'janakpur',
    'kathmandu',
    'delhi',
    'mumbai',
  ];

  List<String> filteredItems = [];

  Future handleInputValue(String value) async {
    setState(() {
      city = value;
    });
    return city;
  }

/* ---------------------------- filter from list ---------------------------- */
  void filterItems(String query) {
    setState(() {
      try {
        filteredItems = items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } catch (e) {
        Text(' Error: $e');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filteredItems.addAll(items);
    print('from textField we got: $city');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("City Search"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onChanged: (query) {
                filterItems(query);
                // handleInputValue(
                //   query,
                // );
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search for items...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredItems[index]),
                  onTap: () {
                    city = filteredItems[index];

                    print(
                        '$city is the value of city from listView when tapped on it');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ApiService(location: city),
                    ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
