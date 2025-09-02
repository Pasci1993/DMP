import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'redacteur.dart';

class PageRedacteurs extends StatefulWidget {
  const PageRedacteurs({super.key});

  @override
  State<PageRedacteurs> createState() => _PageRedacteursState();
}

class _PageRedacteursState extends State<PageRedacteurs> {
  final db = DBHelper();
  List<Redacteur> redacteurs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    redacteurs = await db.getAll();
    setState(() {});
  }

  void _showDialog({Redacteur? r}) {
    final nomC = TextEditingController(text: r?.nom ?? '');
    final emailC = TextEditingController(text: r?.email ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(r == null ? 'Ajouter un rédacteur' : 'Modifier'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomC,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: emailC,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final redacteur = Redacteur(
                id: r?.id,
                nom: nomC.text,
                email: emailC.text,
              );
              if (r == null)
                await db.insert(redacteur);
              else
                await db.update(redacteur);
              _load();
              Navigator.pop(context);
            },
            child: Text(r == null ? 'Ajouter' : 'Modifier'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gérer les rédacteurs')),
      body: ListView.builder(
        itemCount: redacteurs.length,
        itemBuilder: (_, i) {
          final r = redacteurs[i];
          return ListTile(
            title: Text(r.nom),
            subtitle: Text(r.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showDialog(r: r),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await db.delete(r.id!);
                    _load();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showDialog(),
      ),
    );
  }
}
