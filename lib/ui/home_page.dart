import 'package:buscador_gif/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:buscador_gif/APIConnection/ApiConnection.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiConnection connection = ApiConnection();

  int _getCount(List data) {
    if (connection.searchString == null || connection.searchString.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  void connectionRetry() {
    setState(() {
      build(context);
    });
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (connection.searchString == null ||
            index < snapshot.data["data"].length ||
            connection.searchString.isEmpty) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              height: 300.0,
              image: snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"],
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Carregar Mais",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  connection.offset += 19;
                });
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  connection.searchString = text;
                  connection.offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: connection.getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 150.0,
                            ),
                            Text(
                              "Algo de errado aconteceu...",
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Container(
                                height: 50.0,
                                child: RaisedButton(
                                  child: Text(
                                    "Tentar Reconexão",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  color: Colors.white,
                                  onPressed: connectionRetry,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
