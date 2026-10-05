import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _signUp = false;
  bool _hidePassword = true;
  bool _hideConfirmation = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _switchMode(bool signUp) {
    if (_signUp == signUp) return;
    FocusScope.of(context).unfocus();
    _formKey.currentState?.reset();
    _password.clear();
    _confirmation.clear();
    setState(() {
      _signUp = signUp;
      _hidePassword = true;
      _hideConfirmation = true;
    });
  }

  void _showSetupMessage({bool resetPassword = false}) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(resetPassword ? 'Password help' : 'Coming soon'),
        content: Text(
          resetPassword
              ? 'Password reset will be available when accounts launch.'
              : 'Accounts are still being set up. Your details have not been submitted and no account has been created.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // Replace this local transition with the authentication provider callback.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  void _skip() => Navigator.of(
    context,
  ).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < 360 ? 20 : 28,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Brand(onSkip: _skip),
                  const SizedBox(height: 28),
                  const _ParkingBanner(),
                  const SizedBox(height: 28),
                  Text(
                    _signUp ? 'Start your journey.' : 'Welcome back.',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _signUp
                        ? 'Create an account. Make room for easier parking.'
                        : 'Sign in and take the stress out of parking.',
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppTheme.cream,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _modeButton('Sign in', false),
                        _modeButton('Sign up', true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_signUp) ...[
                            _label('Full name'),
                            TextFormField(
                              key: const ValueKey('name'),
                              controller: _name,
                              textCapitalization: TextCapitalization.words,
                              autofillHints: const [AutofillHints.name],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: 'Enter your full name',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: (value) => value!.trim().isEmpty
                                  ? 'Enter your name.'
                                  : null,
                            ),
                            const SizedBox(height: 18),
                          ],
                          _label('Email address'),
                          TextFormField(
                            key: const ValueKey('email'),
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: 'you@example.com',
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                            ),
                            validator: (value) =>
                                RegExp(
                                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                ).hasMatch(value!.trim())
                                ? null
                                : 'Enter a valid email address.',
                          ),
                          const SizedBox(height: 18),
                          _label('Password'),
                          TextFormField(
                            key: const ValueKey('password'),
                            controller: _password,
                            obscureText: _hidePassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            autofillHints: [
                              _signUp
                                  ? AutofillHints.newPassword
                                  : AutofillHints.password,
                            ],
                            textInputAction: _signUp
                                ? TextInputAction.next
                                : TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (!_signUp) _submit();
                            },
                            decoration: InputDecoration(
                              hintText: _signUp
                                  ? 'At least 8 characters'
                                  : 'Enter your password',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                tooltip: _hidePassword
                                    ? 'Show password'
                                    : 'Hide password',
                                onPressed: () => setState(
                                  () => _hidePassword = !_hidePassword,
                                ),
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your password.';
                              }
                              if (_signUp && value.length < 8) {
                                return 'Use at least 8 characters.';
                              }
                              return null;
                            },
                          ),
                          if (_signUp) ...[
                            const SizedBox(height: 18),
                            _label('Confirm password'),
                            TextFormField(
                              key: const ValueKey('confirmation'),
                              controller: _confirmation,
                              obscureText: _hideConfirmation,
                              enableSuggestions: false,
                              autocorrect: false,
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                hintText: 'Re-enter your password',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  tooltip: _hideConfirmation
                                      ? 'Show confirmation'
                                      : 'Hide confirmation',
                                  onPressed: () => setState(
                                    () =>
                                        _hideConfirmation = !_hideConfirmation,
                                  ),
                                  icon: Icon(
                                    _hideConfirmation
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Confirm your password.'
                                  : value != _password.text
                                  ? 'Passwords do not match.'
                                  : null,
                            ),
                          ] else
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    _showSetupMessage(resetPassword: true),
                                child: const Text('Forgot password?'),
                              ),
                            ),
                          SizedBox(height: _signUp ? 24 : 8),
                          FilledButton(
                            key: const ValueKey('submit'),
                            onPressed: _submit,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    _signUp ? 'Create account' : 'Sign in',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        _signUp
                            ? 'Already have an account?'
                            : 'New to AI Parking?',
                      ),
                      TextButton(
                        onPressed: () => _switchMode(!_signUp),
                        child: Text(_signUp ? 'Sign in' : 'Create an account'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'LESS SEARCHING. MORE LIVING.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w600),
    ),
  );

  Widget _modeButton(String text, bool signUp) {
    final selected = _signUp == signUp;
    return Expanded(
      child: Semantics(
        selected: selected,
        child: TextButton(
          onPressed: () => _switchMode(signUp),
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 46),
            backgroundColor: selected ? Colors.white : Colors.transparent,
            foregroundColor: selected ? AppTheme.brown : AppTheme.muted,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppTheme.brown,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.local_parking_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      const SizedBox(width: 12),
      const Flexible(
        child: Text(
          'AI Parking',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.ink,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
      ),
      const Spacer(),
      TextButton.icon(
        onPressed: onSkip,
        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
        label: const Text('Skip'),
        style: TextButton.styleFrom(
          foregroundColor: AppTheme.brown,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      ),
    ],
  );
}

class _ParkingBanner extends StatelessWidget {
  const _ParkingBanner();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: AppTheme.cream,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppTheme.border),
    ),
    child: Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A SMARTER WAY TO PARK',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.brown,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Park easy.\nMove freely.',
                style: TextStyle(
                  fontSize: 25,
                  height: 1.15,
                  letterSpacing: -0.6,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your next stop, simplified.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        ExcludeSemantics(
          child: SizedBox(
            width: 86,
            height: 118,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 98,
                  decoration: BoxDecoration(
                    color: AppTheme.sand.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                Transform.rotate(
                  angle: -0.12,
                  child: Container(
                    width: 66,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.sand, width: 2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.directions_car_filled_rounded,
                      size: 44,
                      color: AppTheme.brown,
                    ),
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.location_on_rounded,
                    color: AppTheme.brown,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
