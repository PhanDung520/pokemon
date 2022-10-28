import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon_app/pages/login_page/screens/login_screen.dart';
import 'package:pokemon_app/pages/signup_page/bloc/signup_event.dart';

import '../../../values/app_colors.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController controllerS1 = TextEditingController();
  TextEditingController controllerS2 = TextEditingController();
  TextEditingController controllerS3 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/blob_bg.png'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: controllerS1,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.username,
                            hintStyle:  TextStyle(color: AppColors.lightTextColor, fontSize: 14)
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: controllerS2,
                          decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.password,
                              hintStyle:  TextStyle(color: AppColors.lightTextColor, fontSize: 14)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextField(
                          controller: controllerS3,
                          decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.name,
                              hintStyle:  TextStyle(color: AppColors.lightTextColor, fontSize: 14)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: BlocConsumer<SignUpBloc, SignUpState>(
                          listener: (context, state) async {
                            // TODO: implement listener
                            if(state is SignUpSuccess){
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            }
                          },
                          builder: (context, state) {
                            return InkWell(
                            onTap: () async {
                              context.read<SignUpBloc>().add(SignUpSubmitted(username: controllerS1.text, password: controllerS2.text, name: controllerS3.text));
                            },
                            child: Container(width: MediaQuery.of(context).size.width, height: 50, alignment: Alignment.center,decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20)
                            ),child: Text(state.toString(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),),
                          );
                          },
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

