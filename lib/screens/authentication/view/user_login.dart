import 'package:expense_tracker/screens/home/views/home_screen.dart';
import 'package:expense_tracker/screens/authentication/bloc/user_bloc.dart';
import 'package:expense_tracker/screens/authentication/repository/user_signup.dart';
import 'package:expense_tracker/screens/authentication/view/user_signup.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void checkTextBox(BuildContext ctx) {
    final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Helper to show SnackBar error
    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red,
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      );
    }

    // Validation logic
    if (email.isEmpty || password.isEmpty) {
      showError("Make sure you fill all the fields.");
    } else if (!emailReg.hasMatch(email)) {
      showError("Email is not in the correct format.");
    } else if (password.length <= 6) {
      showError("Password is too short.");
    } else {
      // All valid, dispatch signup event
      ctx.read<UserLoginBloc>().add(
        UserRequestSignin(email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserLoginBloc(),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor(context),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppTheme.backgroundColor(context),
                elevation: 0,
                pinned: true,
                centerTitle: false,
                expandedHeight: 400.0,
                stretch: true,
                flexibleSpace: const FlexibleSpaceBar(
                  stretchModes: [StretchMode.zoomBackground],
                  background: Image(
                    image: AssetImage('assets/images/login.jpg'),
                  ),
                ),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.height,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor(context),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 40,
                    ),
                    child: BlocConsumer<UserLoginBloc, UserState>(
                      listener: (context, state) {
                        if (state is UserSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                padding: EdgeInsets.all(20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.green,
                                ),
                                child: Text(
                                  "Login Successfully...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        } else if (state is UserError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                padding: EdgeInsets.all(20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.red,
                                ),
                                child: Text(
                                  state.message,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Expense Tracker",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 12,
                              ),
                            ),
                            SizedBox(height: 30),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              maxLength: 40,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                suffixIcon: Icon(
                                  Icons.alternate_email,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "EMAIL",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              maxLength: 40,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                label: Text(
                                  "PASSWORD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  checkTextBox(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primaryColor(
                                    context,
                                  ),
                                ),
                                child: state is UserLoading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Loading...",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "Login",
                                        style: TextStyle(fontSize: 20),
                                      ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Text.rich(
                              TextSpan(
                                text: 'Don\'t have an account? ',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(color: Colors.white),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserSignup(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30),
                            Divider(color: Colors.white),
                            SizedBox(height: 30),
                            SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await DataBaseMethods().userLoginWithGoogle();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primaryColor(
                                    context,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.google),
                                    SizedBox(width: 10),
                                    Text(
                                      "Login With Google",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
