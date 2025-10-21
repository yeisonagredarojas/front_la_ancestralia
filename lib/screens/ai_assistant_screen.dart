import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/palabra_service.dart';
import '../models/palabra.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  
  final PalabraService _palabraService = PalabraService(); // 🧩 conexión con NestJS

  // API Key gratuita de Gemini (reemplaza con tu propia key)
  // Obtén tu key gratis en: https://makersuite.google.com/app/apikey
  static const String _apiKey = 'AIzaSyAD_sPdjXwI2I_p-l6c2jU_JKkYMvQIaSc';
  
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _initializeAI();
    _addWelcomeMessage();
  }

  void _initializeAI() {
  _model = GenerativeModel(
    model: 'gemini-2.5-flash', // <- modelo válido actualmente
    apiKey: _apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.7,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 1024,
    ),
  );
}

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: '¡Hola! Soy tu asistente de la lengua Inga. Puedo ayudarte con:\n\n'
            '• Traducir palabras del español al Inga\n'
            '• Explicar gramática y pronunciación\n'
            '• Crear ejemplos de uso\n'
            '• Responder preguntas sobre la cultura Inga\n\n'
            '¿En qué puedo ayudarte?',
        isUser: false,
      ));
    });
  }

//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;
    
//     final userMessage = _messageController.text;
//     _messageController.clear();

//     setState(() {
//       _messages.add(ChatMessage(text: userMessage, isUser: true));
//       _isLoading = true;
//     });

//     try {
//       // Contexto especial para la lengua Inga
//       final prompt = '''
// Eres un experto en la lengua Inga (Inga Kichwa), una lengua indígena de Colombia.
// Tu objetivo es ayudar a preservar y enseñar esta lengua.

// Contexto importante:
// - El Inga es una variante del Quechua hablada en el departamento de Putumayo, Colombia
// - Es una lengua tonal y aglutinante
// - Usa el alfabeto latino con algunas letras especiales

// Usuario pregunta: $userMessage

// Por favor responde de manera clara, educativa y culturalmente respetuosa.
// ''';

//       final content = [Content.text(prompt)];
//       final response = await _model.generateContent(content);
      
//       if (response.text != null) {
//         setState(() {
//           _messages.add(ChatMessage(
//             text: response.text!,
//             isUser: false,
//           ));
//         });
//       } else {
//         throw Exception('No se recibió respuesta');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Error: ${e.toString()}',
//         backgroundColor: Colors.red,
//       );
//       setState(() {
//         _messages.add(ChatMessage(
//           text: 'Lo siento, ocurrió un error. Por favor intenta de nuevo.',
//           isUser: false,
//         ));
//       });
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }




// Future<void> _sendMessage() async {
//   if (_messageController.text.trim().isEmpty) return;

//   final userMessage = _messageController.text;
//   _messageController.clear();

//   setState(() {
//     _messages.add(ChatMessage(text: userMessage, isUser: true));
//     _isLoading = true;
//   });

//   try {
//     // Contexto de la conversación
//     final chat = _model.startChat(
//       history: _messages
//           .map(
//             (m) => Content.text(m.isUser ? "Usuario: ${m.text}" : "Asistente: ${m.text}"),
//           )
//           .toList(),
//     );

//     // Prompt con contexto cultural y lingüístico
//     final prompt = '''
// Eres un experto en la lengua Inga (Inga Kichwa), hablada en Putumayo, Colombia.
// Tu tarea es enseñar y preservar el idioma mediante explicaciones claras, ejemplos y traducciones.
// Sé respetuoso, educativo y culturalmente preciso.

// Usuario pregunta: $userMessage
// ''';

//     final response = await chat.sendMessage(Content.text(prompt));

//     if (response.text != null) {
//       setState(() {
//         _messages.add(ChatMessage(
//           text: response.text!,
//           isUser: false,
//         ));
//       });
//     } else {
//       throw Exception('No se recibió respuesta del modelo');
//     }
//   } catch (e) {
//     Fluttertoast.showToast(
//       msg: 'Error: ${e.toString()}',
//       backgroundColor: Colors.red,
//     );
//     setState(() {
//       _messages.add(ChatMessage(
//         text: 'Lo siento, ocurrió un error. Intenta de nuevo.',
//         isUser: false,
//       ));
//     });
//   } finally {
//     setState(() => _isLoading = false);
//   }
// }



// //
// ///
// ///
// ///
// ///
// ///


//   void _showQuickActions() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Acciones Rápidas',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildQuickActionButton(
//               icon: Icons.translate,
//               title: 'Traducir palabra',
//               subtitle: 'Español → Inga',
//               onTap: () {
//                 Navigator.pop(context);
//                 _messageController.text = '¿Cómo se dice "agua" en Inga?';
//               },
//             ),
//             _buildQuickActionButton(
//               icon: Icons.record_voice_over,
//               title: 'Pronunciación',
//               subtitle: 'Aprender a pronunciar',
//               onTap: () {
//                 Navigator.pop(context);
//                 _messageController.text = '¿Cómo se pronuncia la palabra "allpa"?';
//               },
//             ),
//             _buildQuickActionButton(
//               icon: Icons.book,
//               title: 'Gramática',
//               subtitle: 'Explicación de reglas',
//               onTap: () {
//                 Navigator.pop(context);
//                 _messageController.text = 'Explícame la estructura de las oraciones en Inga';
//               },
//             ),
//             _buildQuickActionButton(
//               icon: Icons.lightbulb,
//               title: 'Ejemplo de uso',
//               subtitle: 'Oraciones de ejemplo',
//               onTap: () {
//                 Navigator.pop(context);
//                 _messageController.text = 'Dame ejemplos de saludos en Inga';
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActionButton({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Colors.indigo.shade100,
//         child: Icon(icon, color: Colors.indigo),
//       ),
//       title: Text(title),
//       subtitle: Text(subtitle),
//       onTap: onTap,
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Header con info
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.indigo.shade50,
//               border: Border(
//                 bottom: BorderSide(color: Colors.indigo.shade200),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.psychology, color: Colors.indigo, size: 32),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Asistente IA Inga',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         'Powered by Google Gemini',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.tips_and_updates),
//                   onPressed: _showQuickActions,
//                   tooltip: 'Acciones rápidas',
//                 ),
//               ],
//             ),
//           ),

//           // Lista de mensajes
//           Expanded(
//             child: _messages.isEmpty
//                 ? const Center(
//                     child: Text('Inicia una conversación'),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     reverse: true,
//                     itemCount: _messages.length,
//                     itemBuilder: (context, index) {
//                       final message = _messages[_messages.length - 1 - index];
//                       return _buildMessageBubble(message);
//                     },
//                   ),
//           ),

//           // Loading indicator
//           if (_isLoading)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   const SizedBox(width: 16),
//                   const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     'Pensando...',
//                     style: TextStyle(color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//             ),

//           // Input de mensaje
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade300,
//                   offset: const Offset(0, -1),
//                   blurRadius: 4,
//                 ),
//               ],
//             ),
//             child: SafeArea(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: InputDecoration(
//                         hintText: 'Escribe tu pregunta...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 10,
//                         ),
//                       ),
//                       maxLines: null,
//                       textInputAction: TextInputAction.send,
//                       onSubmitted: (_) => _sendMessage(),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   FloatingActionButton(
//                     onPressed: _isLoading ? null : _sendMessage,
//                     mini: true,
//                     child: const Icon(Icons.send),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(ChatMessage message) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         mainAxisAlignment:
//             message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!message.isUser) ...[
//             CircleAvatar(
//               backgroundColor: Colors.indigo,
//               radius: 16,
//               child: const Icon(Icons.psychology, size: 18, color: Colors.white),
//             ),
//             const SizedBox(width: 8),
//           ],
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: message.isUser ? Colors.indigo : Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Text(
//                 message.text,
//                 style: TextStyle(
//                   color: message.isUser ? Colors.white : Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//           if (message.isUser) ...[
//             const SizedBox(width: 8),
//             CircleAvatar(
//               backgroundColor: Colors.grey.shade300,
//               radius: 16,
//               child: const Icon(Icons.person, size: 18),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class ChatMessage {
//   final String text;
//   final bool isUser;

//   ChatMessage({
//     required this.text,
//     required this.isUser,
//   });
// }

/// Enviar mensaje a la IA + integrar palabras desde tu backend
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isLoading = true;
    });

    try {
      // 1️⃣ Obtener palabras desde tu API NestJS
      final List<Palabra> palabras = await _palabraService.getPalabras();
      // final vocabulario = palabras
      //   .map((p) => '${p.palabraInga} (${p.traduccionEspanol})')
      //   .join(', ');
      final vocabulario = palabras
        .map((p) =>
          '${p.palabraInga} (${p.traduccionEspanol}) - Categoría: ${p.categoria ?? "Sin categoría"}')
        .join(', ');

      // 2️⃣ Contexto cultural + palabras del backend
      final chat = _model.startChat(
        history: _messages
            .map((m) => Content.text(
                m.isUser ? "Usuario: ${m.text}" : "Asistente: ${m.text}"))
            .toList(),
      );

      final prompt = '''
Eres un experto en la lengua Inga (Inga del Resguardo Inga de Aponte), hablada en Nariño, Colombia.
Tu función es enseñar, traducir y preservar el idioma con base en el vocabulario oficial de la base de datos del proyecto.

Vocabulario disponible en el sistema:
$vocabulario

Usuario pregunta: $userMessage

Responde de forma educativa, respetuosa y culturalmente precisa.
''';

      final response = await chat.sendMessage(Content.text(prompt));

      if (response.text != null) {
        setState(() {
          _messages.add(ChatMessage(text: response.text!, isUser: false));
        });
      } else {
        throw Exception('No se recibió respuesta del modelo.');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        backgroundColor: Colors.red,
      );
      setState(() {
        _messages.add(ChatMessage(
          text: 'Lo siento, ocurrió un error. Intenta de nuevo.',
          isUser: false,
        ));
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
            const Text(
              'Acciones Rápidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildQuickActionButton(
              icon: Icons.translate,
              title: 'Traducir palabra',
              subtitle: 'Español → Inga',
              onTap: () {
                Navigator.pop(context);
                _messageController.text = '¿Cómo se dice "agua" en Inga?';
              },
            ),
            _buildQuickActionButton(
              icon: Icons.record_voice_over,
              title: 'Pronunciación',
              subtitle: 'Aprender a pronunciar',
              onTap: () {
                Navigator.pop(context);
                _messageController.text =
                    '¿Cómo se pronuncia la palabra "allpa"?';
              },
            ),
            _buildQuickActionButton(
              icon: Icons.book,
              title: 'Gramática',
              subtitle: 'Explicación de reglas',
              onTap: () {
                Navigator.pop(context);
                _messageController.text =
                    'Explícame la estructura de las oraciones en Inga';
              },
            ),
            _buildQuickActionButton(
              icon: Icons.lightbulb,
              title: 'Ejemplo de uso',
              subtitle: 'Oraciones de ejemplo',
              onTap: () {
                Navigator.pop(context);
                _messageController.text = 'Dame ejemplos de saludos en Inga';
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.indigo.shade100,
        child: Icon(icon, color: Colors.indigo),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
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
              border: Border(
                bottom: BorderSide(color: Colors.indigo.shade200),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology, color: Colors.indigo, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Asistente IA Inga',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Powered by Google Gemini',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tips_and_updates),
                  onPressed: _showQuickActions,
                  tooltip: 'Acciones rápidas',
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
                  Text(
                    'Pensando...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
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

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              backgroundColor: Colors.indigo,
              radius: 16,
              child: Icon(Icons.psychology, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.indigo : Colors.grey.shade200,
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
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 16,
              child: const Icon(Icons.person, size: 18),
            ),
          ],
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