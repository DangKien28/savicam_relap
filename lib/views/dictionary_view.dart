import 'package:flutter/material.dart';

class DictionaryView extends StatelessWidget {
  const DictionaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Từ điển vị trí")),
      body: const Center(child: Text("Danh sách các từ khóa macro")),
    );
  }
}