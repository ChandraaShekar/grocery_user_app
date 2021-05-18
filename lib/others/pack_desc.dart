import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/pack_desc_card.dart';

class PackageDescription extends StatefulWidget {
  
 final String packName;
 
 PackageDescription(this.packName);

  @override
  _PackageDescriptionState createState() => _PackageDescriptionState();
}

class _PackageDescriptionState extends State<PackageDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        
                                 decoration: BoxDecoration(
        color: Color(0xffFFD2CC),
        borderRadius: BorderRadius.only(
           topRight: Radius.circular(40),
           topLeft: Radius.circular(40),
        ),
        ),
                             
                              height: 130,
                              width: MediaQuery.of(context).size.width,
                               child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                                   child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                      Text('Pack Price'),
                                      Text(Constants.rupeeSymbol+' 309')
                                     ],
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                                   child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                      Text('Shipping Cost (3,4 Km)'),
                                      Text(Constants.rupeeSymbol+' 30')
                                     ],
                                   ),
                                 ),
                                Divider(),
                                Padding(
                                   padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                   child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                      Text('Total Price'),
                                      Text(Constants.rupeeSymbol+' 339')
                                     ],
                                   ),
                                 ),

                                            ]
                                       ),
                             ),
      appBar: Header.appBar(widget.packName, null, true),
      body: SingleChildScrollView(
              child: Container(
          child:Column(
            children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Ionicons.md_paper,color: Constants.packDescIconColor,),
                    SizedBox(width: 3,),
                    Text('Here’s what you get in the '+widget.packName.toLowerCase()+"!",style: TextStyle(color: Constants.packDescHeadingColor),)
                  ],
                ),
                ListView.builder(
                  itemCount: 10,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return PackDescCard(
                      imgUrl: 'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
                      onPressed: (){
                          _displayTextInputDialog(context);
                      },
                      name: 'Ginger',
                      qty: '1 KG',
                    );
                 }),
                 SizedBox(height: 140,),
            ]
          )
        ),
      ),
      
      );
  }
  TextEditingController _textFieldController = TextEditingController();

Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter the quantity'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "enter value in grams",hintStyle: TextStyle(color: Colors.grey)),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                print(_textFieldController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    }
}