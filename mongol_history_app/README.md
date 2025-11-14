# Монголын Түүхийн Апп

13-р зууны Монголын түүхийг таниулах интерактив боловсролын апп.

## Онцлог шинжүүд

- **Түүхэн хүмүүс**: Чингис хаан болон бусад алдарт хүмүүсийн намтар
- **Үйл явдлууд**: Цагийн хэлхээс дээр түүхэн үйл явдлуудыг харах
- **Газрын зураг**: Интерактив газрын зураг дээр байлдан дагуулалтыг харах
- **quiz**: Мэдлэгээ шалгах интерактив тест

## Технологи

- **Framework**: Flutter 3.0+
- **Хэл**: Dart
- **Өгөгдлийн сан**: SQLite (offline)
- **State Management**: Provider
- **Architecture**: Модульчлагдсан (UI, Data, Business Logic, Network)

## Суулгах

1. Flutter SDK суулгах (https://flutter.dev/docs/get-started/install)
2. Project-ийг татах:
```bash
git clone [repository-url]
cd mongol_history_app
```

3. Dependencies суулгах:
```bash
flutter pub get
```

4. Ажиллуулах:
```bash
flutter run
```

## Project бүтэц

```
lib/
├── main.dart                 # Апп-ын эхлэл
├── models/                   # Data models
│   ├── person.dart
│   ├── event.dart
│   ├── map_data.dart
│   ├── quiz.dart
│   └── media.dart
├── data/                     # Database layer
│   └── database_helper.dart
├── providers/                # State management
│   └── app_provider.dart
└── screens/                  # UI screens
    ├── home_screen.dart
    ├── persons_screen.dart
    ├── person_detail_screen.dart
    ├── events_screen.dart
    ├── maps_screen.dart
    └── quiz_screen.dart
```

## Өгөгдлийн сангийн бүтэц

### Хүснэгтүүд:
- **persons**: Түүхэн хүмүүсийн мэдээлэл
- **events**: Түүхэн үйл явдлууд
- **maps**: Газрын зургийн өгөгдөл
- **quizzes**: quizийн асуултууд
- **media**: Мультимедиа файлууд

## Одоогийн байдал

✅ Үндсэн бүтэц бэлэн
✅ SQLite өгөгдлийн сан тохируулагдсан
✅ UI дэлгэцүүд үүсгэгдсэн
✅ CRUD үйлдлүүд бүрэн
✅ Provider state management

## Цаашдын хөгжүүлэлт

- [ ] Firebase онлайн sync
- [ ] Мультимедиа файл дэмжлэг
- [ ] Интерактив газрын зураг
- [ ] AES шифрлэлт
- [ ] Biometric баталгаажуулалт
- [ ] Олон хэл дэмжих

## Лиценз

MIT License

## Холбогдох

Асуулт, санал байвал холбогдоорой.
