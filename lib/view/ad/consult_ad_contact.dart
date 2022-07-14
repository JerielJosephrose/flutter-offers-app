import 'package:flutter/material.dart';






class AdContact extends StatefulWidget {
  final String contact;

  AdContact({Key key, @required this.contact}) : super(key: key);

  @override
  AdContactState createState() => AdContactState(contact: contact);
}

class AdContactState extends State<AdContact> {
  final String contact;

  AdContactState({Key key, @required this.contact});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0b4e94),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Contact de l'annonce",
        ),
        elevation: 0.0,
      ),
      body: Container(
          child: Text(
        'Contact \n' + contact,
        style: TextStyle(
            color: Colors.black87.withOpacity(0.8),
            fontSize: 15,
            fontWeight: FontWeight.w600),
      )),
    );
  }
}
