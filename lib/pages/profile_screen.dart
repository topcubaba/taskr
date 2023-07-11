import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//TODO1 will be designed

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 42,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'mtopcu',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black),
              ),
              Row(children: const [
                Icon(Icons.add_box_outlined),
                Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                ),
              ])
            ],
          ),
        ),
        body: Container(),
      ),
    );
  }
}
