import 'dart:convert';
import 'dart:io';

import 'package:comento_work/Detail/postUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void detail(int id) {
  runApp(DetailPage(id));
}

class DetailPage extends StatelessWidget {
  int id;
  DetailPost detailPost;

  DetailPage(int id) {
    this.id = id;
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DetailPost>(
      future: loadData(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          detailPost = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                title: Text("DETAIL PAGE"),
                backgroundColor: Colors.green,
              ),
              body: Container(
                  margin: EdgeInsets.all(10),
                  child:
                  SingleChildScrollView(
                    child:
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('제목 : ${detailPost.title}', style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(margin: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          Text('내용 : ${detailPost.contents}'),
                          Container(margin: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          Text('이메일 : ${detailPost.user.email}'),
                          Container(margin: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          Text('작성일자 : ${detailPost.created_at.year}-${detailPost.created_at.month}-${detailPost.created_at.day} ${detailPost.created_at.hour}:${detailPost.created_at.minute}'),
                          Container(margin: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          Wrap(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index){
                                  Reply reply = detailPost.replyList[index];
                                  return Text("${index}번째 댓글 : ${reply.contents}");
                                },
                                itemCount: detailPost.replyList.length)],
                          )
                        ]
                    ),
                  )
              )
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }


  Future<DetailPost> loadData(int id) async {
    var queryParameters = {
      'id': id.toString()
    };

    var uri = Uri.https('problem.comento.kr', '/api/view', queryParameters);

    var response = await http.get(uri, headers: {
      HttpHeaders.ACCEPT: 'application/json'
    });

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);

      return DetailPost.fromJson(jsonDecode(responseBody)['data']);
    }
  }
}

class DetailPost {
  String title, contents;
  DateTime created_at;
  PostUser user;
  List<Reply> replyList;

  DetailPost(this.title, this.created_at, this.contents, this.user, this.replyList);

  factory DetailPost.fromJson(dynamic json) {
    return DetailPost(json['title'] as String, DateTime.parse(json['created_at'] as String), json['contents'] as String, PostUser.fromJson(json['user']),  (json['reply'] as List).map((replyJson) => Reply.fromJson(replyJson)).toList());
  }
}

class Reply {
  String contents;
  DateTime created_at;
  PostUser user;

  Reply(this.contents, this.created_at, this.user);

  factory Reply.fromJson(dynamic json) {
    return Reply(json['contents'] as String, DateTime.parse(json['created_at'] as String), PostUser.fromJson(json['user']));
  }
}