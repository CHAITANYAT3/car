# Car Showroom Management App (Flutter)

A modular Flutter mobile app built with MVVM/Clean-style separation:

- `data/`: SQLite DB, models, and repository
- `domain/`: entities and enums
- `presentation/`: providers (viewmodels), screens, reusable widgets
- `core/`: app theme and utility catalogs

## Features

- Admin and Customer role-based authentication
- Dashboard with animated gradient cards and Hero transitions
- Car Management
  - New cars: browse, test-drive booking, purchase flow
  - Used cars: browse, test-drive booking, sell-your-car request
- Admin workflows
  - Add new brand/model cars
  - Approve used car sell requests
  - Low-stock notifications
- Spare parts store with stock and buy flow
- Service center bookings (Basic/Standard/Premium)
- Payments (UPI, cards, net banking, cash)
- Sales history and analytics

## Run

```bash
flutter pub get
flutter run
```

Demo accounts:
- Admin: `admin@showroom.com / admin123`
- Customer: `user@showroom.com / user123`
