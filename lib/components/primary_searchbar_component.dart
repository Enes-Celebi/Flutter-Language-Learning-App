import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged; // Add this line
  final VoidCallback? onSearchPressed; // Make this nullable if it's not always needed
  final VoidCallback? onArrowPressed; // Make this nullable if it's not always needed

  const MySearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.onChanged, // Add this line
    this.onSearchPressed, // Make this nullable
    this.onArrowPressed, // Make this nullable
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SizedBox(
        height: 40,  // Thinner height
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(fontSize: 14),  // Adjusted font size
          onChanged: onChanged, // Use onChanged callback
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            prefixIcon: onSearchPressed != null ? IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              onPressed: onSearchPressed,
            ) : null,
            suffixIcon: onArrowPressed != null ? IconButton(
              icon: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary),
              onPressed: onArrowPressed,
            ) : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          ),
        ),
      ),
    );
  }
}
