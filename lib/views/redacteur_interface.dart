import 'package:flutter/material.dart';
import '../modele/redacteur.dart';
import '../services/database_manager.dart';

class GestionRedacteursScreen extends StatefulWidget {
  const GestionRedacteursScreen({super.key});

  @override
  State<GestionRedacteursScreen> createState() => _GestionRedacteursScreenState();
}

class _GestionRedacteursScreenState extends State<GestionRedacteursScreen> {
  final DatabaseManager _dbManager = DatabaseManager();
  
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Redacteur> _redacteurs = [];

  @override
  void initState() {
    super.initState();
    _rafraichirListe();
  }

  Future<void> _rafraichirListe() async {
    final donnees = await _dbManager.getAllRedacteurs();
    if (mounted) {
      setState(() {
        _redacteurs = donnees;
      });
    }
  }

  Future<void> _validerEtAjouter() async {
    if (_prenomController.text.isEmpty || _nomController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final nouveauRedacteur = Redacteur.sansId(
      prenom: _prenomController.text.trim(),
      nom: _nomController.text.trim(),
      email: _emailController.text.trim(),
    );

    await _dbManager.insertRedacteur(nouveauRedacteur);
    
    _prenomController.clear();
    _nomController.clear();
    _emailController.clear();

    await _rafraichirListe();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rédacteur ajouté avec succès !')),
    );
  }

  void _afficherDialogueModification(Redacteur redacteur) {
    final TextEditingController editPrenomController = TextEditingController(text: redacteur.prenom);
    final TextEditingController editNomController = TextEditingController(text: redacteur.nom);
    final TextEditingController editEmailController = TextEditingController(text: redacteur.email);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modifier le rédacteur'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: editPrenomController, decoration: const InputDecoration(labelText: 'Prénom')),
              TextField(controller: editNomController, decoration: const InputDecoration(labelText: 'Nom')),
              TextField(controller: editEmailController, decoration: const InputDecoration(labelText: 'Email')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              redacteur.prenom = editPrenomController.text.trim();
              redacteur.nom = editNomController.text.trim();
              redacteur.email = editEmailController.text.trim();

              await _dbManager.updateRedacteur(redacteur);
              
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              _rafraichirListe();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _confirmerSuppression(int? id) {
    if (id == null) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce rédacteur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await _dbManager.deleteRedacteur(id);
              
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              _rafraichirListe();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Rédacteurs'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(controller: _prenomController, decoration: const InputDecoration(labelText: 'Prénom')),
                    TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom')),
                    TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: _validerEtAjouter,
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter un Rédacteur'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Liste des Rédacteurs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _redacteurs.isEmpty
                  ? const Center(child: Text('Aucun rédacteur enregistré.'))
                  : ListView.builder(
                      itemCount: _redacteurs.length,
                      itemBuilder: (context, index) {
                        final item = _redacteurs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.pink[100],
                              child: Text(item.prenom.isNotEmpty ? item.prenom[0].toUpperCase() : 'R'),
                            ),
                            title: Text('${item.prenom} ${item.nom.toUpperCase()}'),
                            subtitle: Text(item.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _afficherDialogueModification(item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmerSuppression(item.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}