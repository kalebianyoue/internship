import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  final Map<String, dynamic> userData;

  const Account({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Account",
        style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,

        ),
        )
      ),
      body: ListView(
        children: [
         Card(
         color: Colors.white.withOpacity(0.9),
         elevation: 5,
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(15),
         ),
         child: Padding(
             padding: EdgeInsets.all(25.0),
           child: Column(
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Flexible(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("Welcome",
                           style: TextStyle(
                             fontSize: 16,
                             color: Colors.grey[600],
                           ),
                           ),
                           Text(userData['name'] ?? 'Franck',
                           style: TextStyle(
                             fontSize: 22,
                             fontWeight: FontWeight.bold,
                             color: Colors.blue[800],
                           ),
                           )
                         ],
                       ),
                     ),
                     CircleAvatar(
                       radius: 30,
                       backgroundColor: Colors.white,
                       child: Icon(Icons.person,
                       size: 30,
                         color: Colors.white,
                       ),
                     )
                   ],
               )
             ],
           ),
         ),
       ),
          Text("Manage Account",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),

            child: Container(
              decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                   ),
              child: Column(
                children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Personal Information"),
                subtitle: Text("Name"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {

                },
              ),
               Divider(),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text("Language"),
                  subtitle: Text("English"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {

                  },
                ),
                Divider(),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text("Payment Method"),
                    subtitle: Text("MOMO , Orange Money"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {

                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.notification_important_outlined),
                    title: Text("Manage Notifications"),
                    subtitle: Text("Disabled"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {

                    },
                  ),
               ],
              ),
            ),
          ),
          Text("Product",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),

            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text("Invite friends"),
                    subtitle: Text("Earn 5% of the amount spent by your friends for life"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {

                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.crop_square),
                    title: Text("Direct workers"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {

                    },

                  ),

                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
