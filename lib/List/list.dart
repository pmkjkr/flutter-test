import 'dart:convert';
import 'dart:io';

import 'package:comento_work/Detail/detail.dart';
import 'package:comento_work/List/ad.dart';
import 'package:comento_work/List/category.dart';
import 'package:comento_work/List/post.dart';
import 'package:comento_work/Util/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void list(){
  runApp(new ListPage());
}


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  Future<List<Category>> categoryFuture;

  Set<Category> selectedCategories = Set();
  int currentPage = 0;
  bool hasNextPost = true;

  List<Post> postList = [];
  List<Ad> adList = [];

  ScrollController sc;

  @override
  void initState() {
    categoryFuture = fetchCategory();
    sc = ScrollController();
    sc.addListener((){
      if (sc.offset >= sc.position.maxScrollExtent && !sc.position.outOfRange) {
        loadList(currentPage);
      }
    });
  }

  Future<List<Category>> fetchCategory() async {
    final response = await http.get('https://problem.comento.kr/api/category');

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var categoryJson = jsonDecode(responseBody)['category'] as List;
      return categoryJson.map((tagJson) => Category.fromJson(tagJson)).toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LIST PAGE"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          controller: sc,
          child: Container(
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(UserData().id + "님 안녕하세요!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 50,
                  color: Colors.black26,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<List<Category>>(
                        future: categoryFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index){
                                  Category category = snapshot.data[index];
                                  return CupertinoButton(child: Text("${category.name},:${category.activated}"), onPressed: (){
                                    if(category.activated){
                                      selectedCategories.remove(category);
                                    } else {
                                      selectedCategories.add(category);
                                    }
                                    setState(() {
                                      category.activated = !category.activated;
                                    });
                                    loadList(1);
                                  });
                                }, itemCount: snapshot.data.length);
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      )
                    ],
                  ),
                ),
                NotificationListener(
                  child: ListView.builder(
                    shrinkWrap: true,
                    // controller: sc,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      if(index % 5 == 4){ // ad
                        Ad ad = adList[(index / 5).floor()];
                        return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(border: Border.all(width: 1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text('Sponsored')
                              ),
                              Row(
                                children: [
                                  Expanded(child: Image.network('https://cdn.comento.kr/assignment/'+ad.img, width: 150, height: 120, fit: BoxFit.fill)),
                                  Expanded(flex:2, child:
                                  Column(
                                      children: [
                                        Text(ad.title, maxLines: 2, style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                        Text(ad.contents, maxLines: 3, overflow: TextOverflow.ellipsis)
                                      ]
                                    )
                                  )
                                ],
                              )
                            ]
                          )
                        );
                      } else { // post
                        Post post = postList[(index > 4 ? index - (index / 5).floor() : index)];
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailPage(post.id)));
                          },
                          child:
                            Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(border: Border.all(width: 1)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
                                      child:
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(getCategoryName(post.category_id), overflow: TextOverflow.ellipsis),
                                          Text("${post.id}")
                                        ],
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(10),
                                        child:
                                        Column(
                                            children: [
                                              Row(mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('EMAIL'),
                                                    Container(margin: EdgeInsets.symmetric(horizontal: 10),height: 15, child: VerticalDivider(color: Colors.black)),
                                                    Text('${post.created_at.year}-${post.created_at.month}-${post.created_at.day} ${post.created_at.hour}:${post.created_at.minute}')
                                                  ]
                                              ),
                                              Text(post.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                                              Text(post.contents, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left)
                                            ],
                                            crossAxisAlignment: CrossAxisAlignment.start
                                        )
                                    ),
                                  ],
                                )
                            )
                        );
                      }
                    }, itemCount: postList.length + adList.length),
                  onNotification: (notificationInfo){
                    if (notificationInfo is ScrollEndNotification && hasNextPost && postList.length > 9) {
                      loadList(currentPage);
                    }
                    return true;
                  },)
              ],
            ),
          ),
        )
    );
  }


  Future<List<Post>> loadList(int page) async {
    if(hasNextPost || page == 1){
      if(selectedCategories.length == 0){
        setState(() {
          postList = [];
          adList = [];
        });
      } else {
        if(page == 1){
          currentPage = page;
        }

        var queryParameters = {
          'page': page.toString(),
          'ord': 'desc',
          'limit' : "10"
        };

        List<Category> categoriesList = selectedCategories.toList();
        for(int i = 0; i < categoriesList.length; i++){
          queryParameters['category[${i}]'] = categoriesList[i].id.toString();
        }

        var uri = Uri.https('problem.comento.kr', '/api/list', queryParameters);

        var response = await http.get(uri, headers: {
          HttpHeaders.ACCEPT: 'application/json'
        });

        if (response.statusCode == 200) {
          var responseBody = utf8.decode(response.bodyBytes);

          var postJson = jsonDecode(responseBody)['data'] as List;
          List<Post> getPostList = postJson.map((pJson) => Post.fromJson(pJson)).toList();
          if(getPostList.length > 0){

            int total = jsonDecode(responseBody)['total'] as int;
            hasNextPost = currentPage * 10 < total;

            int callAdLimit = ((postList.length == 0 ? getPostList.length : (postList.length + getPostList.length)) / 4).floor() - adList.length;

            var queryParametersAd = {
              'page': currentPage.toString(),
              'limit' : callAdLimit.toString()
            };
            var adUri = Uri.https('problem.comento.kr', '/api/ads', queryParametersAd);

            var adResponse = await http.get(adUri, headers: {
              HttpHeaders.ACCEPT: 'application/json'
            });

            List<Ad> getAdList = [];
            if(adResponse.statusCode == 200){
              var adResponseBody = utf8.decode(adResponse.bodyBytes);

              var adJson = jsonDecode(adResponseBody)['data'] as List;
              getAdList = adJson.map((aJson) => Ad.fromJson(aJson)).toList();
            }

            currentPage++;

            if(page == 1){
              postList = [];
              adList = [];
            }

            setState(() {
              postList.addAll(getPostList);
              adList.addAll(getAdList);
            });
          } else {
            hasNextPost = false;
          }
        } else {
          throw Exception('Failed to load post');
        }
      }
    }
  }


  String getCategoryName(int categoryId){
    String categoryName = "";
    for(Category c in selectedCategories){
      if(categoryId == c.id){
        categoryName = c.name;
        break;
      }
    }
    return categoryName;
  }
}