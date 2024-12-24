import 'package:daily_e/constant.dart';
import 'package:daily_e/src/application/storage.dart';
import 'package:daily_e/src/application/user_service.dart';
import 'package:daily_e/src/presentation/button.dart';
import 'package:daily_e/src/presentation/text_field.dart';
import 'package:daily_e/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        SecureStorage().saveUserId((response.user.id) as int);

        // call onLoginSuccess
        onLoginSuccess();
      } catch (e) {
        // show error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kWhite,
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
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ).copyWith(color: AppColor.kGrayscaleDark100, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We’re happy to see you. Sign In to your account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.kGrayscale40,
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
                          style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.kWhite)
                              .copyWith(
                                  color: AppColor.kGrayscaleDark100,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
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
                          style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.kWhite)
                              .copyWith(
                                  color: AppColor.kGrayscaleDark100,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
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
                      PrimaryTextButton(
                        onPressed: () {},
                        title: 'Forgot Password?',
                        textStyle: const TextStyle(),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      PrimaryButton(
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
                          onTab: () {},
                          subtitleTextStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.kWhite)
                              .copyWith(
                                  color: AppColor.kPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Column(
                      children: [
                        const DividerRow(title: 'Or Sign In with'),
                        const SizedBox(height: 24),
                        SecondaryButton(
                            height: 56,
                            textColor: AppColor.kGrayscaleDark100,
                            width: 280,
                            onTap: () {},
                            borderRadius: 24,
                            bgColor: AppColor.kBackground.withOpacity(0.3),
                            text: 'Continue with Google',
                            icons: ImagesPath.kGoogleIcon),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TermsAndPrivacyText(
                      title1: '  By signing up you agree to our',
                      title2: ' Terms ',
                      title3: '  and',
                      title4: ' Conditions of Use',
                    ),
                  ),
                  const SizedBox(height: 24),
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
          style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.kWhite)
              .copyWith(
                  color: AppColor.kGrayscale40,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
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
