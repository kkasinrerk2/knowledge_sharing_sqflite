import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_sharing_sqlflite/screen/todo_screen.dart';
import 'package:knowledge_sharing_sqlflite/service/local_todo_service.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter sqlflite Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black26),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    ref.read(localTodoServiceProvider).initializeDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const TodoScreen();
  }

}
