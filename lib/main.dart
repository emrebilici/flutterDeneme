// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        home: Center(
          child: RandomWords(),
        ),
      );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getLast()),
        actions: [
          IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list))
        ],
      ),
      body: _buildSuggestions(),

    );
  }

  Widget _buildSuggestions() {

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 20,
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          _suggestions.addAll(generateWordPairs().take(10)); /*4*/

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: getIcon(alreadySaved),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          }
          else {
            _saved.add(pair);
          }
        });
      },
      );
  }

  Icon getIcon(bool alreadySaved){
    Icon returnIcon = Icon(Icons.favorite_border, color: null, semanticLabel: "Save");
    if(alreadySaved) {
      return Icon(
        Icons.favorite,
        color: Colors.red,
        semanticLabel: "Remove from saved",
      );
    }
    return returnIcon;
  }

  String getLast(){
    if(_saved.isNotEmpty){
      return _saved.last.asString;
    }
    else {
     return "DENEME YAPIYOZ";
    }
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList() : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: tiles.toList()),
          );
        },
      ),
    );
  }
}


