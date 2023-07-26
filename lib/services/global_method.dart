import 'package:flutter/material.dart';

class GlobalMethods {
  // ______________ 1_____________________________
  Future<void> showDialogg(
      String title, String subtitle, Function fct, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Image.asset(
                    'assets/public/alert_img.png',
                    height: 50,
                    width: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title),
                ),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color, fontSize: 16),
                  )),
              TextButton(
                  onPressed: () {
                    fct();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color, fontSize: 16),
                  ))
            ],
          );
        });
  }

  /////
//______________________ 2 ___________________________________
  Future<void> authErrorHandle(String subtitle, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Image.asset(
                    'assets/public/alert_img.png',
                    height: 50,
                    width: 50,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Error occured'),
                ),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

//________________________3  ___________________________
  void showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                //FocusScope.of(context).unfocus();
              },
            ),
          ],
        );
      },
    );
  }
}


//___________________________________________-