import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';

class OrderHistoryCard extends StatelessWidget {
  
  final String orderNumber;
  final String price;
  final String type;

  OrderHistoryCard({this.orderNumber,this.price,this.type});
  
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               
               Text(this.orderNumber,style: TextStyle(fontWeight: FontWeight.w600),),
               SizedBox(height:8),
               Text(this.price,style: TextStyle(fontWeight: FontWeight.w600,color: Constants.kMain2),),
               SizedBox(height:20),
               dispType()
            ],
          ),
        ),
      ),
    );
  }

  Widget dispType(){
    
    if(type=='Delivered'){
     return Container(
       color: Constants.deliveredBgColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(type,style: TextStyle(color: Colors.white),),
        ),
       );
    }else{
     return Container(
       color: Constants.transitBgColor,
       child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(type,style: TextStyle(color: Colors.white),),
      ),
     );
    }
    
  }

}