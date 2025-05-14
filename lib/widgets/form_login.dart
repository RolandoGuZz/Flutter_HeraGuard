import 'package:flutter/material.dart';

class FormLogin extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function() onSubmit;
  final Function() onRegisterPressed;
  final bool isLoading;

  const FormLogin({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onRegisterPressed,
    required this.isLoading,
  });

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _emailIsFocus = false;
  bool _passwordIsFocus = false;
  bool _ocultarPassword = true;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_updateEmailFocus);
    _passwordFocus.addListener(_updatePasswordFocus);
  }

  void _updateEmailFocus() =>
      setState(() => _emailIsFocus = _emailFocus.hasFocus);
  void _updatePasswordFocus() =>
      setState(() => _passwordIsFocus = _passwordFocus.hasFocus);

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmailField(),
          SizedBox(height: 20),
          _buildPasswordField(),
          SizedBox(height: 30),
          _loginButton(),
          SizedBox(height: 15),
          _resgisterButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: widget.emailController,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: _emailIsFocus ? Color.fromRGBO(35, 150, 230, 1) : Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(35, 150, 230, 1)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: widget.passwordController,
      focusNode: _passwordFocus,
      obscureText: _ocultarPassword,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        prefixIcon: Icon(
          Icons.lock_outline,
          color:
              _passwordIsFocus ? Color.fromRGBO(35, 150, 230, 1) : Colors.black,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _ocultarPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => setState(() => _ocultarPassword = !_ocultarPassword),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(35, 150, 230, 1)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onSubmit,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          minimumSize: Size(double.infinity, 0),
          backgroundColor: Color.fromRGBO(35, 150, 230, 1),
        ),
        child:
            widget.isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
      ),
    );
  }

  Widget _resgisterButton() {
    return TextButton(
      onPressed: widget.onRegisterPressed,
      child: Text(
        '¿No tienes cuenta? Regístrate',
        style: TextStyle(
          color: Color.fromRGBO(35, 150, 230, 1),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
