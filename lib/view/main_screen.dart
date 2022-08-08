import 'package:flutter/material.dart';
import 'package:tech_blog/model/currency.dart';
import 'package:intl/intl.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer' as developer;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Currency> currency = [];

  Future getResponse() async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
    await http.get(Uri.parse(url)).then((response) {
      developer.log(response.statusCode.toString());
      if (currency.isEmpty) {
        if (response.statusCode == 200) {
          List jsonArray = convert.jsonDecode(response.body);
          for (int i = 0; i < jsonArray.length; i++) {
            setState(() {
              currency.add(Currency(
                  id: jsonArray[i]['id'],
                  title: jsonArray[i]['title'],
                  price: jsonArray[i]['price'],
                  changes: jsonArray[i]['changes'],
                  status: jsonArray[i]['status']));
            });
          }
        }
      }
      return response;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResponse();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black) ,elevation: 1,
          backgroundColor: Colors.grey[100],
        ),
        drawer: const MyAppbar(),
        body: Column(
          children: [
            currency.length == 0
                ? SizedBox(
                    height: MediaQuery.of(context).size.height - 400,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ))
                : Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 400,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child:
                                        Text(currency[index].title.toString().toPersianDigit())),
                                Expanded(
                                    child: Text(
                                        currency[index].price.toString().toPersianDigit(),
                                        textAlign: TextAlign.center)),
                                Expanded(
                                    child: Text(
                                  currency[index].changes.toString().toPersianDigit(),

                                  textAlign: TextAlign.left,
                                )),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          if (index % 9 == 0) {
                            return Container(
                              alignment: Alignment.center,
                              height: 47,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.orangeAccent),
                              child: const Text('جای تبلیغات شما اینجاست'),
                            );
                          } else {
                            return const Divider();
                          }
                        },
                        itemCount: currency.length),
                  ),
            
            const SizedBox(height: 50,),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               ElevatedButton(onPressed: (){
                 currency.clear();
                 FutureBuilder(
                     future: getResponse(),
                     builder: (context , snapshot){

                       if (snapshot.hasData) {
                         return Container(
                           padding: const EdgeInsets.all(8),
                           margin: const EdgeInsets.all(8),
                           width: double.infinity,
                           height: MediaQuery.of(context).size.height - 400,
                           child: ListView.separated(
                               itemBuilder: (context, index) {
                                 return SizedBox(
                                   height: 40,
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Expanded(
                                           child:
                                           Text(currency[index].title.toString())),
                                       Expanded(
                                           child: Text(
                                               currency[index].price.toString(),
                                               textAlign: TextAlign.center)),
                                       Expanded(
                                           child: Text(
                                             currency[index].changes.toString().toPersianDigit(),
                                             style: TextStyle(
                                                 color: currency[index].changes == "n"
                                                     ? Colors.red
                                                     : Colors.grey),
                                             textAlign: TextAlign.left,
                                           )),
                                     ],
                                   ),
                                 );
                               },
                               separatorBuilder: (context, index) {
                                 if (index % 9 == 0) {
                                   return Container(
                                     alignment: Alignment.center,
                                     height: 47,
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(20),
                                         color: Colors.orangeAccent),
                                     child: const Text('جای تبلیغات شما اینجاست'),
                                   );
                                 } else {
                                   return const Divider();
                                 }
                               },
                               itemCount: currency.length),
                         );
                       } else {
                         return SizedBox(
                             height: MediaQuery.of(context).size.height - 400,
                             child: const Center(
                               child: CircularProgressIndicator(),
                             )

                         );

                       }

                     });
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text('Updated')));

               }, child: const Text('update')),
               Text(getTime())
             ],
           )
          ],
        ),
      ),
    );
  }
  String getTime(){

    DateTime now = DateTime.now();

    return DateFormat('kk:mm:ss').format(now).toPersianDigit();
  }
}

class MyAppbar extends StatelessWidget {
  const MyAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: Column(
        children:  [
          const UserAccountsDrawerHeader(accountName: Text(""), accountEmail:  Text(''),
          currentAccountPicture: CircleAvatar(),


          ),
          ListTile(
            onTap: (){
              
              },
            leading: Container(width: 35,height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.orangeAccent,
            ),
              child: const Icon(Icons.question_mark , color: Colors.white,),
            ),
            title: const Text("dddddddd"),
            subtitle: const Text('ddddddddddddddddddd'),
          )
        ],
      ),
    );
  }
}
