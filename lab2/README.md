# GemStore (Flutter)

Aplicație Flutter după designul Figma (Home + Product), cu pozele tale.

## Rulare în Android Studio
1. Dezarhivează și deschide folderul `gemstore` în Android Studio (File > Open).
2. În terminalul Android Studio rulează, în folderul proiectului:
   `flutter create --platforms=android,ios .`
   (generează folderele android/ios lipsă; nu atinge lib/, assets/, pubspec.yaml;
   dacă `lib/main.dart` ar fi înlocuit, copiază-l înapoi din arhivă)
3. `flutter pub get`
4. Pornește un emulator Android și apasă Run (▶).

## Ce e funcțional
- Home: categorii, banner cu auto-slide, Feature Products, Recommended, Top Collection, Show all, meniu lateral, notificări
- Product: galerie, culoare (schimbă poza la Sportwear Set), mărime, favorite, descriere Read more, reviews cu bare, Write a review, Similar Product
- Add To Cart, coș cu cantități, ștergere, total, checkout
