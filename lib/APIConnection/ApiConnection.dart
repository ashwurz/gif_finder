import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiConnection{
  String _urlTopTrendings = "https://api.giphy.com/v1/gifs/trending?api_key=tECttXGsMUUWLberQO6okKw8jglO9TQk&limit=20&rating=G";
  String searchString;
  int offset = 0;

  Future<Map> getGifs() async{
    http.Response response;

    if(searchString == null || searchString.isEmpty){
      response = await http.get(_urlTopTrendings);
    }else{
      response = await http.get(_getSearchString(searchString, offset));
    }
    return json.decode(response.body);
  }

  String _getSearchString(String searchString, int offset){
    return "https://api.giphy.com/v1/gifs/search?api_key=tECttXGsMUUWLberQO6okKw8jglO9TQk&q=$searchString&limit=19&offset=$offset&rating=G&lang=en";
  }
}