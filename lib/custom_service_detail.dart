import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CustomServicePage()));
}
class CustomServicePage extends StatefulWidget{
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Custom Service Button",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )
          )
      ),
      body: Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
            child: Text("Request a Job",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: (){
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => CustomServiceDetail(),
              );
            }
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
class CustomServiceDetail extends StatefulWidget {
  @override
  _CustomServiceDetailState createState() => _CustomServiceDetailState();
}

class _CustomServiceDetailState extends State<CustomServiceDetail> {
  final _formkey = GlobalKey<FormState>();
  String? workType, duration, day, location, description;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Job Request Form",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: "Type of Work"),
                onSaved: (val) => workType = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Duration"),
                onSaved: (val) => duration = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Day"),
                onSaved: (val) => day = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Location"),
                onSaved: (val) => location = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Job Description"),
                maxLines: 3,
                onSaved: (val) => description = val,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Submit"),
                onPressed: () {
                  _formkey.currentState?.save();
                  Navigator.pop(context); // Close sheet
                  print("Job Type: $workType");
                  print("Duration: $duration");
                  print("Day: $day");
                  print("Location: $location");
                  print("Description: $description");
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

  }
}
