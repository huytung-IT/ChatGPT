import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'ChatScreen.dart';
import 'ChatServices.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignIn(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {
  // ignore: must_call_super
  @override
  void initState(){
    super.initState();
    ChatServices.googleSignIn.onCurrentUserChanged.listen((account){
      setState(() {
      ChatServices.currentUser = account;
      });
    }) ;
   ChatServices.googleSignIn.signInSilently();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0x666fa287),
                    Color(0x996fa287),
                    Color(0xcc6fa287),
                    Color(0xff6fa287),
                  ])),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 90),
                      child: Image.asset(
                        'assets/images/iconchatgpt.png',
                        height: 100,
                        width: 100,
                        scale: 5,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Welcome Chat GPT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        ChatServices.navigateCallback = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatScreen()),
                          );
                        };
                         await ChatServices.signInWithGoogle();
                         //todo: gan thong tin user dang nhap = google vao User de luu tru = hive
                        GoogleSignInAccount? signedInUser = ChatServices.getCurrentUserAccount();
                        if(signedInUser != null){
                          ChatServices.storeUserInformation(signedInUser);
                        }


                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                        Image.asset(
                        "assets/images/google.png",
                        // scale: 2,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 40,
                      ),

                       const Text(
                        'Sign in with Google',
                      style: TextStyle(
                        
                        color: Color(0xff6fa287),
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                      ),
                    ]
                ),
                    ),
                    ElevatedButton(
                        onPressed: (){

                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
                        ),
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/fb.png",
                                // scale: 2,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 24,
                              ),

                              const Text(
                                  'Sign in with facebook',
                                  style: TextStyle(
                                      color: Color(0xff6fa287),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ]
                        )
                    ),
                    ElevatedButton(
                        onPressed: (){

                    },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
                        ),
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/github.png",
                                // scale: 2,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 45,
                              ),

                              const Text(
                                  'Sign in with github',
                                  style: TextStyle(
                                      color: Color(0xff6fa287),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ]
                        )
                    ),
                    SizedBox( height: 10),

                    ElevatedButton(
              onPressed: ChatServices.signOutWithGoogle, child: Text('sign out'),
            ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
