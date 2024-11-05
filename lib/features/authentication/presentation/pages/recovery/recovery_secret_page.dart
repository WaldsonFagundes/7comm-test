// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../bloc/user_bloc.dart';
import '../../bloc/user_event.dart';
import '../../bloc/user_state.dart';

class RecoverySecretPage extends StatefulWidget {
  final String userName;
  final String password;

  const RecoverySecretPage({super.key, required this.userName, required this.password});

  @override
  State<RecoverySecretPage> createState() => _RecoverySecretPageState();
}

class _RecoverySecretPageState extends State<RecoverySecretPage> {
  final List<TextEditingController> _codeControllers = List.generate(6, (_) => TextEditingController());
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    for (var controller in _codeControllers) {
      controller.addListener(_updateButtonState);
    }
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _codeControllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.removeListener(_updateButtonState);
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<UserBloc>(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is SecretLoadedState) {
              Navigator.pop(context, state.secret);
            } else if (state is FailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Erro ao recuperar o código')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Verificação',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Insira o código que foi enviado:'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                        (index) => _buildCodeBox(context, index),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A5D3E),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: isButtonEnabled
                      ? () {
                    final code = _codeControllers.map((controller) => controller.text).join();
                    context.read<UserBloc>().add(
                      RecoverySecretEvent(
                        userName: widget.userName,
                        password: widget.password,
                        code: code,
                      ),
                    );
                  }
                      : null,
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.chat_bubble_outline, color: Color(0xFF8E6E53)),
                  label: Text(
                    'Não recebi o código',
                    style: TextStyle(color: Color(0xFF8E6E53)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBox(BuildContext context, int index) {
    return Container(
      width: 40,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Center(
        child: TextField(
          controller: _codeControllers[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.length == 1 && index < _codeControllers.length - 1) {
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }
}
