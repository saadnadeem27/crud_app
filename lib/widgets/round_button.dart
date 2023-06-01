import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final bool isLoading;
  final String title;
  final VoidCallback onTap;
  const RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(width: 2, color: Color.fromARGB(255, 77, 7, 241))),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
      ),
    );
  }
}
