import 'package:dagugi_acessorios/src/firebase/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final phoneFormatter = MaskTextInputFormatter(
    mask: '## # ####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );
  
  void _signUp() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String name = _nameController.text.trim();
    final String phonenumber = _phonenumberController.text.trim();
    final String cpf = _cpfController.text.trim();
    
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty && phonenumber.isNotEmpty && cpf.isNotEmpty) {
      User? user = await _authService.signUpWith(email, password, name, phonenumber, cpf);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Inscrição realizada com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falha no cadastro. Tente novamente.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, insira seu e-mail e senha.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscrever-se'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail', prefixIcon : const Icon(Icons.email)),
            ),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome', prefixIcon : const Icon(Icons.person)),
            ),
            TextField(
              controller: _phonenumberController,
              decoration: InputDecoration(labelText: 'Celular', prefixIcon : const Icon(Icons.phone)),
              inputFormatters: [phoneFormatter],
            ),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF', prefixIcon : const Icon(Icons.file_copy)),
              inputFormatters: [cpfFormatter],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Inscrever-se'),
            ),
          ],
        ),
      ),
    );
  }
}