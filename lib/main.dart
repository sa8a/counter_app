import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// データを守るため countProvider という壁を作る
final countProvider = StateProvider<int>((ref) => 0);
// グローバルに定義して良いの？と思われるかもしれませんが、問題有りません。
// 値の保存自体はローカルのスコープ内で行っています。
// プロバイダ自体は不変（イミュータブル）であり、関数をグローバルで宣言しているのと変わりないためです。
// https://riverpod.dev/ja/docs/concepts/providers/

void main() {
  // プロバイダースコープで囲む
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

// プロバイダで値を参照するWidgetをConsumerWidgetを継承したWidgetに書き換え
// （int _counter = 0;を削除、StatefulWidgetをStatelessWidgetに書き換え、
// StatelessWidgetをConsumerWidgetに置き換えます。）
class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  // ConsumerWidgetを使ったらWidgetRef refを必ず書き、refという鍵を手に入れる
  // これでプロバイダを参照する準備ができる
  Widget build(BuildContext context, WidgetRef ref) {
    // データを見張っておく
    // プロバイダの値に変更があった場合、この値に依存するWidgetの更新が行われる
    // ref.watch(countProvider)

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('First Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('ボタンを押した回数'),
                Text(
                  '${ref.watch(countProvider)}',
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const MySecondPage()),
                  ),
                );
              },
              child: const Text('次のページ'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(countProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MySecondPage extends ConsumerWidget {
  const MySecondPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('ボタンを押した回数'),
                Text(
                  '${ref.watch(countProvider)}',
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('前のページ'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(countProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
