import 'dart:convert';
import 'package:annonce/database/api_provider.dart';
import 'package:annonce/model/form.dart';
import 'package:flutter/material.dart';
import 'post_ad_form.dart';

/*
* choice of category for publication of an ad
*
* */


class PostAdCategory extends StatefulWidget {
  PostAdCategory({Key key}) : super(key: key);

  @override
  PostAdCategoryState createState() => PostAdCategoryState();
}

class PostAdCategoryState extends State<PostAdCategory> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //  title
      appBar: AppBar(
        title: Text("Déposer une annonce"),
        backgroundColor: Color(0xff0b4e94),
      ),

      // categories List
      body: new ListView.builder(
        itemCount: soucCateg.length,
        itemBuilder: (context, i) {
          return new ExpansionTile(
            title: new Text(
              soucCateg[i].title,
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            leading: new Icon(soucCateg[i].icon),
            children: <Widget>[
              new Column(
                children: buildExpandableContent(soucCateg[i]),
              ),
            ],
          );
        },
      ),
    );
  }

  buildExpandableContent(Categories cat) {
    List<Widget> columnContent = [];
    for (String content in cat.contents)
      columnContent.add(
        new ListTile(
            title: new Text(
              content,
              style: new TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            onTap: () {
              var apiProvider = FormsApiProvider();
              int index = Categories.idsform[content];
              String json_formulaire;
              apiProvider.getForm(index).then((result) {
                //Creat  form instance as String
                Forms formulaire = result;
                //print(formulaire.fields);
                json_formulaire = jsonDecode(formulaire.fields);
                print(json_formulaire);
                String guillemet = '"';
                String start = '{' +
                    guillemet +
                    'autoValidated' +
                    guillemet +
                    ': false,' +
                    guillemet +
                    'fields' +
                    guillemet +
                    ':[';
                //json_formulaire = json_formulaire.replaceAll('[', start);
                json_formulaire =  '{"autoValidated": false,"fields":' + json_formulaire;
                json_formulaire = json_formulaire + '}';
                Map form = json.decode(json_formulaire);
                //print(d);
                print(json_formulaire);
                // Ouverture de la page du formulaire avec les parametres : id, titre, formulaire
                openFormulaire(Categories.idsform[content], content, form);
              });
            }),
      );

    return columnContent;
  }

  openFormulaire(int id, String title, Map form) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new PostAdForm(id: id, title: title, form: form),
      ),
    );
  }
}

class Categories {
  final String title;
  List<String> contents = [];
  final IconData icon;

  static final Map<String, int> idsform = const {
    // Fomulaire.label - Formulaire.id => table
    'offres d\'emploi': 1,
    "Voitures": 3,
    "Motos": 4,
    "Caravinng": 5,
    "Utilitaires": 6,
    "Nautisme": 7,
    "Équipement auto": 8,
    "Équipement moto": 9,
    "Équipement caraving": 10,
    "Équipement nautism": 11,
    "Ventes immobilières": 13,
    "Locations": 14,
    "Colocations": 15,
    "Bureaux & Commerce": 16,
    "Locations & Gites": 18,
    'Chambres d'
        'hôtes': 19,
    "Campings": 20,
    "Hébergements insolites": 21,
    "Informatique": 23,
    "Consoles & Jeux vidéos": 24,
    "Image & Son": 25,
    "Téléphonie": 26,
    "Ameublement": 28,
    "Électroménager": 29,
    "Arts de la table": 30,
    "Décoration": 31,
    "Linge de maison": 32,
    "Bricolage": 33,
    "Jardinage": 34,
    "Vêtements": 36,
    "Chaussures": 37,
    "Accessoires & Bagagerie": 38,
    "Montres & Bijoux": 39,
    "Équipement bébé": 40,
    "Vêtement bébé": 41,
    "DVD - Films": 43,
    "CD - Muqiues": 44,
    "Livres": 45,
    "Animaux": 46,
    "Vélos": 47,
    "Sports & Hobbies": 48,
    "Instruments de musiques": 49,
    "Colection": 50,
    "Jeux & Jouet": 51,
    "Vins & Gastronomie": 52,
    "Matériel agricole": 54,
    "Transport - Manutention": 55,
    "BTP - Chantier gros-oeuvre": 56,
    "Outillage - Matériaux 2nd-oeuvre": 57,
    "Équipements industriels": 58,
    "Restauration - Hôtellerie": 59,
    "Fournitures de bureau": 60,
    "Commerces & Marché": 61,
    "Matériel médical": 62,
    "Prestation de services": 64,
    "Billetterie": 65,
    "Évenements": 66,
    "Cours particulier": 67,
    "Covoiturage": 68,
    "Autres": 70,
  };

  Categories(this.icon, this.title, this.contents);
}

final titles = [
  'Emplois',
  'Véhicules',
  'Immobilier',
  'Vacances',
  'Multimédia',
  'Maison',
  'Mode',
  'Loisirs',
  'Matériel Professionnel',
  'Service',
  'Divers',
];

final icon = [
  Icons.work,
  Icons.directions_car,
  Icons.home,
  Icons.wb_sunny,
  Icons.phone_android,
  Icons.weekend,
  Icons.face,
  Icons.rowing,
  Icons.gavel,
  Icons.thumb_up,
  Icons.more_horiz
];

List<Categories> soucCateg = [
  new Categories(Icons.work, 'Emplois', ['offres d\'emploi']),
  new Categories(Icons.directions_car, 'Véhicules', [
    'Voitures',
    'Motos',
    'Caravinng',
    'Utilitaires',
    'Nautisme',
    'Équipement auto',
    'Équipement moto'
  ]),
  new Categories(Icons.home, 'Immobilier', [
    'Ventes immobilières',
    'Locations',
    'Colocations',
    'Bureaux & Commerce',
    'Locations & Gites',
    'Chambres d' 'hôtes',
    'Campings',
    'Hébergements insolites'
  ]),
  new Categories(Icons.wb_sunny, 'Vacances', [
    'Locations & Gites',
    'Chambres d' 'hôtes',
    'Campings',
    'Hébergements insolites'
  ]),
  new Categories(Icons.phone_android, 'Multimédia',
      ['Informatique', 'Consoles & Jeux vidéos', 'Image & Son', 'Téléphonie']),
  new Categories(Icons.weekend, 'Maison', [
    'Ameublement',
    'Électroménager',
    'Arts de la table',
    'Décoration',
    'Linge de maison',
    'Bricolage',
    'Jardinage'
  ]),
  new Categories(Icons.face, 'Mode', [
    'Vêtements',
    'Chaussures',
    'Accessoires & Bagagerie',
    'Montres & Bijoux',
    'Équipement bébé',
    'Vêtement bébé'
  ]),
  new Categories(Icons.rowing, 'Loisirs', [
    'DVD - Films',
    'CD - Muqiues',
    'Livres',
    'Animaux',
    'Vélos',
    'Sports & Hobbies',
    'Colection',
    'Jeux & Jouet',
    'Vins & Gastronomie'
  ]),
  new Categories(Icons.gavel, 'Matériel Professionnel', [
    'Matériel agricole',
    'Transport - Manutention',
    'BTP - Chantier gros-oeuvre',
    'Outillage - Matériaux 2nd-oeuvre',
    'Équipements industriels',
    'Restauration - Hôtellerie',
    'Fournitures de bureau',
    'Commerces & Marché',
    'Matériel médical'
  ]),
  new Categories(Icons.thumb_up, 'Service', [
    'Prestation de services',
    'Billetterie',
    'Évenements',
    'Cours particulier',
    'Covoiturage'
  ]),
  new Categories(Icons.more_horiz, 'Divers', ['Autres']),
];
