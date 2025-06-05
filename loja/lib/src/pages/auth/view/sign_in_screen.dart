import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dagugi_acessorios/src/pages/auth/controller/auth_controller.dart';
import 'package:dagugi_acessorios/src/pages_routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:dagugi_acessorios/src/pages/common_widgets/custom_text_field.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //NOME DO APP
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 40,
                      ),
                      children: [
                        TextSpan(
                          text: 'Dagugi',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GreatVibes',
                          ),
                        ),
                        //ESPAÇAMENTO ENTRE DAGUGI E ACESSÓRIOS
                        TextSpan(
                          text: ' ', // Espaço entre as palavras
                        ),
                        TextSpan(
                          text: 'Acessórios',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Garamond',
                          ),
                        )
                      ],
                    ),
                  ),
                  //CATEGORIAS-animated_text_kit
                  SizedBox(
                    height: 45,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Garamond',
                      ),
                      child: AnimatedTextKit(
                        pause: Duration.zero,
                        repeatForever: true,
                        animatedTexts: [
                          FadeAnimatedText('Anéis'),
                          FadeAnimatedText('Colares'),
                          FadeAnimatedText('Pingentes'),
                          FadeAnimatedText('Braceletes'),
                          FadeAnimatedText('Brincos'),
                          FadeAnimatedText('Alianças'),
                          FadeAnimatedText('Pulseiras'),
                        ],
                      ),
                    ),
                  )
                ],
              )),

              //FORMULÁRIO
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //EMAIL
                      CustomTextField(
                        controller: emailController,
                        icon: Icons.email,
                        label: 'E-mail',
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'Digite seu e-mail';
                          }

                          if (!email.isEmail) return 'Email inválido';

                          return null;
                        },
                      ),
                      //SENHA
                      CustomTextField(
                          controller: passwordController,
                          icon: Icons.lock,
                          label: 'Senha',
                          isSecret: true,
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return 'Digite sua senha';
                            }
                            if (password.length < 8) {
                              return 'Senha deve ter pelo menos 8 caracteres';
                            }

                            return null;
                          }),

                      //BOTÃO ENTRAR
                      SizedBox(
                        height: 50,
                        child: GetX<AuthController>(
                          builder: (controller) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        String email = emailController.text;
                                        String password =
                                            passwordController.text;
                                        controller.signIn(
                                            email: email, password: password);
                                      }
                                    },
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            );
                          },
                        ),
                      ),

                      //ESPAÇAMENTO ENTRE O CAMPO DE ENTRAR E O ESQUECEU A SENHA
                      Padding(
                          padding: const EdgeInsets.only(
                              top:
                                  10)), //ESPAÇAMENTO ENTRE O CAMPO DE ENTRAR E O ESQUECEU A SENHA

                      //ESQUECEU A SENHA
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Esqueceu a senha?',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),

                      //DIVISOR OU
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(100),
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                'OU',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(100),
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //BOTÃO CRIAR CONTA(NOVO USUÁRIO)
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(PagesRouts.signupRoute);
                          },
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
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
