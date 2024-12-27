import 'package:daily_e/src/application/storage.dart';
import 'package:daily_e/src/application/user_service.dart';
import 'package:daily_e/src/presentation/auth/forgotpassword_page.dart';
import 'package:daily_e/src/presentation/auth/signup_page.dart' as signup;
import 'package:daily_e/src/presentation/button.dart' as button;
import 'package:daily_e/src/presentation/text_field.dart';
import 'package:daily_e/src/presentation/theme_provider.dart';
import 'package:daily_e/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  final Future<void> Function() onLoginSuccess;
  SignInScreen({super.key, required this.onLoginSuccess});
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // handle login
  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // call login service
      try {
        final response = await UserService().login(emailC.text, passwordC.text);
        // save token to storage
        SecureStorage().saveToken(response.jwt);
        SecureStorage().saveUserId((response.user.id));

        // call onLoginSuccess
        onLoginSuccess();
      } catch (e) {
        // show error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Access ThemeProvider

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400, // Adjust the max width as needed
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: 320,
                child: Column(children: [
                  Text(
                    'Hi, Welcome Back! 👋',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).brightness != Brightness.dark
                          ? Colors.grey[800]
                          : Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We’re happy to see you. Sign In to your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).brightness != Brightness.dark
                          ? Colors.grey[800]
                          : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Identifier',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        PrimaryTextFormField(
                          borderRadius: BorderRadius.circular(24),
                          hintText: 'Email / Username',
                          controller: emailC,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        PasswordTextField(
                            borderRadius: BorderRadius.circular(24),
                            hintText: 'Password',
                            controller: passwordC,
                            width: 327,
                            height: 52)
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      button.PrimaryTextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        title: 'Forgot Password?',
                        textStyle: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      button.PrimaryButton(
                        elevation: 0,
                        onTap: handleLogin,
                        text: 'LogIn',
                        bgColor: AppColor.kPrimary,
                        borderRadius: 20,
                        height: 46,
                        width: 327,
                        textColor: AppColor.kWhite,
                        fontSize: 14,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: CustomRichText(
                          title: 'Don’t have an account?',
                          subtitle: ' Create here',
                          onTab: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const signup.SignUpScreen(),
                              ),
                            );
                          },
                          subtitleTextStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTab,
    required this.subtitleTextStyle,
  });
  final String title, subtitle;
  final TextStyle subtitleTextStyle;
  final VoidCallback onTab;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: title,
          style: subtitleTextStyle.copyWith(
            color: Theme.of(context).brightness != Brightness.dark
                ? Colors.grey[800]
                : Colors.white,
          ),
          children: <TextSpan>[
            TextSpan(
              text: subtitle,
              style: subtitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
