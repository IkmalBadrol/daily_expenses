import 'package:flutter/material.dart';
import 'dailyexpenses.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController showIpInSharedPreferences = TextEditingController();
  TextEditingController newIpAddress = TextEditingController();


  final String serverIpAdress = "http://192.168.0.119";

  @override
  void initState(){
    super.initState();
    //_getIpAddress();
    _setIpAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/expenses4.jpg',),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'current IP address : ${serverIpAdress}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: newIpAddress,
                decoration: const InputDecoration(
                  labelText: 'New IP Address : ',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            ElevatedButton(onPressed: () {
              String username = usernameController.text;
              String password = passwordController.text;
              if (username == 'ikmal' && password == '1') {
                _setIpAddress();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DailyExpensesApp(username: username),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Login Failed'),
                      content: const Text('Invalid username or password'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);

                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  // Use serverIpAddress if text field for new ip address is empty
  // Use value in newIpAddress from user input as new ip address if the textfield is not empty
  Future<void> _setIpAddress() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(newIpAddress.text == ''){
      prefs.setString('ipAddress', serverIpAdress);
    }else{
      prefs.setString('ipAddress', newIpAddress.text);
    }
  }
}