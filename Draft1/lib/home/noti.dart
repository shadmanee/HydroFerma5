import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydroferma5/home/user.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../util/sidebar.dart';
import 'package:app_settings/app_settings.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'message_screen.dart';

class NotificationMessages {
  String msgtitle = '';
  String msgbody = '';
  String msgtype = '';
  String msgid = '';
  DateTime time = DateTime.now();
}

List<NotificationMessages> msgList = [];

class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance ;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  void requestNotificationPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user granted permission');
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('user granted provisional permission');
    }
    else{
      print('user denied permission');
    }

  }

  Future<void>  initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
      onSelectNotification: (String? payload) async {
        // Handle notification selection
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      NotificationMessages newmsg = NotificationMessages();
      if (kDebugMode) {
        newmsg.msgtitle = message.notification!.title.toString();
        newmsg.msgbody = message.notification!.body.toString();
        newmsg.msgtype = message.data['type'];
        newmsg.msgid = message.data['id'];
        newmsg.time = DateTime.now();
        // DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        // String formattedTime = formatter.format(newmsg.time);
        // newmsg.time = formattedTime as DateTime;
        msgList.add(newmsg);
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString()); ////
        print(message.data['type']);////
        print(message.data['id']);////
      }
      initLocalNotifications(context , message);////
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

      // Rest of the code...
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails
    );
      Future.delayed(Duration.zero, () {
        _flutterLocalNotificationsPlugin.show(0,
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            notificationDetails);
      });
    }


  Future<String> getDeviceToken()async{
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }

  Future<void> setupInteractMessage(BuildContext context)async{
    //when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }
    //when app is inbg
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message){
    if(message.data['type'] == 'msg'){
      Navigator.push(context,
          // NotificationMessages
          MaterialPageRoute(builder: (context) => MessageScreen(
            messages: msgList,
          )));
    }
  }
}
