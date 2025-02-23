import 'package:flutter/material.dart';
import 'module.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'utils.dart';

class DataSearch extends SearchDelegate<String> {
  Module module = Module();
  List data;
  List names = [];
  List recentNames = [];
  final String url = "http://liveism.xyz/fetch.php";
  DataSearch(this.data) {
    print(names);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        color: Colors.blue,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? data
        : data.where((p) => p['name'].contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            //contentPadding: EdgeInsets.all(2.0),
            onTap: () {
              openUrl(
                  suggestionList[index]['link'], suggestionList[index]['name']);
              // showResults(context);
            },
            onLongPress: () {
              showOptions(suggestionList[index], context);
            },
            leading: CachedNetworkImage(
              imageUrl: suggestionList[index]['image'],
              width: 40.0,
              height: 40.0,
              placeholder: (context, url) => CircularProgressIndicator(
                    strokeWidth: 1.0,
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            title: RichText(
                text: TextSpan(
                    text: suggestionList[index]['name']
                        .substring(
                            0,
                            suggestionList[index]['name']
                                .indexOf(query.toLowerCase()))
                        .toString()
                        .toUpperCase(),
                    style: TextStyle(color: Colors.black),
                    children: [
                  TextSpan(
                      text: suggestionList[index]['name']
                          .substring(
                              suggestionList[index]['name']
                                  .indexOf(query.toLowerCase()),
                              suggestionList[index]['name']
                                      .indexOf(query.toLowerCase()) +
                                  query.length)
                          .toString()
                          .toUpperCase(),
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: suggestionList[index]['name']
                          .substring(suggestionList[index]['name']
                                  .indexOf(query.toLowerCase()) +
                              query.length)
                          .toString()
                          .toUpperCase(),
                      style: TextStyle(color: Colors.black))
                ])),
          ),
      itemCount: suggestionList.length,
    );
  }
}
