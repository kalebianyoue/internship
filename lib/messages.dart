import 'package:flutter/material.dart';
void main() => runApp(Messages());

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MessagesScreen()
    );
  }
}
class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreen createState() => _MessagesScreen();
}
class _MessagesScreen extends State<MessagesScreen>{
  bool isOngoingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages",
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
                ? buildOngoingContent()
                : buildCompleteContent(),
          ),
        ],
      ),
    );
  }
}
Widget buildOngoingContent() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.message_sharp, size: 80, color: Colors.grey),
        SizedBox(height: 20),
        Text("No Discussion",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        Text("You have not book a jobber yet",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(onPressed: (){},
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
Widget buildCompleteContent() {
  return Center(
    child: Text("No Completed request yet."),
  );
}