import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Luna/helper/constant.dart';
import 'package:Luna/helper/enum.dart';
import 'package:Luna/helper/utility.dart';
import 'package:Luna/model/user.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/ui/page/Auth/widget/googleLoginButton.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customFlatButton.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:Luna/widgets/newWidget/customLoader.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  final VoidCallback? loginCallback;

  const Signup({Key? key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;
  late CustomLoader loader;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    loader = CustomLoader();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return Container(
      height: context.height - 100,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _entryField('Имя', controller: _nameController),
            _entryField('Email',
                controller: _emailController, isEmail: true),
            _entryField('Пароль',
                controller: _passwordController, isPassword: true),
            _entryField('Повторите пароль',
                controller: _confirmController, isPassword: true),
            _submitButton(context),
            //const Divider(height: 30),
            const SizedBox(height: 50),
/*
                                                    GOOGLE SIGNUP DISABLED
              GoogleLoginButton(
              loginCallback: widget.loginCallback,
              loader: loader,
            ),*/
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _entryField(String hint,
      {required TextEditingController controller,
      bool isPassword = false,
      bool isEmail = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: const TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 35),
      child: CustomFlatButton(
        label: "Продолжить",
        onPressed: () => _submitForm(context),
        borderRadius: 30,
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_nameController.text.isEmpty) {
      Utility.customSnackBar(context, 'Введите имя');
      return;
    }
    if (_nameController.text.length > 27) {
      Utility.customSnackBar(context, 'Имя слишком длинное');
      return;
    }
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Utility.customSnackBar(context, 'Вы точно ничего не забыли?');
      return;
    } else if (_passwordController.text != _confirmController.text) {
      Utility.customSnackBar(
          context, 'Пароли не совпадают');
      return;
    }

    loader.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);
    Random random = Random();
    int randomNumber = random.nextInt(8);

    UserModel user = UserModel(
      email: _emailController.text.toLowerCase(),
      bio: 'Привет мир!',
      // contact:  _mobileController.text,
      displayName: _nameController.text,
      dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
          .toString(),
      location: 'Где то во вселенной...',
      profilePic: Constants.dummyProfilePicList[randomNumber],
      isVerified: false,
    );
    state
        .signUp(
      user,
      password: _passwordController.text,
      context: context,
    )
        .then((status) {
      print(status);
    }).whenComplete(
      () {
        loader.hideLoader();
        if (state.authStatus == AuthStatus.LOGGED_IN) {
          Navigator.pop(context);
          if (widget.loginCallback != null) widget.loginCallback!();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText(
          'Регистрация',
          context: context,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }
}
