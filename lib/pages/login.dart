import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/forget_pass.dart';
import 'package:flutter_firebase_app/pages/signup.dart';
import 'package:flutter_firebase_app/user/ic_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  userLogin() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IcAuth()));
      
    }on FirebaseAuthException catch(error){
      if(error.code == 'user-not-found'){
        print('No user found for that name');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blueGrey,
          content: Text('No user found for that email',
          style: TextStyle(fontSize: 18.0, color: Colors. amber),),
        ),
        );
      }
      else if(error.code == 'wrong-password'){
        print ('Wrong password provided by the user ');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blueGrey,
          content: Text('Wrong password provided by the user ',
            style: TextStyle(fontSize: 18.0, color: Colors. amber),),
        ),
        );


      }
    }
  }

@override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN PAGE'),
      ),
      backgroundColor: Colors.white,
      body: Form(

        key: _formKey,
        child:  Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
          child: ListView(
           children : [

             Container(
               margin: EdgeInsets.symmetric(vertical: 10.0),
               child: TextFormField(
                 autofocus: false,
                 decoration: InputDecoration(
                   labelText: 'Email',
                   labelStyle: TextStyle(fontSize: 20.0),
                   border: OutlineInputBorder(),
                   errorStyle: TextStyle(color: Colors.black,
                     fontSize: 15,),
                 ),
                 controller: emailController,
                 validator: (value){
                   if (value == null || value.isEmpty){
                     return 'please enter email';
                   }
                   else if(!value.contains('@')){
                     return 'Please enter a valid email';

                   }
                   return null;
                 },
               ),

             ),
             SizedBox(height: 20.0,),
             Container(

               //padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
               child: TextFormField(
                 autofocus: false,
                 obscureText: true,
                 decoration: InputDecoration(
                   labelText: 'Password',
                   labelStyle: TextStyle(fontSize: 20.0),
                   border: OutlineInputBorder(),
                   errorStyle: TextStyle(color: Colors.black,
                     fontSize: 15,),
                 ),
                 controller: passwordController,
                 validator: (value){
                   if (value == null || value.isEmpty){
                     return 'please enter password';
                   }

                   return null;
                 },
               ),
             ),
           Container(
             margin: EdgeInsets.symmetric(vertical: 20.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 ElevatedButton(onPressed: (){
                   if(_formKey.currentState!.validate()){
                     setState(() {
                       email = emailController.text;
                       password = passwordController.text;

                     });
                     userLogin();

                   }
                 },
                     child: Text(
                       'Login',
                       style: TextStyle(fontSize:18.0),
                     ),
                 ),
                 TextButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPass(),
                   ),
                   );

                 },
                     child: Text(
                       'Forget password ?',
                       style: TextStyle(fontSize: 12.0),
                     ),
                 ),

               ],
             ),
           ),
             Container(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text('Do not have account?'),
                   TextButton(onPressed: (){
                     Navigator.pushAndRemoveUntil(context, PageRouteBuilder(pageBuilder: (context,a,b) => Signup(), transitionDuration: Duration(seconds: 0)), (route) => false);
                   },
                       child: Text('Signup'),
                   ),
                 ],
               ),
             ),
           ]
          ),
        ),

      ),

    );
  }
}


