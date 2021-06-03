import 'package:flutter/material.dart';
import 'package:user_app/utils/header.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:user_app/widgets/primaryButton.dart';

class SocketTest extends StatefulWidget {
  SocketTest({Key key}) : super(key: key);

  @override
  _SocketTestState createState() => _SocketTestState();
}

class _SocketTestState extends State<SocketTest> {
  IO.Socket socket;
  @override
  void initState() {
    socketIOHandler();
    super.initState();
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  socketIOHandler() {
    socket = IO.io('https://socket.8bitchaps.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    print(socket.connected);
    socket.connect();
    socket.onConnect((data) => {print("CONNECTED")});
    socket.onConnectError((data) => print("STATUS: $data"));
    socket.on('message', (data) {
      print(data);
    });
  }

  void load() async {
    socket = IO.io('https://socket.8bitchaps.com');
    socket.onConnect((_) {
      print('connect');
      socket.emit('message', 'test');
    });
    socket.on('messsgae', (data) => print("NEW MESSAGE: $data"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.appBar("Socket Test", null, true),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              children: [
                Center(child: Text("Hello")),
                PrimaryCustomButton(
                    title: "Place Order",
                    onPressed: () {
                      socket
                          .emit("new-order", {"orderId": "w098urjf98weu4r8t"});
                    })
              ],
            ),
          )),
    );
  }
}
