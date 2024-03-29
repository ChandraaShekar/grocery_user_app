import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/api/packsApi.dart';
import 'package:user_app/main.dart';
import 'package:user_app/others/pack_desc.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/text_widget.dart';

class ExplorePacks extends StatefulWidget {
  @override
  _ExplorePacksState createState() => _ExplorePacksState();
}

class _ExplorePacksState extends State<ExplorePacks> {
  List packs;
  PacksApiHandler packsHandler = new PacksApiHandler();

  @override
  void initState() {
    load();
    super.initState();
  }

  load() async {
    List packResp =
        await packsHandler.getPacks({"lat": MyApp.lat, "lng": MyApp.lng});
    print(packResp);
    setState(() {
      packs = packResp[1];
      log(packs.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: Header.appBar(Constants.explorePacksTag, null, true, context, true),
      body: packs == null
          ? Center(child: CircularProgressIndicator())
          : packs.length == 0
              ? Center(child: Text("No Packs to Show"))
              : ListView.builder(
                  itemCount: packs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PackageDescription(
                                          packName: packs[index]['pack_name'],
                                          packId:
                                              "${packs[index]['pack_id']}")));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: packs[index]['pack_banner']
                                    .toString()
                                    .replaceAll('http://', 'https://'),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: size.width,
                                  height: size.height / 4.5,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.white,
                                  child: Container(
                                    width: size.width,
                                    height: size.height / 4,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          TextWidget("${packs[index]['pack_name']}",
                              textType: "title"),
                          Divider()
                        ],
                      ),
                    );
                  }),
    );
  }
}
