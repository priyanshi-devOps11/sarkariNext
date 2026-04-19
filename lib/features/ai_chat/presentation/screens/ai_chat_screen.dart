import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/theme/app_colors.dart';

// ── Gemini service (inline for simplicity) ───────────────────────────────────
class _GeminiService {
  // 🔑 Replace with your actual Gemini API key
  // Get it free at: https://aistudio.google.com/app/apikey
  static const _apiKey = 'YOUR_GEMINI_API_KEY';

  late final GenerativeModel _model;

  _GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system('''
You are ExamGuru, an expert AI assistant for Indian government exam preparation.
Help students with UPSC, SSC, Railways, Banking, State PSC, Teaching, and Defence exams.
Rules:
- Reply in the same language the student uses (Hindi or English)
- Keep answers concise and practical
- Show step-by-step working for math/reasoning problems
- Always end with a short practice question to test understanding
- Never give wrong information about exam patterns or eligibility
- Use bullet points and numbered lists for clarity
'''),
    );
  }

  Stream<String> streamResponse(
      List<Content> history, String message) async* {
    final chat   = _model.startChat(history: history);
    final stream = chat.sendMessageStream(Content.text(message));
    await for (final chunk in stream) {
      yield chunk.text ?? '';
    }
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});
  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _controller       = TextEditingController();
  final _scrollController = ScrollController();
  final _gemini           = _GeminiService();

  // Gemini conversation history (Content objects)
  final List<Content> _geminiHistory = [];

  // UI messages
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! I\'m ExamGuru 🤖 — your AI study assistant for Indian government exams.\n\nI can help you with syllabus, study plans, previous year questions, and more!\n\nHow can I help you today?',
      'sender': 'ai',
      'time': DateTime.now(),
      'isStreaming': false,
    }
  ];

  bool _isTyping = false;

  final List<String> _suggestedPrompts = [
    'Best books for SSC CGL',
    'UP Police syllabus 2026',
    'Make me a 3-month study plan',
    'Current affairs tips',
  ];

  // ── Send message ─────────────────────────────────────────────────────────
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'sender': 'user',
        'time': DateTime.now(),
        'isStreaming': false,
      });
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    // Add streaming placeholder for AI response
    final aiMsgIndex = _messages.length;
    setState(() {
      _messages.add({
        'text': '',
        'sender': 'ai',
        'time': DateTime.now(),
        'isStreaming': true,
      });
    });

    String fullResponse = '';

    try {
      await for (final chunk
      in _gemini.streamResponse(_geminiHistory, text)) {
        fullResponse += chunk;
        if (mounted) {
          setState(() {
            _messages[aiMsgIndex]['text'] = fullResponse;
            _isTyping = false;
          });
          _scrollToBottom();
        }
      }

      // Save to Gemini history for context
      _geminiHistory.addAll([
        Content.text(text),
        Content('model', [TextPart(fullResponse)]),
      ]);

      if (mounted) {
        setState(() => _messages[aiMsgIndex]['isStreaming'] = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages[aiMsgIndex]['text'] =
          'Sorry, I ran into an error. Please check your internet connection and try again.';
          _messages[aiMsgIndex]['isStreaming'] = false;
          _isTyping = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary]),
          ),
        ),
        title: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentDark]),
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ExamGuru AI',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Powered by Gemini',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ]),
        actions: [
          // Clear chat button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            tooltip: 'Clear chat',
            onPressed: () {
              setState(() {
                _messages.clear();
                _geminiHistory.clear();
                _messages.add({
                  'text': 'Chat cleared! How can I help you?',
                  'sender': 'ai',
                  'time': DateTime.now(),
                  'isStreaming': false,
                });
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length
                  + (_isTyping ? 1 : 0)
                  + (_messages.length == 1 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return _buildMessage(_messages[index]);
                }
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                if (!_isTyping && _messages.length == 1 && index == 1) {
                  return _buildSuggestedPrompts();
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  // ── Message bubble ────────────────────────────────────────────────────────
  Widget _buildMessage(Map<String, dynamic> msg) {
    final isUser      = msg['sender'] == 'user';
    final isStreaming = msg['isStreaming'] as bool;
    final text        = msg['text'] as String;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isUser ? AppColors.accent : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft:     const Radius.circular(18),
            topRight:    const Radius.circular(18),
            bottomLeft:  Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4  : 18),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show cursor if still streaming
            text.isEmpty && isStreaming
                ? const SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primaryDark))
                : Text(
              text + (isStreaming ? '▌' : ''),
              style: TextStyle(
                fontSize: 14,
                color: isUser ? Colors.white : AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(msg['time'] as DateTime),
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Typing indicator ──────────────────────────────────────────────────────
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => _BouncingDot(delay: i * 200)),
        ),
      ),
    );
  }

  // ── Suggested prompts ─────────────────────────────────────────────────────
  Widget _buildSuggestedPrompts() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(children: [
        const Text('Suggested Questions',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _suggestedPrompts.map((p) => GestureDetector(
            onTap: () => _sendMessage(p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)
                ],
              ),
              child: Text(p,
                  style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
          )).toList(),
        ),
      ]),
    );
  }

  // ── Input area ────────────────────────────────────────────────────────────
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          12, 10, 12, 10 + MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: SafeArea(
        child: Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    maxLines: 3,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything about exams...',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () => _sendMessage(_controller.text),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.mic_outlined,
                color: AppColors.primaryDark, size: 22),
          ),
        ]),
      ),
    );
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// ── Bouncing dot animation (unchanged) ───────────────────────────────────────
class _BouncingDot extends StatefulWidget {
  final int delay;
  const _BouncingDot({required this.delay});
  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(
        Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width: 8, height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
              color: AppColors.textSecondary, shape: BoxShape.circle),
        ),
      ),
    );
  }
}