import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/screens/home_screen.dart';
import 'package:flutter_application_4/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscured = true;


  Future login({required String email,required String password})
  async{
    try{
      final credential=await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password);

  return 'done';
    }on FirebaseAuthException catch(e)
    {
      if(e.code=='invalid-email.')
      {
        return 'invalid email';
      }
      else if(e.code=='invalid-credential')
      {
        return('invalid credential');
      }
    }
    return 'error';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
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
                const SizedBox(height: 20),
                const Icon(Icons.lock_outline, size: 80, color: Colors.indigo),
                const SizedBox(height: 20),
                const Text(
                  'مرحباً بعودتك',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

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
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                    ),
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
                const SizedBox(height: 24),

                // زر تسجيل الدخول
                ElevatedButton(
                  onPressed: ()async{
                    
                      String result=await login(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      if(result=='done')
                      {
                        Navigator.of(context).push(MaterialPageRoute(
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
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text('Dont have an account! '),
                    InkWell(
                      onTap:(){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
                      } ,
                      child: Text('Sign Up',style: TextStyle(color: Colors.blue,fontWeight: .bold),),
                    
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}