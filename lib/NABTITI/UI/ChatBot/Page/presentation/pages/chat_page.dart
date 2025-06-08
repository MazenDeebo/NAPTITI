import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../Home/Page/Home.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';


class ChatPage extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int c=0;
    final messages = ref.watch(chatProvider);

    return Scaffold(

      appBar: AppBar(
        title: Text(S().AIChat),
        leading: IconButton(
            onPressed: (){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home()
                  )
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: S().typeMessage,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    ref.read(chatProvider.notifier).sendMessage(_controller.text);
                    _controller.clear();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}