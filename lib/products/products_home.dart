import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/products/category_details.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/product_card.dart';

class ProductsHome extends StatefulWidget {
  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  
  bool down=true;
  List banners=[Constants.offerImage,Constants.offerImage,Constants.offerImage];
  List images=['https://www.thespruceeats.com/thmb/QxqFC_PtR8hR7I9-tsCB3S9b7R8=/2128x1409/filters:fill(auto,1)/GettyImages-116360266-57fa9c005f9b586c357e92cd.jpg','https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg','https://4.imimg.com/data4/CW/MF/MY-35654338/fresh-red-onions-500x500.jpg'];
  int _current=0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

 
  @override
  Widget build(BuildContext context) {

    Size size=MediaQuery.of(context).size;
    
    return Scaffold(
      body: SingleChildScrollView(
              child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(children: [
                  Text(down?'Show Categories':'Show Less',style: TextStyle(fontWeight: FontWeight.w600),),
                  IconButton(
                    icon: Icon(down?AntDesign.caretdown:AntDesign.caretup,size: 14,),
                    onPressed: (){
                      down=!down;setState(() {});
                      print(down);
                      },),
                ],),
                Stack(
                  children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         CarouselSlider(
                           options: CarouselOptions(
                              viewportFraction: 1,
                             autoPlay: false,
                             enableInfiniteScroll: false,
                             autoPlayInterval: Duration(seconds: 3),
                             scrollDirection: Axis.horizontal,
                             //  pauseAutoPlayOnTouch: Duration(seconds: 5),
                             initialPage: 0,
                             height: 120,

                             onPageChanged: (index, reason) {
                               setState(() {
                                 _current = index;
                               });
                             },
                           ),
                           items: banners.map((imgUrl) {
                             return Builder(
                               builder: (BuildContext context) {
                                 return Container(
                                     width: size.width,
                                     child: ClipRRect(
                                           borderRadius: BorderRadius.circular(8.0),
                                           child: Image.asset(
                                             Constants.offerImage,
                                             width: size.width,
                                             height: 100,
                                             fit: BoxFit.cover,
                                           )),
                                     );
                               },
                             );
                           }).toList(),
                         ),
                  Padding(
                    padding: const EdgeInsets.only( top: 5,bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: map<Widget>(banners, (index, url) {
                          return _current == index ?Container(
                            width: 9,
                            height: 9,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constants.buttonBgColor
                                  ),
                          ):Container(
                            width: 9,
                            height: 9,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color:Constants.buttonBgColor)
                                  ),
                          );
                        })),
                  ),
                       Container(
                         width: MediaQuery.of(context).size.width,
                         child: Row(
                           children: [
                             Text('Grocery App Member Deals',style: TextStyle(fontWeight: FontWeight.w600),),
                             Expanded(child:Container()),
                             GestureDetector(
                               child:Text("View all >",style:TextStyle(color: Colors.grey,fontWeight: FontWeight.w600)),
                             )
                           ],
                         ),
                       ),
                       SizedBox(height:10),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (BuildContext context,int index){
                                  return ProductCard(
                                    qty:'100G',
                                    wishList:false,
                                    imgUrl: images[index],
                                    name: 'Ginger',
                                    price: '120',
                                  );
                            }
                          ),
                        ),  
                      SizedBox(height: 20,),
                      Container(
                         width: MediaQuery.of(context).size.width,
                         child: Row(
                           children: [
                             Text('Grocery App Deals',style: TextStyle(fontWeight: FontWeight.w600),),
                             Expanded(child:Container()),
                             GestureDetector(
                               child:Text("View all >",style:TextStyle(color: Colors.grey,fontWeight: FontWeight.w600)),
                             )
                           ],
                         ),
                       ),
                       SizedBox(height:10),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (BuildContext context,int index){
                                  return ProductCard(
                                    qty:'100G',
                                    wishList:true,
                                    imgUrl: images[index],
                                    name: 'Ginger',
                                    price: '120',
                                  );
                            }
                          ),
                        ), 
                   
                      ],
                    )
                   ),
                  //  if(!down)
                  //  Container(height: MediaQuery.of(context).size.height+100,color: Colors.black38),
                   if(!down)
                    Container(
                     height: MediaQuery.of(context).size.height+100,
                     color: Colors.black38,
                      child: Column(
                        children: [
                          Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.count( 
                          padding: EdgeInsets.only(top:10,bottom: 10),
                crossAxisCount: 4,
                shrinkWrap: true,  
                crossAxisSpacing: 4.0,  
                mainAxisSpacing: 8.0,  
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(12, (index) {  
                  return GestureDetector(
                    onTap: (){
                     // Navigator.push(context,MaterialPageRoute(builder:(context)=>CatgoryDetails()));
                    },
                                      child: Container(
                        child: Column(
                          children: [
                            
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Constants.drawerBgColor,
                              child:Icon(Icons.home,color: Constants.drawerIconColor,)
                            ),
                            Text('Grocery')
                          ],
                        ),
                    ),
                  );  
                }  
             )),
                        ),
                        ],
                      ),
                    )
                ],  
             )
              
              
              
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}