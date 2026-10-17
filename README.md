# 📚 Flashcard Quiz Pro

<div align="center">

A modern, feature-rich flashcard quiz application built with Flutter. Upload documents and automatically generate flashcards with AI, or create custom quiz questions.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green.svg)

</div>

---

## 📱 App Preview

<p align="center">
  <img src="screenshots/home-screen.png" alt="Flashcard Quiz Pro - Home Screen" width="100%"/>
</p>

<p align="center">
  <i>✨ Beautiful gold-themed interface with category filters, search functionality, and quick action buttons</i>
</p>

---

## ✨ Features

### 🤖 AI-Powered Document Upload
- Upload PDF, TXT, or Word documents
- Automatically generate flashcards from document content
- Smart Q&A pattern recognition
- Auto-generate multiple-choice questions

### 🎮 Interactive Quiz Mode
- **Instant Auto-Advance** - Moves to next question immediately after answering
- **Multiple Choice Questions** - Professional A-D format with instant feedback
- **Traditional Q&A Cards** - Classic flashcard experience
- **Expanded Explanations** - Detailed answers after each response
- **Real-time Scoring** - Track your performance as you study

### 🎨 Beautiful UI/UX
- Professional gold theme with elegant design
- Dark mode support for comfortable studying
- Smooth animations and transitions
- Responsive design for all screen sizes

### 📊 Study Tracking
- Progress monitoring and statistics
- Study streak tracking
- Category organization
- Session history
- Mastery levels

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+

### Installation

1. Clone the repository
```bash
git clone https://github.com/hailedv/flashcard-quiz-pro.git
cd flashcard-quiz-pro
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 📱 How to Use

### Upload a Document
1. Click **"Upload Document & Generate Flashcards"**
2. Select a PDF, TXT, or Word file
3. Review analysis results
4. Choose category and options
5. Click **"Generate Flashcards"**
6. Start studying!

### Take a Quiz
1. Click **"Start Quiz"**
2. Answer questions (select A-D for multiple choice)
3. See instant feedback with explanations
4. Auto-advance to next question
5. Review your score

## 🏗️ Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
├── providers/             # State management
├── screens/               # UI screens
├── widgets/               # Reusable widgets
├── services/              # Business logic
└── theme/                 # App theming
```

## 📦 Key Dependencies

- `provider` - State management
- `shared_preferences` - Local storage
- `file_picker` - Document selection
- `syncfusion_flutter_pdf` - PDF text extraction
- `fl_chart` - Statistics charts

## 🎨 Features in Detail

### Document Upload
- Supports PDF, TXT, and Word documents
- Extracts text automatically
- Recognizes Q: A: patterns
- Generates fill-in-the-blank questions
- Creates multiple-choice distractors

### Quiz Modes
- **Multiple Choice**: A-D format with letter badges
- **Q&A Cards**: Traditional show/hide answer
- **Auto-Advance**: Instant progression (100ms)
- **Expanded Answers**: Full explanation display

### Study Tools
- Category filtering
- Search functionality
- Favorites system
- Card management (Add/Edit/Delete)
- Export/Import capabilities

## 🎯 Document Format Tips

For best results, structure documents like this:

```
Q: What is Flutter?
A: Flutter is Google's UI toolkit for building cross-platform apps.

Q: What language does Flutter use?
A: Flutter uses the Dart programming language.
```

Plain text also works - the app will auto-generate questions!

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**hailedv**
- GitHub: [@hailedv](https://github.com/hailedv)
- Portfolio: [github.com/hailedv](https://github.com/hailedv)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Syncfusion for PDF extraction library
- Open source community

---

<div align="center">

**⭐ Star this repo if you found it helpful! ⭐**

Made with ❤️ and Flutter

</div>
