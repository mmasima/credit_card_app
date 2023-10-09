import 'package:flutter/material.dart';

import 'ban_country_screen.dart';
import 'card_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove the back button

          title: const Center(child: Text('Account')),
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: Column(
                children: const [
                  SizedBox(height: 10),
                  Text(
                    'Hi There!',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.only(top: 1.0),
              child: Column(
                children: [
                  const Divider(
                    height: 10,
                    thickness: 2,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CardScreen(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.reorder),
                    title: const Text(
                      "My Cards",
                    ),
                  ),
                   ListTile(
                   onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BanCountryScreen(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.balance),
                    title: const Text(
                      "Ban Country",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
