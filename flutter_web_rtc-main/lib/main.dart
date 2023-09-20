import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_rtc/signaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Flutter Explained - WebRTC"),
      ),
      body: Column(
        children: [
           Expanded(
             child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child:  Container(
                      color: Colors.amberAccent,
                      height:   h,
                      width: w,
                      child: RTCVideoView(_remoteRenderer)),  ),
                Positioned(
                  top: 5,
                  right: 0,
                  left: 0,
                  child:  Container(
                    color: Colors.grey,
                    height: 40,
                    child: ListView(
                    scrollDirection: Axis.horizontal,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            signaling.openUserMedia(_localRenderer, _remoteRenderer);
                          },
                          child: Text("Open camera & microphone"),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            roomId = await signaling.createRoom(_remoteRenderer);
                            textEditingController.text = roomId!;
                            setState(() {});
                          },
                          child: Text("Create room"),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add roomId
                            signaling.joinRoom(
                              textEditingController.text,
                              _remoteRenderer,
                            );
                          },
                          child: Text("Join room"),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            signaling.hangUp(_localRenderer);
                          },
                          child: Text("Hangup"),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                      height: 200,
                      width: 200,
                      child: RTCVideoView(
                        _localRenderer,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
