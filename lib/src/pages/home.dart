import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:telephony/telephony.dart';

import '../components/service/Toast.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool status_motor=false;
  String? _message;
  bool canSend=false;
final Telephony telephony = Telephony.instance;
List<SmsMessage> messages=[];
@override
void initState() {
  super.initState();
  _canSend();
  telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Handle message
        });
}
_canSend()async{
  canSend = await canSendSMS();
}
listenIncommingMsg()async{
  messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
        filter: SmsFilter.where(SmsColumn.ADDRESS)
            .equals("9360989789"),
        sortOrder: [
          OrderBy(SmsColumn.DATE, sort: Sort.ASC)
        ]);
}
  Future<void> _sendSMS() async {
    List<String>  recipients=["9360989789"];
    try {
      String _result = await sendSMS(
        message:status_motor?"OFF":"ON",
        recipients: recipients,
        sendDirect: true,
      );
      setState(() => _message = _result);
      ToastMsg.message("Sent Successfully.");
    } catch (error) {
      setState(() => _message = error.toString());
      ToastMsg.message("Failed to sent.");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: ((context, index) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Motor name1"),
              FlutterSwitch(
                disabled: canSend,
                width: 60.0,
                height: 30.0,
                valueFontSize: 14.0,
                toggleSize: 25.0,
                value: status_motor,
                borderRadius: 20.0,
                padding: 0.0,
                showOnOff: true,
                onToggle: (val) async{
                 await _sendSMS();
                  setState(() {
                    status_motor = val;
                  });
                },
              ),
            ],
          ),
        );
      })),
    );
  }
}