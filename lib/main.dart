import 'package:flutter/material.dart';

void main() {
  runApp(const AirportFeedbackApp());
}

class AirportFeedbackApp extends StatelessWidget {
  const AirportFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Airport Feedback',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _goToSurvey(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuickSurveyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airport Feedback'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.flight_takeoff_rounded,
                size: 90,
                color: Colors.indigo,
              ),
              const SizedBox(height: 20),
              const Text(
                'Bienvenue',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Aidez-nous à améliorer votre expérience à l’aéroport en moins d’une minute.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _goToSurvey(context),
                  child: const Text('Commencer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickSurveyScreen extends StatefulWidget {
  const QuickSurveyScreen({super.key});

  @override
  State<QuickSurveyScreen> createState() => _QuickSurveyScreenState();
}

class _QuickSurveyScreenState extends State<QuickSurveyScreen> {
  int comfortRating = 0;
  int informationRating = 0;
  int cleanlinessRating = 0;
  int signageRating = 0;
  int servicesRating = 0;

  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return comfortRating > 0 &&
        informationRating > 0 &&
        cleanlinessRating > 0 &&
        signageRating > 0 &&
        servicesRating > 0;
  }

  void submitSurvey() {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez noter toutes les catégories.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessScreen(
          comfortRating: comfortRating,
          informationRating: informationRating,
          cleanlinessRating: cleanlinessRating,
          signageRating: signageRating,
          servicesRating: servicesRating,
          finalComment: commentController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = [
      comfortRating,
      informationRating,
      cleanlinessRating,
      signageRating,
      servicesRating,
    ].where((rating) => rating > 0).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini sondage'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.timer_outlined, color: Colors.indigo),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Temps estimé : moins d’une minute',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    LinearProgressIndicator(
                      value: progress / 5,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$progress/5 catégories renseignées',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            RatingCard(
              title: 'Confort',
              subtitle: 'Sièges et confort climatique',
              rating: comfortRating,
              onChanged: (value) {
                setState(() {
                  comfortRating = value;
                });
              },
            ),
            const SizedBox(height: 16),
            RatingCard(
              title: 'Information et orientation',
              subtitle: 'Clarté des informations et aide à l’orientation',
              rating: informationRating,
              onChanged: (value) {
                setState(() {
                  informationRating = value;
                });
              },
            ),
            const SizedBox(height: 16),
            RatingCard(
              title: 'Propreté générale',
              subtitle: 'Espaces publics, toilettes et zones de circulation',
              rating: cleanlinessRating,
              onChanged: (value) {
                setState(() {
                  cleanlinessRating = value;
                });
              },
            ),
            const SizedBox(height: 16),
            RatingCard(
              title: 'Signalisation',
              subtitle: 'Parkings, halls et zones d’embarquement',
              rating: signageRating,
              onChanged: (value) {
                setState(() {
                  signageRating = value;
                });
              },
            ),
            const SizedBox(height: 16),
            RatingCard(
              title: 'Services et commerces',
              subtitle: 'Services disponibles et expérience globale',
              rating: servicesRating,
              onChanged: (value) {
                setState(() {
                  servicesRating = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Commentaire final optionnel',
                    hintText: 'Ajoutez une remarque ou une suggestion...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: submitSurvey,
                icon: const Icon(Icons.send),
                label: const Text('Envoyer'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  final int comfortRating;
  final int informationRating;
  final int cleanlinessRating;
  final int signageRating;
  final int servicesRating;
  final String finalComment;

  const SuccessScreen({
    super.key,
    required this.comfortRating,
    required this.informationRating,
    required this.cleanlinessRating,
    required this.signageRating,
    required this.servicesRating,
    required this.finalComment,
  });

  String ratingLabel(int rating) {
    if (rating == 3) return 'Satisfaisant';
    if (rating == 2) return 'Moyennement satisfaisant';
    return 'Non satisfaisant';
  }

  Widget buildResultTile(String title, int rating) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle_outline, color: Colors.indigo),
      title: Text(title),
      subtitle: Text('${ratingLabel(rating)} ($rating/3)'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 38,
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(
                Icons.check,
                color: Colors.green,
                size: 42,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Merci pour votre participation',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Votre avis a bien été enregistré localement dans cette version de démonstration.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildResultTile('Confort', comfortRating),
                    buildResultTile(
                      'Information et orientation',
                      informationRating,
                    ),
                    buildResultTile(
                      'Propreté générale',
                      cleanlinessRating,
                    ),
                    buildResultTile('Signalisation', signageRating),
                    buildResultTile(
                      'Services et commerces',
                      servicesRating,
                    ),
                    if (finalComment.isNotEmpty) ...[
                      const Divider(height: 28),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Commentaire',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(finalComment),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Retour à l’accueil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int rating;
  final ValueChanged<int> onChanged;

  const RatingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StarButton(
                  filled: rating >= 1,
                  onTap: () => onChanged(1),
                ),
                const SizedBox(width: 12),
                StarButton(
                  filled: rating >= 2,
                  onTap: () => onChanged(2),
                ),
                const SizedBox(width: 12),
                StarButton(
                  filled: rating >= 3,
                  onTap: () => onChanged(3),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                rating == 0
                    ? 'Aucune note'
                    : rating == 1
                        ? 'Non satisfaisant'
                        : rating == 2
                            ? 'Moyennement satisfaisant'
                            : 'Satisfaisant',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarButton extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;

  const StarButton({
    super.key,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        filled ? Icons.star_rounded : Icons.star_border_rounded,
        color: Colors.amber,
        size: 34,
      ),
    );
  }
}
