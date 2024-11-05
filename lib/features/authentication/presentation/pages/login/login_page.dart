// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../../../injection_container.dart';
import '../../bloc/user_bloc.dart';
import '../../bloc/user_event.dart';
import '../../bloc/user_state.dart';
import '../recovery/recovery_secret_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  String? _secret;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();

    _userNameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _userNameController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _userNameController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _navigateToRecoverySecret() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecoverySecretPage(
          userName: _userNameController.text,
          password: _passwordController.text,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _secret = result as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserBloc>(),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/login_image.png',
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                ),
                BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is SecretMissingState) {
                      _navigateToRecoverySecret();
                    } else if (state is FailureState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message!)),
                      );
                    } else if (state is LoginSuccess) {
                      context.pushNamed('home');
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _userNameController,
                            style: const TextStyle(color: Colors.black87),
                            cursorColor: Colors.grey.shade700,
                            decoration: InputDecoration(
                              labelText: 'Nome do Usuário',
                              labelStyle: TextStyle(color: Colors.grey.shade500),
                              filled: true,
                              fillColor: const Color(0xFFF8F8FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black87),
                            cursorColor: Colors.grey.shade700,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              labelStyle: TextStyle(color: Colors.grey.shade500),
                              filled: true,
                              fillColor: const Color(0xFFF8F8FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7A5D3E),
                                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              onPressed: (state is! LoadingState && isButtonEnabled)
                                  ? () {
                                context.read<UserBloc>().add(LogInEvent(
                                  userName: _userNameController.text,
                                  password: _passwordController.text,
                                  secret: _secret ?? '',
                                ));
                              }
                                  : null,
                              child: state is LoadingState
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextButton(
                onPressed: _navigateToRecoverySecret,
                child: const Text(
                  'Esqueci a senha',
                  style: TextStyle(
                    color: Color(0xFF7A5D3E),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
