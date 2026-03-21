import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFDFDFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF4F46E5),
              width: 1.6,
            ),
          ),
          hintStyle: const TextStyle(color: Colors.black38),
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 122,
                height: 122,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4F46E5).withValues(alpha: 0.14),
                      const Color(0xFF818CF8).withValues(alpha: 0.10),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flight_takeoff_rounded,
                  size: 58,
                  color: Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Bienvenue',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Aidez-nous à améliorer votre expérience à l’aéroport grâce à un mini questionnaire rapide, clair et simple.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.55,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEBFF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Temps estimé : moins d’une minute',
                  style: TextStyle(
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _goToSurvey(context),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Commencer'),
                ),
              ),
              const SizedBox(height: 12),
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

  bool draftLoaded = false;

  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDraft();
    commentController.addListener(saveDraft);
  }

  @override
  void dispose() {
    commentController.removeListener(saveDraft);
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

  Future<void> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();

    final savedComfort = prefs.getInt('comfortRating') ?? 0;
    final savedInformation = prefs.getInt('informationRating') ?? 0;
    final savedCleanliness = prefs.getInt('cleanlinessRating') ?? 0;
    final savedSignage = prefs.getInt('signageRating') ?? 0;
    final savedServices = prefs.getInt('servicesRating') ?? 0;
    final savedComment = prefs.getString('finalComment') ?? '';

    if (!mounted) return;

    setState(() {
      comfortRating = savedComfort;
      informationRating = savedInformation;
      cleanlinessRating = savedCleanliness;
      signageRating = savedSignage;
      servicesRating = savedServices;
      commentController.text = savedComment;
      draftLoaded = true;
    });

    final hasDraft = savedComfort > 0 ||
        savedInformation > 0 ||
        savedCleanliness > 0 ||
        savedSignage > 0 ||
        savedServices > 0 ||
        savedComment.isNotEmpty;

    if (hasDraft && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Brouillon restauré automatiquement.'),
        ),
      );
    }
  }

  Future<void> saveDraft() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('comfortRating', comfortRating);
    await prefs.setInt('informationRating', informationRating);
    await prefs.setInt('cleanlinessRating', cleanlinessRating);
    await prefs.setInt('signageRating', signageRating);
    await prefs.setInt('servicesRating', servicesRating);
    await prefs.setString('finalComment', commentController.text);
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('comfortRating');
    await prefs.remove('informationRating');
    await prefs.remove('cleanlinessRating');
    await prefs.remove('signageRating');
    await prefs.remove('servicesRating');
    await prefs.remove('finalComment');
  }

  Future<void> resetForm() async {
    setState(() {
      comfortRating = 0;
      informationRating = 0;
      cleanlinessRating = 0;
      signageRating = 0;
      servicesRating = 0;
      commentController.clear();
    });

    await clearDraft();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Le formulaire a été réinitialisé.'),
      ),
    );
  }

  Future<void> submitSurvey() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez noter toutes les catégories.'),
        ),
      );
      return;
    }

    final finalComment = commentController.text.trim();

    await clearDraft();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessScreen(
          comfortRating: comfortRating,
          informationRating: informationRating,
          cleanlinessRating: cleanlinessRating,
          signageRating: signageRating,
          servicesRating: servicesRating,
          finalComment: finalComment,
        ),
      ),
    );
  }

  void updateRating(String category, int value) {
    setState(() {
      if (category == 'comfort') {
        comfortRating = value;
      } else if (category == 'information') {
        informationRating = value;
      } else if (category == 'cleanliness') {
        cleanlinessRating = value;
      } else if (category == 'signage') {
        signageRating = value;
      } else if (category == 'services') {
        servicesRating = value;
      }
    });

    saveDraft();
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
        actions: [
          IconButton(
            onPressed: resetForm,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Réinitialiser',
          ),
        ],
      ),
      body: !draftLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Votre avis nous aide à améliorer les services de l’aéroport.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Évaluez rapidement chaque catégorie en choisissant de 1 à 3 étoiles.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF4F46E5),
                            Color(0xFF6366F1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.timer_outlined, color: Colors.white),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Temps estimé : moins d’une minute',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              value: progress / 5,
                              minHeight: 10,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$progress/5 catégories renseignées',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    RatingCard(
                      title: 'Confort',
                      subtitle: 'Sièges et confort climatique',
                      icon: Icons.airline_seat_recline_normal_rounded,
                      color: Colors.indigo,
                      rating: comfortRating,
                      onChanged: (value) => updateRating('comfort', value),
                    ),
                    const SizedBox(height: 14),
                    RatingCard(
                      title: 'Information et orientation',
                      subtitle: 'Clarté des informations et aide à l’orientation',
                      icon: Icons.info_outline_rounded,
                      color: Colors.blue,
                      rating: informationRating,
                      onChanged: (value) => updateRating('information', value),
                    ),
                    const SizedBox(height: 14),
                    RatingCard(
                      title: 'Propreté générale',
                      subtitle: 'Espaces publics, toilettes et circulation',
                      icon: Icons.cleaning_services_rounded,
                      color: Colors.green,
                      rating: cleanlinessRating,
                      onChanged: (value) => updateRating('cleanliness', value),
                    ),
                    const SizedBox(height: 14),
                    RatingCard(
                      title: 'Signalisation',
                      subtitle: 'Parkings, halls et zones d’embarquement',
                      icon: Icons.signpost_outlined,
                      color: Colors.orange,
                      rating: signageRating,
                      onChanged: (value) => updateRating('signage', value),
                    ),
                    const SizedBox(height: 14),
                    RatingCard(
                      title: 'Services et commerces',
                      subtitle: 'Services disponibles et expérience globale',
                      icon: Icons.storefront_outlined,
                      color: Colors.purple,
                      rating: servicesRating,
                      onChanged: (value) => updateRating('services', value),
                    ),
                    const SizedBox(height: 14),
                    StyledCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.edit_note_rounded,
                                  color: Color(0xFF4F46E5),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Commentaire final',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: commentController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Optionnel',
                                hintText:
                                    'Ajoutez une remarque ou une suggestion...',
                                alignLabelWithHint: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: submitSurvey,
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Envoyer'),
                      ),
                    ),
                  ],
                ),
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

  Color ratingColor(int rating) {
    if (rating == 3) return Colors.green;
    if (rating == 2) return Colors.orange;
    return Colors.red;
  }

  Widget buildResultTile(String title, int rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ratingColor(rating).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: ratingColor(rating)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${ratingLabel(rating)} ($rating/3)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void backToHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withValues(alpha: 0.18),
                      Colors.green.withValues(alpha: 0.08),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                  size: 52,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Merci pour votre participation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Votre avis a bien été enregistré localement dans cette version de démonstration.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 22),
              StyledCard(
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
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
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
                          child: Text(
                            finalComment,
                            style: const TextStyle(
                              height: 1.45,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => backToHome(context),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Retour à l’accueil'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int rating;
  final ValueChanged<int> onChanged;

  const RatingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.rating,
    required this.onChanged,
  });

  String ratingText() {
    if (rating == 3) return 'Satisfaisant';
    if (rating == 2) return 'Moyennement satisfaisant';
    if (rating == 1) return 'Non satisfaisant';
    return 'Aucune note';
  }

  @override
  Widget build(BuildContext context) {
    return StyledCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StarButton(
                  filled: rating >= 1,
                  onTap: () => onChanged(1),
                ),
                const SizedBox(width: 6),
                StarButton(
                  filled: rating >= 2,
                  onTap: () => onChanged(2),
                ),
                const SizedBox(width: 6),
                StarButton(
                  filled: rating >= 3,
                  onTap: () => onChanged(3),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ratingText(),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: rating == 0 ? Colors.black45 : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StyledCard extends StatelessWidget {
  final Widget child;

  const StyledCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Card(
        child: child,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: Colors.amber,
          size: 32,
        ),
      ),
    );
  }
}
