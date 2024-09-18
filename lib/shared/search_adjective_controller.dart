import 'package:flutter/material.dart';
import 'package:menschen/models/adjective_mode.dart';
import 'package:menschen/screens/shared/adjective_card.dart';
import 'package:menschen/shared/dimensions.dart';

class DataSearchToAdjective extends SearchDelegate {
  final List<Adjective> adjectivesList;
  List<Adjective> suggestionList = [];

  DataSearchToAdjective(this.adjectivesList);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some result based on the selection
    return Container(
      padding: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return AdjectiveCard(adjective: suggestionList[index]);
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when someone searches for something
    suggestionList = query.isEmpty
        ? adjectivesList
        : adjectivesList
            .where((adjective) =>
                adjective.adjective
                    .toLowerCase()
                    .trim()
                    .contains(query.toLowerCase().trim()) ||
                adjective.opposite!
                    .toLowerCase()
                    .trim()
                    .contains(query.toLowerCase().trim()) ||
                adjective.adjTranslation
                    .toLowerCase()
                    .trim()
                    .contains(query.toLowerCase().trim()) ||
                adjective.oppTranslation!
                    .toLowerCase()
                    .trim()
                    .contains(query.toLowerCase().trim()))
            .toList();

    return Container(
      padding: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return AdjectiveCard(adjective: suggestionList[index]);
        },
      ),
    );
  }
}
