import 'package:flutter/material.dart';
import 'package:intelligent_ordering_system/pages/capture_page.dart';
import 'package:intelligent_ordering_system/pages/image_capture_page.dart';

class AICompanionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                color: Colors.blue[900],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "A.I. Companion",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        """
 A.I. will help you to order according to your emotion.
 
Please select Start and act naturally while A.I. read you emotion.
              """,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Start",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ImageCapturePage();
                            },
                          ),
                        );
                      }),
                  SizedBox(
                    height: 12.0,
                  ),
                  OutlineButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Back to Main",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
