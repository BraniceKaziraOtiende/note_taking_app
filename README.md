# Notes App

A Flutter mobile application for taking notes with Firebase authentication and Firestore integration.

## Features

- **Authentication**: Email/password sign-up and sign-in using Firebase Auth
- **CRUD Operations**: Create, read, update, and delete notes
- **Real-time Data**: Notes are stored in Firestore and sync across devices
- **Clean Architecture**: Separation of concerns with BLoC pattern for state management
- **User Feedback**: SnackBars for success/error messages
- **Empty State**: Helpful hint when no notes exist

## Architecture

This app follows Clean Architecture principles with the following structure:

```
lib/
├── domain/
│   └── models/
│       └── note.dart
├── data/
│   └── repositories/
│       ├── auth_repository.dart
│       └── notes_repository.dart
├── presentation/
│   ├── blocs/
│   │   ├── auth/
│   │   │   └── auth_bloc.dart
│   │   └── notes/
│   │       └── notes_bloc.dart
│   ├── screens/
│   │   ├── auth_screen.dart
│   │   └── notes_screen.dart
│   └── widgets/
│       ├── add_note_dialog.dart
│       ├── edit_note_dialog.dart
│       └── delete_confirmation_dialog.dart
├── firebase_options.dart
└── main.dart
```

## State Management

The app uses **BLoC (Business Logic Component)** pattern for state management:

- **AuthBloc**: Manages authentication state (sign-in, sign-up, sign-out)
- **NotesBloc**: Manages notes CRUD operations and loading states

### Why BLoC?

BLoC provides:
- **Separation of Concerns**: Business logic is separated from UI
- **Testability**: Easy to unit test business logic
- **Reusability**: Blocs can be shared across different UI components
- **Predictable State Management**: Events trigger state changes in a predictable way

### How BLoC Works in This App:

1. **Events**: User actions (like tapping a button) trigger events
2. **Blocs**: Process events and emit new states
3. **States**: UI rebuilds based on state changes
4. **Widgets**: Listen to state changes using BlocBuilder and BlocListener

Example flow:
```
User taps "Add Note" → AddNote Event → NotesBloc processes → NotesOperationSuccess State → UI shows success message
```

## Firebase Setup

### Prerequisites

1. Create a Firebase project at [https://console.firebase.google.com](https://console.firebase.google.com)
2. Enable Authentication with Email/Password
3. Create a Firestore database
4. Install Firebase CLI: `npm install -g firebase-tools`
5. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`

### Configuration Steps

1. **Login to Firebase**:
   ```bash
   firebase login
   ```

2. **Configure FlutterFire**:
   ```bash
   flutterfire configure
   ```
   - Select your Firebase project
   - Choose platforms (Android, iOS, Web, macOS)
   - This will generate `firebase_options.dart` with your configuration

3. **Enable Authentication**:
   - Go to Firebase Console → Authentication → Sign-in method
   - Enable "Email/Password"

4. **Setup Firestore**:
   - Go to Firebase Console → Firestore Database
   - Create database in test mode
   - Set up security rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
         match /notes/{noteId} {
           allow read, write: if request.auth != null && request.auth.uid == userId;
         }
       }
     }
   }
   ```

## Build Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd notes_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Firebase
- Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration
- Or run `flutterfire configure` to auto-generate the file

### 4. Run the App
```bash
# For Android emulator
flutter run

# For iOS simulator  
flutter run -d ios

# For specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

### 5. Run Dart Analyzer
```bash
flutter analyze
```

## CRUD Operations

### Authentication
- **Sign Up**: `createUserWithEmailAndPassword()`
- **Sign In**: `signInWithEmailAndPassword()`
- **Sign Out**: `signOut()`

### Notes Management
- **Create**: `await addNote(text)` - Adds new note to Firestore
- **Read**: `await fetchNotes()` - Retrieves all user notes
- **Update**: `await updateNote(id, text)` - Updates existing note
- **Delete**: `await deleteNote(id)` - Removes note from Firestore

## Data Structure

Notes are stored in Firestore with the following structure:
```
users/{userId}/notes/{noteId}
├── text: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Troubleshooting

### Common Issues

1. **Firebase not initialized**:
   - Ensure `Firebase.initializeApp()` is called in `main()`
   - Check that `firebase_options.dart` has correct configuration

2. **Authentication errors**:
   - Verify Email/Password is enabled in Firebase Console
   - Check internet connectivity

3. **Firestore permission denied**:
   - Update Firestore security rules
   - Ensure user is authenticated before accessing data

4. **Build errors**:
   - Run `flutter clean && flutter pub get`
   - Check that all dependencies are compatible

### Debug Tips

- Use `flutter logs` to see real-time logs
- Enable Firebase debug logging for detailed error messages
- Check Firestore console for data structure issues

## Dependencies

- `firebase_core`: Firebase SDK core
- `firebase_auth`: Authentication
- `cloud_firestore`: Firestore database
- `flutter_bloc`: State management
- `equatable`: Value equality for BLoC states/events

## License

This project is for educational purposes.
