import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const _apiKey = 'YOUR_GEMINI_API_KEY'; // Move to .env later

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system('''
You are ExamGuru, an expert AI assistant for Indian government exam preparation.
Help students with UPSC, SSC, Railways, Banking, State PSC, Teaching, and Defence exams.
Rules:
- Reply in same language as student (Hindi or English)
- Keep answers concise and practical
- Show step-by-step for math/reasoning problems
- Always end with a practice question to test understanding
- Never give wrong information about exam patterns or eligibility
'''),
    );
  }

  Stream<String> streamResponse(List<Map<String, String>> history, String message) async* {
    final chatHistory = history.map((m) =>
        Content(m['role']!, [TextPart(m['text']!)])
    ).toList();

    final chat   = _model.startChat(history: chatHistory);
    final stream = chat.sendMessageStream(Content.text(message));

    await for (final chunk in stream) {
      yield chunk.text ?? '';
    }
  }
}