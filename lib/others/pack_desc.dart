import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/api/packsApi.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/pack_desc_card.dart';

class PackageDescription extends StatefulWidget {
  final String packId, packName;

  PackageDescription({this.packId, this.packName});

  @override
  _PackageDescriptionState createState() => _PackageDescriptionState();
}

class _PackageDescriptionState extends State<PackageDescription> {
  PacksApiHandler packsHandler = new PacksApiHandler();
  Map packInfo;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    List resp = await packsHandler.getPackInfo(widget.packId);

    print(resp);
    setState(() {
      packInfo = resp[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Color(0xffFFD2CC),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        height: size.height / 4.55,
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
                    Text(
                      Constants.rupeeSymbol + ' 309',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.height / 60),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping Cost (3,4 Km)'),
                    Text(
                      Constants.rupeeSymbol + ' 30',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.height / 60),
                    )
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
                    Text(
                      Constants.rupeeSymbol + ' 339',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.height / 55),
                    )
                  ],
                ),
              ),
            ]),
      ),
      appBar:
          Header.appBar(packInfo == null ? '' : widget.packName, null, true),
      body: SingleChildScrollView(
        child: Container(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Ionicons.md_paper,
                color: Constants.packDescIconColor,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                'Here’s what you get in the ' +
                    widget.packName.toLowerCase() +
                    "!",
                style: TextStyle(color: Constants.packDescHeadingColor),
              )
            ],
          ),
          (packInfo == null)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: 10,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return PackDescCard(
                      imgUrl:
                          'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
                      onPressed: () {
                        _displayTextInputDialog(context);
                      },
                      name: 'Ginger',
                      qty: '1 KG',
                    );
                  }),
          SizedBox(
            height: 140,
          ),
        ])),
      ),
    );
  }

  TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter the quantity',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
                hintText: "enter value in grams",
                hintStyle: TextStyle(color: Colors.grey)),
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
