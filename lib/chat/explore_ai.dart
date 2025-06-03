import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = """
🌟 مرحباً بك في مساعد Explore PC! 🌟

أنا هنا لمساعدتك في كل ما يتعلق بالحواسيب وتقنية المعلومات. إليك ما يمكنني تقديمه:

💻 استشارات الشراء
- مقارنة بين المواصفات
- نصائح حسب ميزانيتك
- أحدث الإصدارات في السوق

🔧 استكشاف الأخطاء
- مشاكل النظام والبرامج
- أعطال العتاد الصلب
- مشاكل الاتصال والشبكات

⚡ تحسين الأداء
- ترقيات مقترحة
- تنظيف النظام
- إعدادات التحسين

🛠️ الصيانة والرعاية
- نصائح العناية بالجهاز
- تنظيف المكونات الداخلية
- إطالة عمر الجهاز

كيف يمكنني مساعدتك اليوم؟
""";

    setState(() {
      _messages.add(
        ChatMessage(
          text: welcomeMessage,
          isUser: false,
          timestamp: DateTime.now(),
          isWelcomeMessage: true,
        ),
      );
    });
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    if (!await _checkInternet()) {
      _showError("لا يوجد اتصال بالإنترنت");
      return;
    }

    final message = _messageController.text;
    setState(() {
      _messages.add(
        ChatMessage(text: message, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      final response = await _getAIResponse(message);
      setState(() {
        _messages.add(
          ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
        );
      });
    } catch (e) {
      _showError("حدث خطأ: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<String> _getAIResponse(String prompt) async {
    final _apiKey =
        "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";
    const model = "gpt-3.5-turbo";
    final response = await http.post(
      Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
        "HTTP-Referer": "YOUR_SITE_URL",
        "X-Title": "Explore PC App",
      },
      body: jsonEncode({
        "model": model,
        "messages": [
          {
            "role": "system",
            "content":
                "You are an Arabic-speaking PC expert. Always respond in clear Arabic.",
          },
          {"role": "user", "content": prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(responseBody);
      return jsonResponse["choices"][0]["message"]["content"];
    } else {
      throw Exception("خطأ في الاتصال بالخادم");
    }
  }

  void _showError(String message) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: "⚠️ $message",
          isUser: false,
          timestamp: DateTime.now(),
          showRetry: true,
        ),
      );
    });
    _scrollToBottom();
  }

  void _retryLastMessage() {
    if (_messages.isNotEmpty && _messages.last.showRetry) {
      for (int i = _messages.length - 2; i >= 0; i--) {
        if (_messages[i].isUser) {
          setState(() {
            _messageController.text = _messages[i].text;
          });
          _sendMessage();
          setState(() {
            _messages.removeLast();
            _messages.removeAt(i);
          });
          break;
        }
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("مسح المحادثة"),
        content: const Text("هل تريد مسح كل سجل المحادثة؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              setState(() => _messages.clear());
              Navigator.pop(context);
              _addWelcomeMessage();
            },
            child: const Text("مسح", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مساعد Explore PC"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: 24,
              color: Colors.red,
            ),
            onPressed: _clearChat,
            tooltip: "مسح المحادثة",
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF5F7FA), Color(0xFFE8EAF6)],
                    ),
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _messages[index],
                  ),
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LoadingBubble(),
                ),
              _buildMessageInput(),
            ],
          ),
          // Positioned(
          //   bottom: 100,
          //   left: 16,
          //   child: FloatingActionButton(
          //     onPressed: () {},
          //     backgroundColor: Colors.blue,
          //     child: const Icon(Icons.abc, color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        decoration: const InputDecoration(
                          hintText: "اكتب سؤالك عن الحواسيب...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool showRetry;
  final bool isWelcomeMessage;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.showRetry = false,
    this.isWelcomeMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isWelcomeMessage ? 24.0 : 8.0,
        bottom: 8.0,
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (isWelcomeMessage) _buildWelcomeHeader(),
          Container(
            decoration: BoxDecoration(
              color: isWelcomeMessage
                  ? Colors.blue[50]
                  : isUser
                      ? Colors.blue
                      : Colors.white,
              borderRadius: _getBorderRadius(),
              border: isWelcomeMessage
                  ? Border.all(color: Colors.blue[100]!)
                  : null,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.grey[800],
                    fontSize: isWelcomeMessage ? 15 : 14,
                    height: 1.6,
                  ),
                ),
                if (!isWelcomeMessage) _buildMessageFooter(context),
              ],
            ),
          ),
          if (showRetry) _buildRetryButton(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue,
          child: Icon(Icons.computer, size: 30, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          'مساعد Explore PC',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMessageFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUser ? Icons.person : Icons.computer,
            size: 14,
            color: isUser
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(255, 1, 124, 255),
          ),
          const SizedBox(width: 4),
          Text(
            DateFormat('hh:mm a').format(timestamp),
            style: TextStyle(
              color: isUser
                  ? const Color.fromARGB(179, 255, 255, 255)
                  : Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    final state = context.findAncestorStateOfType<_ChatScreenState>();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: state?._retryLastMessage,
        child: Text(
          "إعادة المحاولة",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius() {
    if (isWelcomeMessage) {
      return BorderRadius.circular(12);
    }
    return BorderRadius.only(
      topLeft: Radius.circular(isUser ? 12 : 4),
      topRight: Radius.circular(isUser ? 4 : 12),
      bottomLeft: const Radius.circular(12),
      bottomRight: const Radius.circular(12),
    );
  }
}

class LoadingBubble extends StatelessWidget {
  const LoadingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: SpinKitSquareCircle(
                size: 50.0,
                color: Mycolors().myColor,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "جاري تحضير الإجابة...",
              style: TextStyle(color: Color(0xFF666666), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
