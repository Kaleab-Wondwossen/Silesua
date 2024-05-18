import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/chat_bubble.dart';
import '../components/my_text_field.dart';
import '../model/messages.dart';
import '../services/chats/chat_services.dart';

class ConsultantChatPage extends StatefulWidget {
  final String reciverUserEmail;
  final String reciverUserID;
  const ConsultantChatPage({super.key, required this.reciverUserEmail, required this.reciverUserID});

  @override
  State<ConsultantChatPage> createState() => _ConsultantChatPageState();
}

class _ConsultantChatPageState extends State<ConsultantChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciverUserEmail),
        actions: [
          IconButton(
            onPressed: () {
              // Handle bell icon tap
            },
            icon: const Icon(Icons.notifications), // Bell icon
          ),
          IconButton(
            onPressed: () {
              // Handle books icon tap
            },
            icon: const Icon(Icons.menu_book), // Books icon
          ),
          //IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //input field
          _buildMessageInput(),

          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatServices.getMessages(
            widget.reciverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  //message item builder
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    Color bubbleColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? const Color.fromARGB(255, 228, 183, 235)
        : Colors.grey;

    // Convert timestamp to DateTime
    DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

    // Format DateTime to a readable format
    String formattedDateTime =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(timestamp);

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            // Text(data['senderEmail']),
            const SizedBox(
              height: 10,
            ),
            ChatBubble(
              messages: data['message'],
              bubbleColor: bubbleColor,
            ),
            Text(
              formattedDateTime, // Display formatted date and time
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //message input field builder
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
                hintText: 'Enter Your Message',
                controllers: _messageController,
                obscureText: false),
          ),
          IconButton(
              onPressed: () async {
                // ignore: no_leading_underscores_for_local_identifiers
                final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                try {
                  // Get current user info
                  final String currentUserId = _firebaseAuth.currentUser!.uid;
                  final String currentUserEmail =
                      _firebaseAuth.currentUser!.email.toString();
                  final Timestamp timestamp = Timestamp.now();

                  // Create the new message
                  Message newMessage = Message(
                    senderId: currentUserId,
                    senderEmail: currentUserEmail,
                    receiverId: widget.reciverUserID,
                    timestamp: timestamp,
                    message: _messageController.text,
                  );

                  // Construct chat room id from the current user id and receiver id to ensure uniqueness
                  List<String> ids = [
                    currentUserId,
                    widget.reciverUserID,
                  ];
                  ids.sort();
                  String chatRoomId = ids.join("_");

                  // Add the message to the database
                  await _firestore
                      .collection("chat_rooms")
                      .doc(chatRoomId)
                      .collection('message')
                      .add(newMessage.toMap());

                  // Getting the messages
                  _messageController.clear();
                } catch (error) {
                  // ignore: avoid_print
                  print('Error sending message: $error');
                }
              },
              icon: const Icon(
                Icons.send,
                size: 40,
              ))
        ],
      ),
    );
  }
}


