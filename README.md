SafeHer - Women Safety App

1.Overview

SafeHer is a Flutter-based mobile application designed to enhance women’s safety by providing an instant SOS alert system with real-time location sharing and emergency contact notifications.

2.Features

SOS Button: Sends an emergency message with the user’s live location.
Police Help: Opens nearby police stations directly in Google Maps.
Alert Sound: Plays a loud siren to grab attention during emergencies.
Contacts Screen: Allows users to add and manage trusted contacts.
Simple UI: Clean, user-friendly, and responsive interface.

3.Technologies Used

Frontend: Flutter (Dart)
APIs: Google Maps
Local Storage: SharedPreferences

4.Packages Used

geolocator – For live location tracking
url_launcher – To open SMS app or maps
shared_preferences – To save emergency contacts
audioplayers – For siren sound
permission_handler – To manage app permissions

5.App Flow

1. Splash Screen: Displays app logo and name.
2. Home Screen:
SOS button to trigger emergency help.
Police Help button to find nearby police stations.
3. Contacts Screen:
Add, view, or delete emergency contacts.
4. Profile Screen (optional):
User details and app settings.

6.Folder Structure

lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── contacts_screen.dart
│   ├── profile_screen.dart
└── assets/
    └── alert.mp3
    |__logo.jpg

7.Installation Steps

1. Clone the Repository
git clone <https://github.com/Vaish1401-rai/SAFEHER>
cd safeher
2. Install Dependencies
flutter pub get
3. Run the App
flutter run

8.How It Works

On pressing the SOS button, the app automatically fetches the current location and opens the message app with a prefilled SOS text containing the user’s location.
Police Help button uses Google Maps URL to show nearby police stations.
Contacts Screen allows users to store trusted numbers locally.

9.Future Enhancements

Auto-send SMS without opening messaging app.
Live tracking and location updates to family.
Firebase integration for storing user and contact data.
Connection with nearby NGOs or local police APIs.

10.Developer Information

Name: Vaishnavi Rai
Roll No: 2405398
Institution: KIIT University
Tools Used: Flutter, Dart

11.Conclusion

SafeHer empowers women by providing quick access to help during emergencies. With real-time location sharing and instant SOS messaging, it ensures safety is just one tap away.
