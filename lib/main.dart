import 'package:flutter/material.dart';
import 'views/redacteur_interface.dart'; // Importation de l'interface de l'Activité 5

void main() {
  runApp(const MonAppli()); // Lancement de l'application
}

// 1. Configuration globale de l'application
class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine', // Titre de l'application requis par l'énoncé
      debugShowCheckedModeBanner: false, // Désactive la bannière "Debug"
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.pink, // Couleur principale rose demandée
      ),
      home: const PageAccueil(),
    );
  }
}

// 2. Écran principal de l'application
class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Magazine Infos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Titre centré dans l'AppBar
        backgroundColor: Colors.pink, // Fond rose
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white), // Icône menu à gauche
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white), // Icône recherche à droite
            onPressed: () {},
          ),
        ],
      ),
      // Corps de la page avec défilement si l'écran est petit
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Image principale (Couverture)
            Image(
              image: AssetImage('assets/images/magazineInfo.jpg'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Appel des 4 widgets personnalisés demandés dans la partie 4.2
            PartieTitre(),
            PartieTexte(),
            PartieIcone(),
            PartieRubrique(),
          ],
        ),
      ),
      // Bouton flottant configuré pour naviguer vers l'Activité 5 🚀
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          // Navigation fluide vers l'écran de gestion des rédacteurs locales
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GestionRedacteursScreen(),
            ),
          );
        },
        child: const Icon(Icons.people, color: Colors.white), // Icône de groupe pour les rédacteurs
      ),
    );
  }
}

// ==========================================
// WIDGETS PERSONNALISÉS (EXERCICE 4.2)
// ==========================================

// Widget 1 : Section Titre et Sous-titre
class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'Votre magazine numérique, votre source d\'inspiration',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Widget 2 : Section Paragraphe Descriptif
class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: const Text(
        'Magazine Infos est bien plus qu\'un simple magazine d\'informations. C\'est votre passerelle vers le monde, une source inestimable de connaissances et d\'actualités soigneusement sélectionnées pour vous éclairer sur les enjeux mondiaux, la culture, la science, et le divertissement.',
        style: TextStyle(fontSize: 14, height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

// Widget 3 : Section Boutons d'Action (TEL, MAIL, PARTAGE)
class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Icon(Icons.phone, color: Colors.pink),
              SizedBox(height: 5),
              Text('TEL', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            children: [
              Icon(Icons.email, color: Colors.pink),
              SizedBox(height: 5),
              Text('MAIL', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            children: [
              Icon(Icons.share, color: Colors.pink),
              SizedBox(height: 5),
              Text('PARTAGE', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget 4 : Section Rubriques (Images côte à côte avec bords arrondis)
class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: const Image(
                image: AssetImage('assets/images/rubrique1.jpg'),
                fit: BoxFit.cover,
                height: 100,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: const Image(
                image: AssetImage('assets/images/rubrique2.jpg'),
                fit: BoxFit.cover,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}