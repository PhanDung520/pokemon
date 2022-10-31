import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon_app/pages/home_page/screens/home_screen.dart';
import 'package:pokemon_app/pages/login_page/bloc/login_bloc.dart';
import 'package:pokemon_app/pages/login_page/bloc/login_event.dart';
import 'package:pokemon_app/pages/login_page/bloc/login_state.dart';
import 'package:pokemon_app/pages/signup_page/screens/SignUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../values/app_colors.dart';
import 'dialogs/dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
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
                            BlocConsumer<LoginBloc, LoginState>(
                              builder: (context, state){
                                return InkWell(
                                    onTap: () async {
                                      context.read<LoginBloc>().add(LoginSubmitted(username: controller1.text, password: controller2.text));
                                    },
                                    child: Container(width: MediaQuery.of(context).size.width, height: 50, alignment: Alignment.center,decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(20)
                                    ),child: Text(state is LoginInitial? AppLocalizations.of(context)!.login: state is LoginLoading? AppLocalizations.of(context)!.loading: state is LoginSuccess? AppLocalizations.of(context)!.success: AppLocalizations.of(context)!.error, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),)
                                );
                              },
                              listener: (context, state) async{
                                if(state is LoginSuccess){
                                  await Future.delayed(const Duration(seconds: 1));
                                  final SharedPreferences shared = await SharedPreferences.getInstance();
                                  final map= state.user.toJson();
                                  shared.setString('user', jsonEncode(map));
                                  if(!mounted){
                                    return;
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: state.user, isConnect: true)));
                                }
                                if(state is LoginError){
                                  if(!mounted){
                                    return;
                                  }
                                  showAlertDialog(context);
                                }
                              },
                              listenWhen: (context, state){
                                return state is LoginSuccess || state is LoginError;
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: InkWell(onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                              },
                                  child: Container(margin: const EdgeInsets.symmetric(horizontal: 30),height: 50, width: MediaQuery.of(context).size.width, alignment: Alignment.center,child: Text(AppLocalizations.of(context)!.signup,style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
