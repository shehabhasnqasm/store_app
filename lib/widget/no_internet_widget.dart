import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            SizedBox(
                // height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                child: Image.asset(
                  "assets/public/net.jpg",
                  fit: BoxFit.contain,
                )),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text("No internet ; Please check your internet"),
            )
          ],
        ),
      ),
    );
  }
}
