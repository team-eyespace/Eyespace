import 'package:flutter/material.dart';
import 'package:eyespace/main.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:speech_recognition/speech_recognition.dart';

class ChatMessages extends StatefulWidget {
  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages>
    with TickerProviderStateMixin {
  List<ChatMessage> _messages = List<ChatMessage>();
  var _speech = SpeechRecognition();
  bool authorized = false;
  bool isListening = false;
  TextEditingController _controllerText = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _activateRecognition();
  }

  @override
  void dispose() {
    super.dispose();
    if (isListening) _cancelRecognitionHandler();
  }

  Future _activateRecognition() async {
    final res = await _speech.activate();
    setState(() => authorized = res);
  }

  Future _cancelRecognitionHandler() async {
    final res = await _speech.cancel();
    if (_controllerText.text != "") {
      _handleSubmit(_controllerText.text, raid.data['displayName'] ?? "",
          raid.data['uid'] ?? "");
    }
    _controllerText.text = "";
    setState(() {
      isListening = res;
    });
  }

  Future _cancelRecognition() async {
    final res = await _speech.cancel();
    _controllerText.text = "";
    setState(() {
      isListening = res;
    });
  }

  Future _stopRecognition() async {
    final res = await _speech.cancel();
    setState(() {
      isListening = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Column(
      children: <Widget>[
        _buildList(),
        isListening || _controllerText.text != ""
            ? _buildComposer(width: size.width - 20.0)
            : _buildNothing(),
        !isListening
            ? _buildIconButton(authorized ? Icons.mic : Icons.mic_off,
                authorized ? _startRecognition : null,
                backgroundColor: Colors.blue, color: Colors.blue, fab: false)
            : _buildIconButton(
                Icons.mic_off, isListening ? _cancelRecognitionHandler : null,
                color: Colors.redAccent,
                backgroundColor: Colors.redAccent,
                fab: false),
      ],
    );
  }

  _buildList() {
    return Flexible(
      child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemCount: _messages.length,
          itemBuilder: (_, index) {
            return Container(child: ChatMessageListItem(_messages[index]));
          }),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPress,
      {Color color: Colors.grey,
      Color backgroundColor: Colors.pinkAccent,
      bool fab = false}) {
    return new SizedBox(
      height: 128,
      width: 128,
      child: fab
          ? new FloatingActionButton(
              child: new Icon(icon),
              onPressed: onPress,
              backgroundColor: backgroundColor)
          : new IconButton(
              icon: new Icon(icon, size: 64.0),
              color: color,
              onPressed: onPress),
    );
  }

  Future _startRecognition() async {
    setState(() {
      isListening = true;
    });
    await _speech.listen(locale: 'en_US');
    _speech.setRecognitionResultHandler((handler) {
      _controllerText.text = handler;
    });
    _speech.setRecognitionCompleteHandler(() {
      setState(() {
        isListening = false;
      });
      _handleSubmit(_controllerText.text, raid.data['displayName'] ?? "",
          raid.data['uid'] ?? "");
    });
  }

  _buildNothing(){
    return Container();
  }

  _buildComposer({double width}) {
    return Container(
        width: width,
        color: Colors.grey.shade200,
        child: new Row(
          children: <Widget>[
            Flexible(
              child: new Padding(
                  padding: new EdgeInsets.all(8.0),
                  child: new TextField(
                    controller: _controllerText,
                    decoration: InputDecoration.collapsed(hintText: ""),
                    onTap: _stopRecognition,
                    onSubmitted: (String out){
                      if(_controllerText.text == ""){
                        return;
                      }
                      else{
                        _handleSubmit(_controllerText.text, raid.data['displayName'] ?? "",
                            raid.data['uid'] ?? "");
                      }
                    },
                  )),
            ),
            new IconButton(
              icon: Icon(Icons.close, color: Colors.grey.shade600),
              onPressed: () {
                _controllerText.text = "";
                _cancelRecognition();
              },
            ),
          ],
        ));
  }

  _handleSubmit(String value, String currentUser, String uid) {
    _controllerText.clear();
    List<String> nameArray =
        currentUser.replaceAll(new RegExp(r"\s+\b|\b\s"), " ").split(" ");
    String initials = ((nameArray[0])[0] != null ? (nameArray[0])[0] : " ") +
        (nameArray.length == 1 ? " " : (nameArray[nameArray.length - 1])[0]);
    _addMessage(
      text: value,
      name: currentUser,
      initials: initials,
    );

    _requestChatBot(value, uid);
  }

  _requestChatBot(String text, String uid) async {
    final dynamic result = await CloudFunctions.instance.call(
      functionName: 'detectIntent',
      parameters: <String, dynamic>{
        'projectID': 'stepify-solutions',
        'sessionID': uid,
        'query': text,
        'languageCode': 'en'
      },
    );

    _addMessage(
        name: "Eyespace",
        initials: "E",
        bot: true,
        text: result[0]['queryResult']['fulfillmentText'] ??
            result[0]['intent']['displayName'] ??
            "An error occurred, please try again!");
  }

  void _addMessage(
      {String name, String initials, bool bot = false, String text}) {
    var animationController = AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );

    var message = ChatMessage(
        name: name,
        text: text,
        initials: initials,
        bot: bot,
        animationController: animationController);

    setState(() {
      _messages.insert(0, message);
    });

    animationController.forward();
  }
}

class ChatMessage {
  final String name;
  final String initials;
  final String text;
  final bool bot;

  AnimationController animationController;

  ChatMessage(
      {this.name,
      this.initials,
      this.text,
      this.bot = false,
      this.animationController});
}

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage chatMessage;

  ChatMessageListItem(this.chatMessage);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: chatMessage.animationController, curve: Curves.easeOut),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(
                child: Text(chatMessage.initials),
                backgroundColor: chatMessage.bot
                    ? Theme.of(context).accentColor
                    : Theme.of(context).highlightColor,
              ),
            ),
            Flexible(
                child: Container(
                    margin: EdgeInsets.only(left: 16.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(chatMessage.name,
                            style: Theme.of(context).textTheme.subhead),
                        Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Text(chatMessage.text))
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
