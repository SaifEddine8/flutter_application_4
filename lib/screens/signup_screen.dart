
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_4/screens/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
class _SignUpScreenState extends State<SignUpScreen> {
  Future<String> signUp({required String email,required String password}) async{
    try{
      final credential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, 
        password: password
        );
        FirebaseFirestore.instance.collection('usersCollection')
        .doc(credential.user!.uid)
        .set({
            'email': _emailController.text.trim(),
             'password': _passwordController.text.trim(),
                                
             }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('User Added Successfully')),
             ))
              .catchError((error) => print("Failed to add user: $error"));
                        
                        
        return 'done';
    } on FirebaseAuthException catch(e){
      if(e.code=='weak-password')
      {
        return('the password provided is too weak.');
      }
      else if(e.code=='email-already-in-use')
      {
        return('the account already exists for that email');
      }

    }
    catch(e){
      return(e.toString());
    }
    return 'error';
    

  }
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                const Icon(Icons.person_add_alt_1_outlined, size: 80, color: Colors.indigo),
                const SizedBox(height: 20),
                const Text(
                  'انضم إلينا اليوم',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // الاسم
                

                // البريد الإلكتروني
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'يرجى إدخال بريد صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // كلمة المرور
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور 6 خانات على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                
                const SizedBox(height: 24),

                // زر إنشاء الحساب
                ElevatedButton(
                  onPressed: () async{
                    
                      String result=await signUp(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      if(result=='done')
                      {
                        
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>LoginScreen()));
                      }
                      else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                      }
                    // Future.delayed(Duration(seconds: 10));
                    _emailController.clear();
                    _passwordController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('إنشاء حساب',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Text('Already have an account! '),
                    InkWell(
                      onTap:(){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
                      } ,
                      child: Text('Login',style: TextStyle(color: Colors.blue,fontWeight: .bold),),
                    
                    )
                  ],
                ),
                SizedBox(height: 25,),
                ElevatedButton(
                  onPressed: ()=>signInWithGoogle(), 
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Image.network('https://cdn2.hubspot.net/hubfs/53/image8-2.jpg',height: 40,),
                      Text('Sign in with google')
                    ],
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}