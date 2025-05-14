import 'package:flutter/material.dart';

class FormRegister extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameComtroller;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function() onSubmit;
  final Function() onLoginPressed;
  final bool isLoading;

  const FormRegister({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onLoginPressed,
    this.isLoading = false,
    required this.nameComtroller,
  });

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _nameIsFocus = false;
  bool _emailIsFocus = false;
  bool _passwordIsFocus = false;
  bool _ocultarPassword = true;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(_updateNameFocus);
    _emailFocus.addListener(_updateEmailFocus);
    _passwordFocus.addListener(_updatePasswordFocus);
  }

  void _updateNameFocus() => setState(() {
    _nameIsFocus = _nameFocus.hasFocus;
  });
  void _updateEmailFocus() => setState(() {
    _emailIsFocus = _emailFocus.hasFocus;
  });
  void _updatePasswordFocus() => setState(() {
    _passwordIsFocus = _passwordFocus.hasFocus;
  });

  @override
  void dispose() {
    _nameFocus.dispose();
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
          _buildNameField(),
          SizedBox(height: 20),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 30),
          _registerButton(),
          const SizedBox(height: 15),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: widget.nameComtroller,
      focusNode: _nameFocus,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          Icons.supervised_user_circle,
          color:
              _nameIsFocus
                  ? const Color.fromRGBO(35, 150, 230, 1)
                  : Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(35, 150, 230, 1)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: widget.emailController,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
          color:
              _emailIsFocus
                  ? const Color.fromRGBO(35, 150, 230, 1)
                  : Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(35, 150, 230, 1)),
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
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          color:
              _passwordIsFocus
                  ? const Color.fromRGBO(35, 150, 230, 1)
                  : Colors.black,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _ocultarPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => setState(() => _ocultarPassword = !_ocultarPassword),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(35, 150, 230, 1)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _registerButton() {
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
                  'Crear Cuenta',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
      ),
    );
  }

  Widget _loginButton() {
    return TextButton(
      onPressed: widget.onLoginPressed,
      child: Text(
        '¿Ya tienes cuenta? Inicia Sesión',
        style: TextStyle(
          color: Color.fromRGBO(35, 150, 230, 1),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
