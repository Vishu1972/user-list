import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  List userList = [];
  int selectedIndex = 0;

  @override
  void initState(){
    super.initState();
    getUserList(1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F6F4),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        elevation: 0.0,
        title: Text('User List'),
        leading: const Icon(
          Icons.arrow_back,
          size: 28,
          color: Colors.white,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                userList.length > 0
                    ? ListView.builder(
                    itemCount: userList == null ? 0 : userList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return(
                          Container(
                            margin: EdgeInsets.only(left: 10,right: 10,bottom: 8),
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(70.0),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    child: Image.network(
                                      '${userList[index]['avatar']}',
                                      fit: BoxFit.cover,
                                      height: 60.0,
                                      width: 60.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 16),
                                        child: Text(
                                          "${userList[index]["first_name"]} ${userList[index]["last_name"]}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF404E63),
                                          ),
                                        ) ,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 16),
                                        child: Text(
                                          "${userList[index]["email"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF404E63).withOpacity(0.6)
                                          ),
                                        ) ,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      );
                    }
                )
                    : Container(
                  margin: EdgeInsets.only(top: 150),
                  child: Center(
                    child: Text(
                        'No user list found.'
                    ),
                  ),
                ),
              ],

            ),
          ),

          Visibility(
            visible: _loading,
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  color: Colors.white,
                  value: 0.0,
                  strokeWidth: 5.0,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 16,
            right:16,
            child: Container(
              height: 65,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.blue.shade100
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Pages:',
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8, top: 10, bottom: 10),
                      child: ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              setState(() {
                                _loading = true;
                                selectedIndex = index;
                              });
                              getUserList(index+1);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 1),
                              color: selectedIndex == index ? Colors.white : Colors.transparent,
                              padding: EdgeInsets.only(left: 14, right: 14, top: 16, bottom: 16),
                              child: Text(
                                  '${index+1}'
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getUserList(pageNo) async {
    final String url = "https://reqres.in/api/users?page=$pageNo";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if(result != null){
        setState(() {
          _loading = false;
          userList = result['data'];
        });
      }
    }
  }
}

