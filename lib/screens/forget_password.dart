import 'package:flutter/material.dart';
import 'package:flutter_application_4/servises/auth_service.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController=TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('نسيت كلمة المرور'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder()
            ),
        
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: ()async{
            try{
             await AuthService.resendPassword(emailController.text);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('اذا كان لديك حساب سوف نرسل لك رمز تاكيد عليه')));

            }on AuthException catch(e){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mas)));
            }
          }, child: Text('اعادة التعيين'))
        ],),
      ),
    );
  }
}