import 'package:flutter/material.dart';
import 'package:Luna/helper/enum.dart';
import 'package:Luna/ui/page/Auth/signup.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customFlatButton.dart';
import 'package:Luna/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';
import '../homePage.dart';
import 'signin.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: CustomFlatButton(
        label: "Создать аккаунт",
        onPressed: () {
          var state = Provider.of<AuthState>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Signup(loginCallback: state.getCurrentUser),
            ),
          );
        },
        borderRadius: 30,
      ),
    );
  }
  Widget _loginButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: CustomFlatButton(
        label: "Войти",
        onPressed: () {
          var state = Provider.of<AuthState>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SignIn(loginCallback: state.getCurrentUser),
            ),
          );        },
        borderRadius: 30,
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              height: 100,
              child: Image.asset('assets/images/icon-480.png'),
            ),
            const Spacer(),
            const TitleText(
              'Делитесь своими мыслями',
              fontSize: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            _submitButton(),
            _loginButton(),
            const Spacer(),

            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: state.authStatus == AuthStatus.NOT_LOGGED_IN ||
              state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          : const HomePage(),
    );
  }
}
