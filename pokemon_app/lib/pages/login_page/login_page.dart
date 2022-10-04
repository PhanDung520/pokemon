import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/user.dart';
import 'package:pokemon_app/pages/home_page/home_page.dart';
import 'package:pokemon_app/pages/login_page/components/dialog.dart';
import 'package:pokemon_app/pages/login_page/login_state.dart';
import 'package:pokemon_app/values/app_colors.dart';
import 'login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  LoginController loginController = LoginController();

  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/images/blob_bg.png'),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.4,
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
                    Container(
                        margin: EdgeInsets.only(top: 40),
                      child: InkWell(
                        onTap: () async {
                          String username = controller1.text;
                          String password = controller2.text;
                          await loginController.Login(username, password, ref);
                          if(ref.watch(loginStateProvider).status == LoginStatus.success){
                            showProgessCir(context);
                            await Future.delayed(Duration(seconds: 1));
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userId: ref.watch(userLoginProvider).userId)));
                            print(ref.watch(userLoginProvider).userId);
                          }
                          if(ref.watch(loginStateProvider).status == LoginStatus.errorUserPass){
                            showAlertDialog(context);
                          }
                        },
                        child: Container(width: MediaQuery.of(context).size.width, height: 50, alignment: Alignment.center,child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20)
                        ),),
                      ),
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
