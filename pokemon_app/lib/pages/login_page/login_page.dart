import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/user.dart';
import 'package:pokemon_app/pages/home_page/home_page.dart';
import 'package:pokemon_app/pages/login_page/components/dialog.dart';
import 'package:pokemon_app/values/app_colors.dart';

import '../../povider/provider.dart';


class LoginPage extends ConsumerWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    final valueUser = ref.watch(userGetProvider);
    List<User>? listData;
    valueUser.when(data: (data){
      listData = data;
    }, error: (e, stack){
      return Text(e.toString());
    }, loading: (){return Text('Loading');});

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              child: Image.asset('assets/images/blob_bg.png'),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              margin: EdgeInsets.only(top: 20),
              width: size.width,
              height: size.height*0.4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: controller1,
                      decoration: InputDecoration(
                          hintText: 'User name',
                          hintStyle:  TextStyle(color: AppColors.lightTextColor, fontSize: 14)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: controller2,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle:  TextStyle(color: AppColors.lightTextColor, fontSize: 14)
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        String username = controller1.text;
                        String password = controller2.text;
                        int count =0;
                        for(User user in listData!){
                          if(user.name == username && user.password == password){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(userId: user.userId)));
                            count =1;
                          }
                        }
                        if(count == 0){
                          showAlertDialog(context);
                        }
                      },
                      child: Container(width: size.width, height: 50, alignment: Alignment.center, margin: EdgeInsets.only(top: 40),child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20)
                      ),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}