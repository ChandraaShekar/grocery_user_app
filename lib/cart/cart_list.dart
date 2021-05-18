import 'package:flutter/material.dart';
import 'package:user_app/cart/checkout_address.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/primary_button.dart';
import 'package:user_app/widgets/cart_card.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  
  String subtotal='3940';
  String delivery='89';
  String tax='50';
  String total='4200';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           ListView.builder(
             shrinkWrap: true,
             itemCount: 3,
             physics: NeverScrollableScrollPhysics(),
             itemBuilder: (BuildContext context,int index){
                return CartCard(
                  name:'Nestle',
                  imgUrl: 'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
                  price: '200',
                  qty: '1 KG',
                );
            }
           ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: 30,),
                 Container(
                   width: MediaQuery.of(context).size.width,
                   child: Row(
                     children:[
                       Text('Sub Total',style: TextStyle(fontSize: 18),),
                       SizedBox(width: 15,),
                       Expanded(
                         child: Text('---------------------',style: TextStyle(color: Colors.grey),)),
                       SizedBox(width: 15,),
                       Text('₹ '+subtotal,style: TextStyle(fontSize: 18),)
                     ]
                   ),
                 ),
                 SizedBox(height: 8,),
                 Container(
                   width: MediaQuery.of(context).size.width,
                   child: Row(
                     children:[
                       Text('Delivery',style: TextStyle(fontSize: 18),),
                       SizedBox(width: 25,),
                       Expanded(
                         child: Text('---------------------',style: TextStyle(color: Colors.grey),)),
                       SizedBox(width: 15,),
                       Text('₹ '+delivery,style: TextStyle(fontSize: 18),)
                     ]
                   ),
                 ),
                  SizedBox(height: 8,),
                 Container(
                   width: MediaQuery.of(context).size.width,
                   child: Row(
                     children:[
                       Text('Tax',style: TextStyle(fontSize: 18),),
                       SizedBox(width: 70,),
                       Expanded(
                         child: Text('--------------------',style: TextStyle(color: Colors.grey),)),
                       SizedBox(width: 15,),
                       Text('₹ '+tax,style: TextStyle(fontSize: 18),)
                     ]
                   ),
                 ),
                 Divider(),
                 SizedBox(height: 8,),
                 Container(
                   width: MediaQuery.of(context).size.width,
                   child: Row(
                     children:[
                       Text('Total',style: TextStyle(fontSize: 18),),
                       
                       Expanded(
                         child: Container()
                         ),
                       
                       Text('₹ '+total,style: TextStyle(fontSize: 18),)
                     ]
                   ),
                 ),
             ],
            ),
          ),
          SizedBox(height: 30,),
          PrimaryButton(
            text:'CHECKOUT',
            textColor: Colors.white,
            backgroundColor:Constants.buttonBgColor,
            width:MediaQuery.of(context).size.width*0.65,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckoutAddress()));
            },
          ),
          SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}