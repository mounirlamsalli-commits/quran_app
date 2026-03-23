// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Saint Coran';

  @override
  String get home => 'Accueil';

  @override
  String get quran => 'Coran';

  @override
  String get search => 'Recherche';

  @override
  String get bookmarks => 'Signets';

  @override
  String get settings => 'Paramètres';

  @override
  String surahNumber(int number) {
    return 'Sourate $number';
  }

  @override
  String ayahCount(int count) {
    return '$count versets';
  }

  @override
  String get searchHint => 'Rechercher dans le Saint Coran...';

  @override
  String searchNoResults(String query) {
    return 'Aucun résultat pour $query';
  }

  @override
  String get tafseer => 'Tafseer';

  @override
  String get translation => 'Traduction';

  @override
  String get audio => 'Audio';

  @override
  String get playAudio => 'Lire la récitation';

  @override
  String get pauseAudio => 'Pause';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get language => 'Langue';

  @override
  String get fontSize => 'Taille de police';

  @override
  String get lastRead => 'Dernière lecture';

  @override
  String get continueReading => 'Continuer la lecture';

  @override
  String get readingStats => 'Statistiques';

  @override
  String get bookmarkAdded => 'Signet ajouté';

  @override
  String get bookmarkRemoved => 'Signet supprimé';

  @override
  String get noBookmarks => 'Aucun signet';

  @override
  String get meccan => 'Mecquoise';

  @override
  String get medinan => 'Médinoise';

  @override
  String juz(int number) {
    return 'Juz $number';
  }

  @override
  String get reciter => 'Récitant';

  @override
  String get playbackSpeed => 'Vitesse de lecture';

  @override
  String get repeatMode => 'Mode répétition';

  @override
  String get repeatAyah => 'Répéter verset';

  @override
  String get repeatSurah => 'Répéter sourate';

  @override
  String get repeatJuz => 'Répéter juz';

  @override
  String get downloadAudio => 'Télécharger audio';

  @override
  String get downloading => 'Téléchargement...';

  @override
  String get downloaded => 'Téléchargé';

  @override
  String get todayAyah => 'Verset du jour';

  @override
  String get streak => 'Jours consécutifs';

  @override
  String streakDays(int count) {
    return '$count jours';
  }

  @override
  String completionPercent(int percent) {
    return 'Complétion $percent%';
  }

  @override
  String get readingReminder => 'Rappel de lecture';

  @override
  String get share => 'Partager';

  @override
  String get copyAyah => 'Copier le verset';

  @override
  String get addNote => 'Ajouter une note';

  @override
  String get folderName => 'Nom du dossier';

  @override
  String get noInternet => 'Pas de connexion';

  @override
  String get retry => 'Réessayer';

  @override
  String get loading => 'Chargement...';
}
