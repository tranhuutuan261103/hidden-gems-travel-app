# Hidden gems travel app

## Installation

Setup is super easy. Clone the repository

```shell script
git clone https://github.com/tranhuutuan261103/hidden-gems-travel-api.git
```

## Run backend

```shell script
cd Backend
npm install
```

Create an ``.env`` file at the root of hidden-gems-travel-app/Backend

```dotenv
DATABASE_URL = YOUR_MONGO_DB_URL
DINOV2HELPER_URL = https://7d5d-2001-ee0-1a1-7430-296c-f657-e46e-9855.ngrok-free.app
JWT_SECRET = hidden-gems-travel
COST_TO_UNLOCK_A_GEM = 1000
POINTS_FOR_CREATING_A_GEM = 1000
MAX_DISTANCE_TO_ARRIVE = 5
SEED_DATA = false
```

Run project

```shell script
npm start
```
