import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silesua/services/firestore/firestore.dart';

void thirdpop({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController messageController,
  required TextEditingController contactController,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        content: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: MediaQuery.of(context).size.width * 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Text("Write you story in less than 200 words",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700, fontSize: 17.86))),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 7,
                controller: messageController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(8),
                  hintText: 'Write your message here...',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 150,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(219, 41, 191, 1),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: TextButton(
                    onPressed: () {
                      // firebase here
                      if (messageController.text.isNotEmpty) {
                        nameController.clear();
                        contactController.clear();
                        messageController.clear();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('All field is required')));
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        // ignore: no_leading_underscores_for_local_identifiers
                        FireStoreServices _firestoreservices =
                            FireStoreServices();
                        _firestoreservices.add(nameController.text,
                            contactController.text, messageController.text);
                        messageController.clear();
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            ],
          ),
        ),
      );
    },
  );
}
