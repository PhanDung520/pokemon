import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/home_page/screens/home_page.dart';
import 'package:pokemon_app/pages/login_page/viewmodels/login_state.dart';
import 'package:pokemon_app/pages/signup_page/screens/signup_screen.dart';
import 'package:pokemon_app/values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/login_controller.dart';
import 'components/dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/images/bg_png.png'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              margin: const EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: controller1,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.username,
                          hintStyle:  const TextStyle(color: AppColors.lightTextColor, fontSize: 14)
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: controller2,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.password,
                            hintStyle:  const TextStyle(color: AppColors.lightTextColor, fontSize: 14)
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              String username = controller1.text;
                              String password = controller2.text;
                              await loginController.login(username, password, ref);
                              if(ref.watch(loginStateProvider).status == LoginStatus.success){
                                if(!mounted){
                                  return;
                                }
                                showProgessCir(context);
                                await Future.delayed(const Duration(seconds: 1));
                                final SharedPreferences shared = await SharedPreferences.getInstance();
                                shared.setInt('userId', ref.watch(userLoginProvider).userId);
                                if(!mounted){
                                  return;
                                }
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userId: ref.watch(userLoginProvider).userId, isConnect: true,)));
                              }
                              if(ref.watch(loginStateProvider).status == LoginStatus.errorUserPass){
                                if(!mounted){
                                  return;
                                }
                                showAlertDialog(context);
                              }
                            },
                            child: Container(width: MediaQuery.of(context).size.width, height: 50, alignment: Alignment.center,decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20)
                            ),child: Text(AppLocalizations.of(context)!.login, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: InkWell(onTap: (){
                              // ref.read(signUpProvider.notifier).signUp('name', 'password');
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpPage()));
                            },
                                child: Container(margin: const EdgeInsets.symmetric(horizontal: 30),height: 50, width: MediaQuery.of(context).size.width, alignment: Alignment.center,child: Text(AppLocalizations.of(context)!.signup,style: TextStyle(color: Colors.lightBlueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                                )),
                          )
                        ],
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
