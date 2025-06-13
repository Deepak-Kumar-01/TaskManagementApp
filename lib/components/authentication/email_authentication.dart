import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/utils.dart';
import '../home/home.dart';
import 'email_authentication_bloc.dart';

class UserEmailAuthentication extends StatefulWidget {
  const UserEmailAuthentication({super.key});

  @override
  State<StatefulWidget> createState() => _UserEmailAuthenticationState();
}

class _UserEmailAuthenticationState extends State<UserEmailAuthentication> {
  static late EmailAuthBloc _bloc;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _hidePassword = true;
  bool isSignin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => EmailAuthBloc()..add(OnLoadEmailAuth()),
        child: BlocConsumer<EmailAuthBloc, EmailAuthState>(
          listener: (context, state) {
            if (state is EmailAuthSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                  (Route<dynamic> route) => false);
            }
            if (state is EmailAuthError) {
              Utils.showErrorToast(state.errorMsg, context);
              print("Print err: ${state.errorMsg}");
              BlocProvider.of<EmailAuthBloc>(context).add(OnLoadEmailAuth());
            }
          },
          builder: (context, state) {
            _bloc = BlocProvider.of<EmailAuthBloc>(context);
            if (state is EmailAuthLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/welcome_img.png",
                              ),
                              Text(
                                isSignin
                                    ? "Welcome back!"
                                    : "Let's get started!",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              //Email
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                  focusNode: _emailFocusNode,
                                  validator: _emailValidation,
                                  decoration: const InputDecoration(
                                    labelText: "Email",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    prefixIcon: Icon(Icons.alternate_email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  textInputAction: TextInputAction.none,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context)
                                        .requestFocus(_passwordFocusNode);
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              //Password
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                  focusNode: _passwordFocusNode,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    prefixIcon: Icon(Icons.password_sharp),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _hidePassword = !_hidePassword;
                                          });
                                        },
                                        icon: Icon(!_hidePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: _hidePassword,
                                  controller: _passwordController,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (_emailController.text.isEmpty) {
                                        Utils.showErrorToast(
                                            "Enter your email to get a reset link.",
                                            context);
                                      } else {
                                        _bloc.add(OnResetLinkSent(
                                            email: _emailController.text));
                                        Utils.showSuccessToast(
                                            "Please check your email", context);
                                      }
                                    },
                                    child: Text(
                                      isSignin ? "Forget Password?" : "",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue[900]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 32, right: 32),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _handleOnPressed(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff666af6),
                                      minimumSize: const Size(64, 48),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      isSignin ? "Login" : "Signup",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              // Resend option
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(!isSignin
                                      ? "Already have an account? "
                                      : "Don't have an account? "),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSignin = !isSignin;
                                      });
                                    },
                                    child: Text(
                                      !isSignin ? "Log in" : "Get started!",
                                      style: TextStyle(
                                        color: const Color(0xff666af6),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 12),
                        ],
                      )),
                ),
              );
            }
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isSignin
                      ? "Authenticating, please wait"
                      : "Registering, please wait..."),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xff666af6),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String? _emailValidation(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "Email can't be empty";
      } else if (validateEmail(value)) {
        return "Enter a valid Email";
      }
    }
    return null;
  }

  bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value.trim()));
  }

  _handleOnPressed(BuildContext context) {
    if (_emailController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
      //show toast error msg
      return;
    } else if (validateEmail(_emailController.text)) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
      //show toast error msg
      return;
    }

    if (_passwordController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
      return;
    }
    BlocProvider.of<EmailAuthBloc>(context).add(OnAuthenticationClicked(
        email: _emailController.text.toLowerCase(),
        password: _passwordController.text,
        isSignin: isSignin));
  }
}
