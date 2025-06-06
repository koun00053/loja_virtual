import 'package:dagugi_acessorios/src/auth/components/custom_text_field.dart';
import 'package:dagugi_acessorios/src/config/app_data.dart' as appData;
import 'package:dagugi_acessorios/src/firebase/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil do usuário',
          style: TextStyle(fontFamily: 'Garamond'),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen())
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: [
          CustomTextField(
            readOnly: true,
            initialValue: appData.user.name,
            icon: Icons.person,
            label: 'Nome',
            controller: null,
          ),
          CustomTextField(
            readOnly: true,
            initialValue: appData.user.email,
            icon: Icons.email,
            label: 'Email',
            controller: null,
            // initialValue: appData.user.email,
          ),
          CustomTextField(
            readOnly: true,
            initialValue: appData.user.phone,
            icon: Icons.phone,
            label: 'Celular',
            controller: null,
          ),
          CustomTextField(
            readOnly: true,
            initialValue: appData.user.cpf,
            icon: Icons.file_copy,
            label: 'CPF',
            isSecret: true,
            controller: null,
          ),
          //Botão de atualizar senha
          SizedBox(
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                updatePassword();
              },
              child: const Text('Atualizar senha'),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> updatePassword() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Titulo
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Text(
                        'Atualização de Senha',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    //Senha Atual, Nova Senha, Confirmar Senha
                    CustomTextField(
                      controller: _currentPasswordController,
                      isSecret: true,
                      icon: Icons.lock,
                      label: 'Senha Atual',
                    ),
                    CustomTextField(
                      controller : _newPasswordController,
                      isSecret: true,
                      icon: Icons.lock,
                      label: 'Nova Senha',
                    ),
                    CustomTextField(
                      controller : _confirmPasswordController,
                      isSecret: true,
                      icon: Icons.lock,
                      label: 'Confirmar Senha',
                    ),
                    //Botão de Confirmação
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async{
                          final FirebaseAuth _auth = FirebaseAuth.instance;
                          User? user = _auth.currentUser;
                          if (user != null) {
                            changePassword(context);
                          }  
                        },
                        child: const Text(
                          'Atualizar',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Botão de Fechar
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> changePassword(BuildContext context) async {
    const Map<String, String> firebaseAuthErrorMessages = {
      'invalid-email': 'O endereço de e-mail está mal formatado.',
      'invalid-credential' : 'a senha está incorreta',
      'user-not-found': 'Usuário não encontrado.',
      'user-disabled': 'Usuário desativado.',
      'wrong-password': 'A senha atual está incorreta.',
      'email-already-in-use': 'Este e-mail já está em uso por outra conta.',
      'operation-not-allowed': 'Operação não permitida.',
      'weak-password': 'A nova senha é muito fraca.',
      'invalid-action-code': 'Código de ação inválido.',
      'expired-action-code': 'Código de ação expirado.',
      'too-many-requests': 'Muitas solicitações. Tente novamente mais tarde.',
      'network-request-failed': 'Falha na solicitação de rede. Verifique sua conexão.',
      'unknown': 'Ocorreu um erro desconhecido.',
    };

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    // Check if the fields are empty
    if (_currentPasswordController.text.isEmpty || 
        _newPasswordController.text.isEmpty || 
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, preencha todos os campos.')));
      return; // Exit the function if any field is empty
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('As novas senhas não correspondem.')));
      return; // Exit if passwords do not match
    }

    if (user != null) {
      try {
        // Re-authenticate the user
        String email = user.email!;
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: email,
            password: _currentPasswordController.text,
          ),
        );

        // Change the password
        await user.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Senha alterada com sucesso!')));
        Navigator.of(context).pop();
      } catch (e) {
        // Handle re-authentication errors
        if (e is FirebaseAuthException) {
          String? errorMessage = firebaseAuthErrorMessages[e.code];
          if (errorMessage != null)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
          else
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('erro: ${e.message}')));
        } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ocorreu um erro desconhecido.')));
        }
      }
    }
  }
}
