# NewsAp

Welcome to the documentation for the News App! This app is built using Flutter, utilizing the BLoC state management pattern for efficient data handling and the Dio package for seamless API integration. The app provides users with the latest news, categorized for easy access, and offers bookmarking functionality to save news articles for later reading. Below, you'll find an overview of the app's features and how to navigate through its various components.

Features
Bottom Navigation: The dashboard screen features a bottom navigation bar with four main sections: Home, News, Bookmarks, and Profile. Each section serves a specific purpose in the app's functionality.

Home Screen:

The home screen offers a search button that leads to the search screen. Users can utilize this feature to search for news articles based on their interests.
A categorized list view of the latest news articles is available, allowing users to explore news stories under different categories.

News Screen:

The news screen employs a horizontal page view, enabling users to slide through news articles seamlessly.
Users have the option to add articles to their bookmarks for later reading.

Bookmarking:

Users can save their favorite news articles by bookmarking them.
Bookmarked articles are stored locally using the Hive database, ensuring quick access even offline.

Getting Started
To run the app locally, follow these steps:

Clone the Repository: Begin by cloning this repository to your local machine using the following command:
git clone https://github.com/your-username/news-app.git


Flutter Installation: Make sure you have Flutter installed. If not, follow the official installation guide to set up Flutter on your system.

Dependencies: Navigate to the project directory and install the required dependencies using the following command:
flutter pub get

Run the App: Launch the app on your preferred emulator or device by executing:
flutter run
