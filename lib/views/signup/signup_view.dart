import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/signup/signup_model.dart';

class SignupScreen extends StatelessWidget {
  final String? referralCode;
  const SignupScreen({
    this.referralCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(referralCode: referralCode),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      if (viewModel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            viewModel.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // User Type Selector Slider
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    viewModel.setUserType(UserType.student),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color:
                                        viewModel.userType == UserType.student
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    'Student',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          viewModel.userType == UserType.student
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    viewModel.setUserType(UserType.partner),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color:
                                        viewModel.userType == UserType.partner
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    'Partner',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          viewModel.userType == UserType.partner
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Conditional UI based on user type
                      if (viewModel.userType == UserType.student)
                        _buildStudentSignupForm(context, viewModel)
                      else
                        _buildPartnerSignupForm(context, viewModel),

                      const SizedBox(height: 20),

                      // Toggle between Signup and Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            viewModel.isLogin
                                ? "Don't have an account? "
                                : "Already have an account? ",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: viewModel.toggleAuthMode,
                            child: Text(
                              viewModel.isLogin ? "Sign Up" : "Login",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStudentSignupForm(
      BuildContext context, SignupViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Student Access',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (!viewModel.isLogin)
          TextFormField(
            controller: viewModel.nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onChanged: (value) => viewModel.setName(value),
          ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: viewModel.setEmail,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: viewModel.togglePasswordVisibility,
            ),
          ),
          obscureText: !viewModel.isPasswordVisible,
          onChanged: viewModel.setPassword,
        ),
        if (!viewModel.isLogin) ...[
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  viewModel.isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: viewModel.togglePasswordVisibility,
              ),
            ),
            obscureText: !viewModel.isPasswordVisible,
            onChanged: viewModel.setConfirmPassword,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Referral Code (Optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.card_giftcard),
            ),
            controller: viewModel.referralCodeController,
          ),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => viewModel.submitForm(UserType.student, context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(viewModel.isLogin ? 'Login' : 'Sign Up'),
        ),
        if (viewModel.isLogin) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: viewModel.forgotPassword,
            child: const Text('Forgot Password?'),
          ),
        ],
      ],
    );
  }

  Widget _buildPartnerSignupForm(
      BuildContext context, SignupViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Partner Access',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (!viewModel.isLogin)
          TextFormField(
            controller: viewModel.nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onChanged: (value) => viewModel.setName(value),
          ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: viewModel.setEmail,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: viewModel.togglePasswordVisibility,
            ),
          ),
          obscureText: !viewModel.isPasswordVisible,
          onChanged: viewModel.setPassword,
        ),
        if (!viewModel.isLogin) ...[
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  viewModel.isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: viewModel.togglePasswordVisibility,
              ),
            ),
            obscureText: !viewModel.isPasswordVisible,
            onChanged: viewModel.setConfirmPassword,
          ),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => viewModel.submitForm(UserType.partner, context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(viewModel.isLogin ? 'Login' : 'Sign Up'),
        ),
        if (viewModel.isLogin) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: viewModel.forgotPassword,
            child: const Text('Forgot Password?'),
          ),
        ],
      ],
    );
  }
}
