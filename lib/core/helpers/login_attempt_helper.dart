import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:prufcoach/data/login_lockout.dart';

class LoginManager {
  static const int maxAttempts = 3;
  static const int cooldownSeconds = 60;

  Future<LoginAttempt> _getAttempt() async {
    var box = await Hive.openBox<LoginAttempt>('loginBox');
    return box.get('attempt') ?? LoginAttempt();
  }

  Future<bool> canLogin() async {
    var box = await Hive.openBox<LoginAttempt>('loginBox');
    final attempt = await _getAttempt();

    if (attempt.failedCount < maxAttempts) {
      return true; // still have tries
    }

    if (attempt.lastFailed != null) {
      final diff = DateTime.now().difference(attempt.lastFailed!);
      if (diff.inSeconds >= cooldownSeconds) {
        // reset after cooldown
        attempt.failedCount = 0;
        attempt.lastFailed = null;
        await box.put('attempt', attempt);
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  Future<int> getRemainingCooldown() async {
    final attempt = await _getAttempt();
    if (attempt.failedCount < maxAttempts || attempt.lastFailed == null) {
      return 0;
    }
    final diff = DateTime.now().difference(attempt.lastFailed!);
    final remaining = cooldownSeconds - diff.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  Future<void> registerFailure() async {
    var box = await Hive.openBox<LoginAttempt>('loginBox');
    final attempt = await _getAttempt();

    attempt.failedCount += 1;
    attempt.lastFailed = DateTime.now();

    await box.put('attempt', attempt);
  }

  Future<void> registerSuccess() async {
    var box = await Hive.openBox<LoginAttempt>('loginBox');
    await box.put('attempt', LoginAttempt()); // reset
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginManager _loginManager = LoginManager();
  Timer? _timer;
  int _remaining = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _tryLogin() async {
    final canLogin = await _loginManager.canLogin();
    if (!canLogin) {
      _startCooldown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Too many attempts. Try again in $_remaining s"),
        ),
      );
      return;
    }

    // Dummy check: change this to your API/DB check
    bool success =
        (_emailController.text == "test@test.com" &&
            _passwordController.text == "1234");

    if (success) {
      await _loginManager.registerSuccess();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successful")));
    } else {
      await _loginManager.registerFailure();
      final attempt = await Hive.openBox<LoginAttempt>(
        'loginBox',
      ).then((box) => box.get('attempt') ?? LoginAttempt());

      if (attempt.failedCount >= LoginManager.maxAttempts) {
        _startCooldown();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Too many attempts. Locked for 60s")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Invalid credentials. Attempts: ${attempt.failedCount}/${LoginManager.maxAttempts}",
            ),
          ),
        );
      }
    }
  }

  void _startCooldown() async {
    _remaining = await _loginManager.getRemainingCooldown();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remaining <= 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initCooldown();
  }

  Future<void> _initCooldown() async {
    _remaining = await _loginManager.getRemainingCooldown();
    if (_remaining > 0) {
      _startCooldown();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _remaining > 0 ? null : _tryLogin,
              child: Text(
                _remaining > 0 ? "Try again in $_remaining s" : "Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
