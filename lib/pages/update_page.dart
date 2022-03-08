import 'package:flutter/material.dart';
import 'package:patterns_setstate/pages/home_page.dart';

import '../models/post_model.dart';
import '../services/http_service.dart';

class UpdatePage extends StatefulWidget {
  static const String id = "update_page";
  String title, body;
  UpdatePage({Key key, this.title, this.body}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String titleInput, bodyInput;
  var titleController = TextEditingController();
  var bodyController = TextEditingController();
  bool isLoading = false;

  _apiUpdatePost(){
    setState(() {
      isLoading = true;
    });
    Post post = Post(title: titleController.text, body: bodyController.text);
    var response = Network.PUT(Network.API_UPDATE, Network.paramsUpdate(post));

    setState(() {
      if(response != null){
        Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
      }
    });
    isLoading = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleInput = widget.title;
    bodyInput = widget.body;
    titleController.text = titleInput;
    bodyController.text = bodyInput;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(height: 30,),
                Center(
                  child: Text('Title', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(titleInput,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  padding: const EdgeInsets.all(15),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            label: Text("Title"),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: (){
                          setState(() {
                            titleInput = titleController.text;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text('Body', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 5,),
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Text(bodyInput)),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          controller: bodyController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: (){
                          setState(() {
                            bodyInput = bodyController.text;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: TextButton(
                    onPressed: () {
                      _apiUpdatePost();
                    },
                    child: Text("SUBMIT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading ?
          const Center(child: CircularProgressIndicator(),) :
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
