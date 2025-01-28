import 'package:flutter/material.dart';
import '../home/home.dart';
import '../splash.dart'; // Import your SplashscreenWidget



class TermsOfServiceDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Ensure the dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return TermsOfServiceDialogContent();
      },
    );
  }
}

class TermsOfServiceDialogContent extends StatefulWidget {
  @override
  _TermsOfServiceDialogContentState createState() =>
      _TermsOfServiceDialogContentState();
}

class _TermsOfServiceDialogContentState
    extends State<TermsOfServiceDialogContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkIfScrolledToBottom);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfScrolledToBottom);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkIfScrolledToBottom() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isAtBottom = true;
      });
    }
  }

  // Function to navigate to the splash screen and reopen the Terms of Service dialog
  void _goToSplashAndReopenDialog() async {
    Navigator.of(context).pop(); // Close the current dialog

    // Navigate to the splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashscreenWidget()),
    );

    await Future.delayed(const Duration(seconds: 4)); // Show splash screen for 4 seconds

    // After splash screen delay, reopen the Terms of Service dialog
    TermsOfServiceDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Container(
        width: 500,
        constraints: const BoxConstraints(
          maxHeight: 600,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: const Text(
                'Terms of Service',
                style: TextStyle(
                  color: Color(0xFF2B8960),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: Termsofservices(),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _goToSplashAndReopenDialog(); // Navigate back to splash screen and reopen
                    },
                    child: const Text('Decline'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF2B8960),
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(width: 1, color: Color(0xFF2B8960)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isAtBottom
                        ? () {
                      Navigator.of(context).pop(); // Close the dialog first

                      // Navigate to HomeScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    }
                        : null,
                    child: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _isAtBottom
                          ? const Color(0xFF2B8960)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Termsofservices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '1. Acceptance of Terms\n\n'
                'By accessing or using our services, you agree to comply with these terms. If you do not agree, please do not use our services.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          Text(
            '2. Changes to Terms\n\n'
                'We reserve the right to modify these terms at any time. Changes will be effective upon posting. Please review these terms periodically.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          Text(
            '3. User Responsibilities\n\n'
                'You are responsible for your use of the services and any content you create or share. Please ensure that your use complies with applicable laws.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          Text(
            '4. Limitation of Liability\n\n'
                'We are not liable for any damages resulting from your use of our services, including indirect or consequential damages.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          Text(
            '5. Governing Law\n\n'
                'These terms are governed by the laws of [Your Country/State]. Any disputes will be resolved in accordance with these laws.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
