import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  // ⚙️ Tu API Key de Gemini (debes tenerla activa)
  static const String _apiKey = 'AIzaSyAD_sPdjXwI2I_p-l6c2jU_JKkYMvQIaSc'; // ← Reemplaza con la tuya

  static GenerativeModel? _cachedModel;
  bool _modelInitialized = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();

    // Espera que el widget se monte antes de inicializar el modelo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAI();
    });
  }

  /// ✅ Inicializa o recupera el modelo en caché
  Future<void> _initializeAI() async {
    if (_cachedModel != null) {
      setState(() => _modelInitialized = true);
      return;
    }

    if (_apiKey.isEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text:
              '⚠️ No se detectó una API Key.\nConfigúrala en Google AI Studio: https://aistudio.google.com/app/apikey',
          isUser: false,
        ));
      });
      return;
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash', // Modelo rápido y gratuito
        apiKey: _apiKey,
        generationConfig:  GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );

      // Test de conexión rápido
      final test = await model.generateContent([Content.text('Hola')]);
      if (test.text == null) throw Exception('Respuesta vacía del modelo.');

      // ✅ Guardar en caché global
      _cachedModel = model;
      setState(() => _modelInitialized = true);

      Fluttertoast.showToast(
        msg: '✅ IA inicializada correctamente.',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text:
              '❌ No se pudo inicializar la IA.\nVerifica tu conexión o API Key.\n\nDetalles: ${e.toString()}',
          isUser: false,
        ));
      });
    }
  }

  /// 🗨️ Mensaje de bienvenida inicial
  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: '👋 ¡Hola! Soy tu asistente de la lengua Inga.\n\n'
            'Puedo ayudarte a:\n'
            '• Traducir palabras (Español ↔ Inga)\n'
            '• Explicar gramática y pronunciación\n'
            '• Dar ejemplos de uso\n'
            '• Compartir aspectos culturales del pueblo Inga\n\n'
            '¿Qué deseas aprender hoy?',
        isUser: false,
      ));
    });
  }

  /// 📤 Envía el mensaje del usuario y obtiene la respuesta del modelo
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isLoading = true;
    });

    if (!_modelInitialized || _cachedModel == null) {
      setState(() {
        _messages.add(ChatMessage(
          text:
              '❌ La IA no está lista todavía.\nEspera unos segundos o revisa tu API Key.',
          isUser: false,
        ));
        _isLoading = false;
      });
      return;
    }

    try {
      final prompt = '''
Eres un asistente experto en la lengua Inga (Inga Kichwa) de Colombia.
Tu tarea es responder de forma educativa, respetuosa y culturalmente precisa.

Usuario pregunta: "$userMessage"

Por favor, responde en un tono amable y claro.
Si se solicita traducción, proporciona tanto la palabra Inga como su pronunciación y contexto.
''';

      final response =
          await _cachedModel!.generateContent([Content.text(prompt)]);

      if (response.text != null && response.text!.isNotEmpty) {
        setState(() {
          _messages.add(ChatMessage(text: response.text!, isUser: false));
        });
      } else {
        throw Exception('Sin respuesta del modelo.');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        backgroundColor: Colors.red,
      );
      setState(() {
        _messages.add(ChatMessage(
          text: '⚠️ Ocurrió un error al procesar tu solicitud.',
          isUser: false,
        ));
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 🪄 Acciones rápidas
  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Acciones Rápidas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildQuickAction(
              icon: Icons.translate,
              title: 'Traducir palabra',
              subtitle: 'Español → Inga',
              query: '¿Cómo se dice "agua" en Inga?',
            ),
            _buildQuickAction(
              icon: Icons.record_voice_over,
              title: 'Pronunciación',
              subtitle: 'Aprender cómo se pronuncia',
              query: '¿Cómo se pronuncia la palabra "allpa"?',
            ),
            _buildQuickAction(
              icon: Icons.lightbulb,
              title: 'Ejemplo de uso',
              subtitle: 'Oraciones comunes',
              query: 'Dame ejemplos de saludos en Inga',
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required String query,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.indigo.shade100,
        child: Icon(icon, color: Colors.indigo),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.pop(context);
        _messageController.text = query;
      },
    );
  }

  /// 💬 Burbujas de chat
  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            const CircleAvatar(
              backgroundColor: Colors.indigo,
              radius: 16,
              child: Icon(Icons.psychology, color: Colors.white, size: 18),
            ),
          if (!message.isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.indigo
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
          if (message.isUser)
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 16,
              child: const Icon(Icons.person, size: 18),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              border: Border(bottom: BorderSide(color: Colors.indigo.shade200)),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology, color: Colors.indigo, size: 32),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Asistente IA - Lengua Inga',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tips_and_updates),
                  onPressed: _showQuickActions,
                ),
              ],
            ),
          ),
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('Inicia una conversación'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text('Pensando...', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: const Offset(0, -1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Escribe tu pregunta...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    mini: true,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}
