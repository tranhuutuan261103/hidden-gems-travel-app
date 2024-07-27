# Hidden gems travel app

## Clone project

Setup is super easy. Clone the repository

```shell script
git clone https://github.com/tranhuutuan261103/hidden-gems-travel-app.git
```

## Run AI Server

```shell script
cd AI Server
```

Create .venv in "hidden-gems-travel-app/AI Server" and install packages follow requirements.txt

Create an ``.env`` file at the root of "hidden-gems-travel-app/AI Server"

```dotenv
GEMINI_KEY = YOUR_GEMINI_KEY
```

Run project

```shell script
python app.py
```

Deploy to ngrok

## Run backend

```shell script
cd Backend
npm install
```

Create an ``.env`` file at the root of hidden-gems-travel-app/Backend

```dotenv
DATABASE_URL = YOUR_MONGO_DB_URL
DINOV2HELPER_URL = URL_OF_AI_SERVER_WHEN_DEPLOY_TO_NGROK
JWT_SECRET = hidden-gems-travel
COST_TO_UNLOCK_A_GEM = 1000
POINTS_FOR_CREATING_A_GEM = 1000
MAX_DISTANCE_TO_ARRIVE = 5
SEED_DATA = false // set true if first run to seed data
```

## Run frontend (mobile app)

A new Flutter project.

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```shell script
cd Frontend
```

Run project

```shell script
flutter run lib/main.dart
```
