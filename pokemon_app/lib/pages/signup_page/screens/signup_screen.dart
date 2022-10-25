import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/login_page/screens/login_page.dart';
import 'package:pokemon_app/pages/signup_page/viewmodels/signup_provider.dart';
import 'package:pokemon_app/pages/signup_page/viewmodels/signup_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../values/app_colors.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextEditingController controllerS1 = TextEditingController();
  TextEditingController controllerS2 = TextEditingController();
  TextEditingController controllerS3 = TextEditingController();
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
                      child: InkWell(
                        onTap: () async {
                          if(controllerS1.text != '' && controllerS2.text != '' && controllerS3.text != ''){
                            ref.read(textSignUpStateProvider(context).notifier).state = AppLocalizations.of(context)!.loading ;
                            await ref.read(signUpProvider.notifier).signUp(controllerS1.text, controllerS2.text, controllerS3.text);
                            if(ref.watch(signUpProvider) == const SignUpState.error()){
                             ref.read(textSignUpStateProvider(context).notifier).state = AppLocalizations.of(context)!.error;
                            }
                            if(ref.watch(signUpProvider) == const SignUpState.available()){
                              ref.read(textSignUpStateProvider(context).notifier).state = AppLocalizations.of(context)!.success;
                              await Future.delayed(const Duration(seconds: 1));
                              if(!mounted){
                                return;
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                            }
                          }
                        },
                        child: Container(width: MediaQuery.of(context).size.width, height: 50, alignment: Alignment.center,decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20)
                        ),child: Text(ref.watch(textSignUpStateProvider(context)), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),),
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
