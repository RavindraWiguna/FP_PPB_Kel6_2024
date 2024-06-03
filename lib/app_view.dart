import 'package:flutter/material.dart';
import 'package:fpppb2024/auths/auth_page.dart';

class MyAppView extends StatelessWidget {

  MyAppView({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracer',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade100,
          onBackground: Colors.black,
          primary: const Color(0xFF00B2E7),
          secondary: const Color(0xFFE064F7),
          tertiary: const Color(0xFFFF8D6C),

        )
      ),
      home: AuthPage(),
    );
  }
}
// appBar: AppBar(
// actions: [
// IconButton(
// onPressed: signUserOut,
// icon: Icon(Icons.logout),
// )
// ],
// ),
// body: Center(child: Text("LOGGED IN AS: " + user.email!),),
// );