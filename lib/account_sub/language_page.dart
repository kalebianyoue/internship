import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLang = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Language"), backgroundColor: Colors.blue),
      body: ListView(
        children: [
          RadioListTile(
            value: "English",
            groupValue: selectedLang,
            title: const Text("English"),
            onChanged: (val) => setState(() => selectedLang = val.toString()),
          ),
          RadioListTile(
            value: "French",
            groupValue: selectedLang,
            title: const Text("French"),
            onChanged: (val) => setState(() => selectedLang = val.toString()),
          ),
        ],
      ),
    );
  }
}