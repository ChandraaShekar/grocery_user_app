import 'package:flutter/material.dart';
import 'package:user_app/others/pack_desc.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';

class ExplorePacks extends StatefulWidget {
  @override
  _ExplorePacksState createState() => _ExplorePacksState();
}

class _ExplorePacksState extends State<ExplorePacks> {
  @override
  Widget build(BuildContext context) {

    Size size=MediaQuery.of(context).size;
    
    return Scaffold(
      appBar:Header.appBar(Constants.explorePacksTag, null, true),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PackageDescription("15 Days Pack")));
                },
                child: ClipRRect(
                 borderRadius: BorderRadius.circular(8.0),
                 child: Image.asset(
                           Constants.offerImage,
                           width: size.width,
                           height: 100,
                           fit: BoxFit.cover,
                       )),
            ),
          );
        }
      ),
    );
  }
}