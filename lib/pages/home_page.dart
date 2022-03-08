import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:patterns_setstate/pages/create_page.dart';
import 'package:patterns_setstate/pages/update_page.dart';

import '../models/post_model.dart';
import '../services/http_service.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];

  void _apiPostList() async{
    isLoading = true;
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    setState(() {
      if(response != null){
        items = Network.parsePostList(response);
      }else{
        items = [];
      }
      isLoading = false;
    });

  }

  void _apiPostDelete(Post post) async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.DEL(Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    setState(() {
      if(response != null){
        _apiPostList();
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: (){
          Navigator.pushNamed(context, CreatePage.id);
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index){
              return itemOfPost(items[index]);
            },),
          isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget itemOfPost(Post post){
    return Slidable(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title.toUpperCase(),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5,),
            Text(post.body),
          ],
        ),
      ),
      startActionPane: ActionPane(
        extentRatio: 0.25,
        children: [
          Flexible(
            child: Container(
              color: Colors.indigo,
              child: IconButton(
                icon: Icon(Icons.edit, semanticLabel: 'Update',),
                color: Colors.white,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(title: post.title, body: post.body,)));
                },
              ),
            ),
          ),
        ],
        motion: DrawerMotion(),
      ),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        children: [
          Flexible(
            child: Container(
              color: Colors.red,
              child: IconButton(
                icon: Icon(Icons.delete, semanticLabel: 'Delete',),
                color: Colors.white,
                onPressed: (){
                  _apiPostDelete(post);
                },
              ),
            ),
          ),
        ],
        motion: DrawerMotion(),
      ),
    );
  }
}