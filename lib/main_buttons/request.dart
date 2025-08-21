import 'package:flutter/material.dart';
import 'package:untitled/service_request.dart';
import 'package:untitled/services_detail.dart';

import 'chat_list.dart';

 void main() => runApp(Request());

class Request extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: RequestScreen()
    );
  }
}
class RequestScreen extends StatefulWidget {
  @override
  _RequestScreen createState() => _RequestScreen();
}
class _RequestScreen extends State<RequestScreen>{
  bool isOngoingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Requests",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isOngoingSelected = true),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: isOngoingSelected ? Colors.white :Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text("Ongoing",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isOngoingSelected ? Colors.black : Colors.grey,
                            ),
                            ),
                          ),
                        ),
                      )
                    ),
                Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isOngoingSelected = true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isOngoingSelected ? Colors.white :Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("Completed",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isOngoingSelected ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
          Expanded(
              child: isOngoingSelected
                ? buildOngoingContent(context)
                  : buildCompleteContent(),
          ),
        ],
      ),
    );
  }

  buildCompleteContent() {}
}
Widget buildOngoingContent(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
        SizedBox(height: 20),
        Text("No Request",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        ),
        SizedBox(height: 8),
        Text("Request a service and find a provider in just few minutes",
          style: TextStyle(
              color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(onPressed: (){
          Navigator.push(
           context,
            MaterialPageRoute(builder: (context) => ServiceRequest(),
            ),
          );
        },
            child: Text("Request a service",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            ),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        )
      ],
    ),
  );
}

