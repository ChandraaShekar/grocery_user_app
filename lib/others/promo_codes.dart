import 'package:dotted_border/dotted_border.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:user_app/api/orderApi.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/text_widget.dart';

class PromoCodes extends StatefulWidget {
  PromoCodes({Key key}) : super(key: key);

  @override
  _PromoCodesState createState() => _PromoCodesState();
}

class _PromoCodesState extends State<PromoCodes> {
  TextEditingController promoCode = new TextEditingController();
  OrderApiHandler orderHandler = new OrderApiHandler();
  List coupons;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    var resp = await orderHandler.getCoupons();
    setState(() {
      coupons = resp[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: Header.appBar("Promo Codes", null, true),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (text) async{
                    if(promoCode.text.toString()==''){
                       loadData();
                    }else{
                            var resp = await orderHandler.getPromo(promoCode.text.toUpperCase());
                            coupons=null;
                            print(resp);
                            if(resp[0]==204){
                               coupons=[];
                            }else if(resp[0]==200){
                               coupons=resp[1];
                            }

                            setState(() {     
                            });
                    }
                  },
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: "Enter Promo Code",
                      labelStyle: TextStyle(color: Colors.grey[800]),
                      // hintStyle: TextStyle(color: Colors.black),
                      suffix: GestureDetector(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  color: Constants.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () async{
                            print(promoCode.text);
                            var resp = await orderHandler.getPromo(promoCode.text.toUpperCase());
                            coupons=null;
                            print(resp);
                            if(resp[0]==204){
                               coupons=[];
                            }else if(resp[0]==200){
                               coupons=resp[1];
                            }

                            setState(() {     
                            });
                            
                          })),
                  controller: promoCode,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: size.height,
                    child: (coupons == null)
                        ? Center(child: CircularProgressIndicator())
                        : (coupons.length == 0)
                            ? Center(
                                child: TextWidget(
                                "No coupons to show",
                                textType: "para-bold",
                              ))
                            : ListView.builder(
                                itemCount: coupons.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: TextWidget(
                                                    "${coupons[index]['coupon_provider']}",
                                                    textType: "heading"),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: TextWidget(
                                                    "${coupons[index]['coupon_rules']}",
                                                    textType: "subheading"),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                                  child: ExpandableText(
                                                      "${coupons[index]['coupon_description']}",
                                                      maxLines: 1,
                                                      expandText: "show more",
                                                      collapseText:
                                                          "show less")),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  DottedBorder(
                                                    strokeWidth: 1,
                                                    strokeCap: StrokeCap.butt,
                                                    dashPattern: [5, 3],
                                                    borderType:
                                                        BorderType.RRect,
                                                    radius: Radius.circular(6),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    6)),
                                                      ),
                                                      child: TextWidget(
                                                        "${coupons[index]['coupon_id']}",
                                                        textType: "heading",
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    12.0),
                                                        child: Text(
                                                          "APPLY",
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context,
                                                            coupons[index]);
                                                      })
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                                },
                              ),
                  ))
            ],
          ),
        )));
  }
}
