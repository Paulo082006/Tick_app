// lib/credits_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Não foi possível abrir o link $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        title: const Text(
          'Sobre o Tick App', 
          style: TextStyle(
            color: Colors.red, 
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white, 
        iconTheme: const IconThemeData(color: Colors.red), 
        elevation: 1, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                const Text(
                  'Tick App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Versão 1.0.0',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const Divider(height: 40),

               
                const Text(
                  'Desenvolvido por:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Paulo Gabriel, Levi Arcanjo e Vínicius / Tick interprise ILP',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Tecnologias
                const Text(
                  'Construído com:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  '• Flutter (Framework UI)\n'
                  '• Dart (Linguagem de Programação)\n'
                  '• shared_preferences (Persistência de dados)\n'
                  '• intl (Formatação de moeda)\n'
                  ,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Atribuições e Licenças 
                const Text(
                  'Atribuições:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () => _launchUrl('https://fonts.google.com/icons'), // Exemplo de link
                  child: const Text(
                    'Ícones: Google Material Icons',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                 TextButton(
                  onPressed: () => _launchUrl('https://pub.dev/packages/shared_preferences'),
                  child: const Text(
                    'shared_preferences (Licença BSD)',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),

                // Feedback/Contato
                const Text(
                  'Feedback e Sugestões:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () => _launchUrl('mailto:tickcontato@gmail.com?subject=Feedback Tick App'),
                  child: const Text(
                    'tickcontato@gmail.com',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 30),

                // Copyright
                const Center(
                  child: Text(
                    '© 2024 Paulo Gabriel, Levi Arcanjo e Vínicius / Tick interprise ILP. Todos os direitos reservados.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}