import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _messageController;
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isBotMessage(index)
                          ? Color.fromARGB(255, 190, 227, 244)
                          : Color.fromRGBO(232, 151, 178, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      _messages[index],
                      style: TextStyle(
                        color:
                            _isBotMessage(index) ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      fillColor: const Color.fromARGB(255, 249, 206, 220),
                      filled: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(' $message');
      });
      _messageController.clear();
      _generateResponse(message); // Call the async function
    }
  }

  Future<void> _generateResponse(String userMessage) async {
    try {
      // Get the API key from environment variables
      final apiKey = const String.fromEnvironment('API_KEY');

      // Check if the API key is empty
      if (apiKey.isEmpty) {
        throw Exception('API_KEY environment variable not set.');
      }

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      final prompt = userMessage;
      final response = await model.generateContent([Content.text(prompt)]);

      setState(() {
        _messages.add(' ${response.text}');
      });
    } catch (e) {
      print('Error: $e'); // Print the error for debugging
      setState(() {
        _messages.add('Sorry, I encountered an error.');
      });
    }
  }

  bool _isBotMessage(int index) {
    return index % 2 == 1;
  }
}
