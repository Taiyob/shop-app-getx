import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app_getx/api_connection/api_connection.dart';
import 'package:shop_app_getx/users/authentication/log_in_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app_getx/users/model/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;
  validateUserEmail()  async
    {
      try{
        var res = await http.post(
          Uri.parse(API.validateEmail),
          body: {
            'user_email' : emailController.text.trim(),
          },
        );
        if(res.statusCode == 200){
           var resBodyOfValidateEmail = jsonDecode(res.body);
           if(resBodyOfValidateEmail['emailFound'] == true){
             Fluttertoast.showToast(msg: 'Email already taken');
           }else{
             registerAndSaveUserRecord();
           }
        }
      } catch(e){
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  registerAndSaveUserRecord() async{
    User userModel = User(
          1,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    try{
      var res = await http.post(Uri.parse(API.signUp),
        body: userModel.toJson(),
      );
      if(res.statusCode == 200){
        var resBodyOfSignUp = jsonDecode(res.body);
        if(resBodyOfSignUp['success'] == true){
            Fluttertoast.showToast(msg: 'Registered Successfully');
        } else{
          Fluttertoast.showToast(msg: 'Error!!! Try again',);
        }
      }
    } catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(builder: (context, cons)
      {
       return ConstrainedBox(constraints: BoxConstraints(
          minHeight: cons.maxHeight,
       ),
       child: SingleChildScrollView(
           child: Column(
           children: [
             // Register Header
             SizedBox(
               width: MediaQuery.of(context).size.width,
               height: 285,
               child: Image.asset('images/register.png'),
             ),
             // Sign up screen form
             Padding(padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(60),),
                    boxShadow: [BoxShadow(
                      blurRadius: 8,
                      color: Colors.white,
                      offset: Offset(0,10),
                    ),],
                  ),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                   child: Column(
                     children: [
                       // name email password signup-button
                       Form(
                         key:formKey,
                         child: Column(
                           children: [
                             // name
                             TextFormField(
                               controller: nameController,
                               validator: (val) => val == "" ? "Please write your name" : null,
                               decoration: InputDecoration(
                                 prefixIcon: const Icon(Icons.person, color: Colors.black,),
                                 hintText: 'name....',
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: const BorderSide(color: Colors.white),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: const BorderSide(color: Colors.white),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: const BorderSide(color: Colors.white),
                                 ),
                                 disabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: const BorderSide(color: Colors.white),
                                 ),
                                 contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                 fillColor: Colors.white,
                                 filled: true,
                               ),
                             ),
                             const SizedBox(height: 18,),
                             // email
                             TextFormField(
                               controller: emailController,
                               validator: (val) => val == "" ? "Please write your email" : null,
                               decoration: InputDecoration(
                                 prefixIcon: const Icon(Icons.email, color: Colors.black,),
                                 hintText: 'email....',
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: const BorderSide(color: Colors.white),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: const BorderSide(color: Colors.white),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: const BorderSide(color: Colors.white),
                                 ),
                                 disabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: const BorderSide(color: Colors.white),
                                 ),
                                 contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                 fillColor: Colors.white,
                                 filled: true,
                               ),
                             ),
                             const SizedBox(height: 18,),
                             // password
                             Obx(
                                     () => TextFormField(
                                       controller: passwordController,
                                       obscureText: isObsecure.value,
                                       validator: (val)=>val == '' ? 'please give password' : null,
                                       decoration: InputDecoration(
                                         prefixIcon: const Icon(Icons.vpn_key_sharp,color: Colors.black,),
                                         suffixIcon: Obx(() => GestureDetector(onTap: ()
                                         {
                                          isObsecure.value = !isObsecure.value;
                                         },child: Icon(isObsecure.value ? Icons.visibility_off : Icons.visibility,color:Colors.black,),
                                         ),
                                         ),
                                         hintText: 'password.....',
                                         border: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(30),
                                           borderSide: const BorderSide(color: Colors.white),
                                         ),
                                         enabledBorder: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(30),
                                           borderSide: const BorderSide(color: Colors.white),
                                         ),
                                         focusedBorder: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(30),
                                           borderSide: const BorderSide(color: Colors.white),
                                         ),
                                         disabledBorder: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(30),
                                           borderSide: const BorderSide(color: Colors.white),
                                         ),
                                         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                         fillColor: Colors.white,
                                         filled: true,
                                       ),
                                     )
                             ),
                             const SizedBox(height: 18,),
                             // button
                             Material(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(30),
                               child: InkWell(
                                 onTap: (){
                                   if(formKey.currentState!.validate()){
                                     validateUserEmail();
                                   }
                                 },
                                 borderRadius: BorderRadius.circular(30),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    child: Text('sign up',style: TextStyle(color: Colors.black,fontSize: 16),),
                                  ),
                               ),
                             ),
                           ],
                         ),
                       ),
                       const SizedBox(height: 16,),
                       // already have account button
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           const Text('Already have an account?',style: TextStyle(color: Colors.white),),
                           TextButton(onPressed: (){Get.to(const LogInScreen());},
                             child: Container(
                                 decoration: BoxDecoration(border: Border.all(color: Colors.white),borderRadius: BorderRadius.all(Radius.circular(20))),
                                 child: const Padding(
                                   padding: EdgeInsets.all(8.0),
                                   child: Text('sign in here',style: TextStyle(color: Colors.white,),),
                                 )),
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
                ),
             )
         ],
       ),
       ),
       );
      },),
    );
  }
}
