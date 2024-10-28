## ⛩️ Project Info


## Daily E - E learning english app

### Introduction:
    Daily E is a E-learning app that helps you learn English in a fun and effective way. With Daily E, you can learn English anytime, anywhere, and at your own pace. The app offers a wide range of features, including vocabulary practice, grammar lessons, listening exercises, and more. Whether you're a beginner or an advanced learner, Daily E has something for everyone.

### Related web:
    1.dailydictation: https://dailydictation.com/

### Members:
    1. Lương Ngọc Tuấn
    2. Trương Thị Lan Anh 
    3. Nguyễn Kim Vui
    4. Vũ Thị Ánh Ngọc

## 🎉 Features

- [ ] Vocabulary practice
- [ ] Grammar lessons
- [ ] Listening exercises
- [ ] Reading comprehension
- [ ] Writing exercises

## ⚙️ Prerequisites

Make sure you have the following installed on your development machine:

- Flutter (version 3.5.0)
- Install: https://docs.flutter.dev/release/archive

## 🚀 Getting Started

Follow these steps to get started project:

1. Clone the repository:

   ```bash
   git clone https://github.com/TuanChill/Nhom8.git
   ```

2. Navigate to the project directory:

   ```bash
   cd Nhom8
   ```

3. Install the dependencies:

   ```bash
    flutter pub get
   ```

4. Start the development server:

   ```bash
    flutter run
   ```

## 📜 Available Scripts

In the project directory, you can run the following commands:
    flutter run
    flutter build apk
    flutter build ios
    flutter pub get
    flutter pub upgrade

## 📂 Project Structure

This architecture is made of four distinct layers, each containing the components that our app needs:

```python
project/      # Project dependencies
  ├── assets/            # Public assets
  ├── lib/               # Flutter src code
  │   ├── src/   
  │       ├── presentation/    # widgets, states, and controllers
  │       ├── application/     # services
  │       ├── domain/          # models
  │       ├── data/            # repositories, data sources, and DTOs (data transfer objects)
  ├── .flutter-plugins                # Flutter plugins
  ├── .flutter-plugins-dependencies   # Flutter plugins dependencies
  ├── .gitignore                      # Git ignore file
  ├── .metadata                       # Flutter metadata
  ├── .pubspec.yaml                   # Flutter dependencies
  └── README.md                       # Project README
```