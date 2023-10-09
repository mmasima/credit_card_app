import 'package:country_picker/country_picker.dart';
import 'package:credit_card/global/global.dart';
import 'package:flutter/material.dart';

class BanCountryScreen extends StatefulWidget {
  const BanCountryScreen({super.key});

  @override
  State<BanCountryScreen> createState() => _BanCountryScreenState();
}

class _BanCountryScreenState extends State<BanCountryScreen> {
  Country? issueCountry;
  List bannedCountries = [];

  _addCountry() {
    if (issueCountry != null) {
      if (bannedCountries.contains(issueCountry?.name)) {
        issueCountry = null;
      }
    }
    banCountries(issueCountry?.name ?? '');
    _banCountryList();
  }

  Future<void> _banCountryList() async {
    final banList = await getBanList();

    issueCountry = null;

    setState(() {
      bannedCountries = banList;
    });
  }

  @override
  void initState() {
    _banCountryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Ban Countries')),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                        40), // fromHeight use double.infinity as width and 40 is the height
                  ),
                  onPressed: () {
                    _addCountry();
                  },
                  child: const Text('add Country'),
                ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                issueCountry?.name == null ? '' : '${issueCountry?.name}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                
                onPressed: () {
                  showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                        setState(() {
                          issueCountry = country;
                        });
                      });
                },
                child: const Text('Choose country to ban'),
              ),
              
              const SizedBox(height: 60.0), // Add some spacing

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Banned Cuntries',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              const SizedBox(height: 20.0), // Add some spacing

              Column(children: [
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: bannedCountries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${bannedCountries[index]}',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 16.0), // Add some spacing
                            Container(
                              height: 1.0, // Adjust the thickness of the line
                              color: Colors.black, // Set the line color
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
