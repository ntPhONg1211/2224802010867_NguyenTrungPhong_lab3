import 'package:flutter/material.dart';
import 'api_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final api = ApiService();

  Future<void> _handleReset(BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await api.resetPassword(emailController.text);

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Thông báo'),
        content: Text(
            success ? "Đã reset password" : "Không tìm thấy email này!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (success) Navigator.pop(ctx);
            },
            child: const Text("Back"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),

              // Icon màu cam
              Image.network(
                "https://cdn-icons-png.flaticon.com/512/2989/2989988.png",
                width: 80,
                height: 80,
                color: Colors.orange,
              ),

              const SizedBox(height: 20),

              // EMAIL
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The field cannot be empty';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              Builder(
                builder: (ctx) => ElevatedButton(
                  onPressed: () => _handleReset(ctx),
                  child: const Text("Reset password"),
                ),
              ),

              const SizedBox(height: 10),

              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
