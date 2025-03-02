import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class SimpleLoginView extends StatelessWidget {
  const SimpleLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.isLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (authViewModel.errorMessage != null) {
          return Scaffold(
            body: Center(child: Text('Error: ${authViewModel.errorMessage}')),
          );
        } else if (authViewModel.user != null) {
          // User is signed in anonymously.
          return Scaffold(
            appBar: AppBar(title: Text('Welcome')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You are signed in anonymously!'),
                  Text('User ID: ${authViewModel.user!.uid}'),
                  SizedBox(height: 20),
                  // In a real app, you might navigate to your main screen.
                  ElevatedButton(
                    onPressed: () {
                      // For example, navigate to the WorkoutHistoryPage.
                      Navigator.pushReplacementNamed(context, '/workoutHistory');
                    },
                    child: Text('Proceed'),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Fallback UI, in case there's no user or an unexpected state.
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  await authViewModel.signInAnonymously();

                },
                child: Text('Login Anonymously'),
              ),
            ),
          );
        }
      },
    );
  }
}
