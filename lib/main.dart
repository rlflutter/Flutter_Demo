import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// =>是dart语言单行函数或方法的简写
//void main() => runApp(new MyApp());
void main() => runApp(new MyWidget());

// 1 继承了 StatelessWidget，这将会使应用本身也成为一个widget
// 2 Stateless widgets 是不可变的, 这意味着它们的属性不能改变 - 所有的值都是最终的.
// 3 Stateful widgets 持有的状态可能在widget生命周期中发生变化, 实现一个 stateful widget 至少需要两个类
//   <1> 一个 StatefulWidget类。  <2> 一个 State类。
//       StatefulWidget类本身是不变的，但是 State类在widget生命周期中始终存在
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    var wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Startup Name Generator',
      //Scaffold 是 Material library 中提供的一个widget,
      // 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性.
      // widget的主要工作是提供一个build()方法来描述如何根据其他较低级别的widget来显示自己
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Welcome to Flutter'),
//        ),
//        // body的widget树中包含了一个Center widget, Center widget又包含一个 Text 子widget
//        body: new Center(
////          child: new Text('Hello World'),
////          child: new Text(wordPair.asPascalCase),
//          child: new RandomWords(),
//        ),
//      ),
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
    );
  }
}

/**
 * 添加一个类继承 一个 StatefulWidget类
 */
class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RandomWordsState();
  }
}

/**
 * 添加一个类继承State类
 */
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    var wordPair = new WordPair.random();
//    return new Text(wordPair.asPascalCase);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        itemBuilder: (context, i) {
          final index = i ~/ 2;
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider();
          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        // 在Flutter的响应式风格的框架中，调用setState() 会为State对象触发build()方法，从而导致对UI的更新
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    //新页面的内容在在MaterialPageRoute的builder属性中构建，builder是一个匿名函数。
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map(
        (pair) {
          return new ListTile(
            title: new Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );

      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions'),
        ),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }
}

/**
 * widget 项目demo
 */
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 标题行
    Widget titleSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // 第一行文字放到Container中
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    'Oeschinen Lake Campground',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // 第二行文字
                new Text(
                  'Kandersteg, Switzerland',
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
//          new Icon(
//            Icons.star,
//            color: Colors.red[500],
//          ),
//          new Text('41'),
          new FavoriteWidget(),
        ],
      ),
    );

    Column buildButtonColumn(IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;
      return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            icon,
            color: color,
          ),
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    ;

    /**
     *
     */
    Widget buttonSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.call, 'CALL'),
          buildButtonColumn(Icons.near_me, 'ROUTE'),
          buildButtonColumn(Icons.share, 'SHARE'),
        ],
      ),
    );

    Widget textSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '''
Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
        ''',
        softWrap: true,
      ),
    );

    // TODO: implement build
    return new MaterialApp(
      home: new Scaffold(
        body: new ListView(
          children: [
//            new Image.asset(
//              'images/background.jpg',
//              width: 600.0,
//              height: 240.0,
//              fit: BoxFit.cover,
//            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _FavoriteWidgetState();
  }

}

class _FavoriteWidgetState extends State<FavoriteWidget>{

  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite (){
    setState(() {
      if(_isFavorited){
        _favoriteCount -= 1;
        _isFavorited = false;
      }else{
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(0.0),
          child: new IconButton(
              icon: _isFavorited ? new Icon(Icons.star) : new Icon(Icons.star_border),
              color: Colors.red[500],
              onPressed: _toggleFavorite),
        ),
        new SizedBox(
            width: 18.0,
            child: new Container(
              child: new Text(
                  '$_favoriteCount'
              ),
            ),
        ),
      ],
    );
  }

}
