# Product Explorer

A small Flutter app for browsing products from the [Fake Store API](https://fakestoreapi.com).

## Setup and Run

Requirements: Flutter SDK and a connected device, emulator, or desktop target.

```bash
flutter pub get
flutter run
```

The app needs internet access to load products and submit the simulated cart request.

## Architecture

The app uses a feature-based structure. Shared networking and exceptions live in `core`; product-specific code stays under `features/products`.

```text
lib/
├── core/
│   ├── errors/
│   └── network/
├── features/products/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── product_remote_data_source.dart
│   ├── providers/
│   └── presentation/
└── main.dart
```

Riverpod provides simple, testable dependency wiring and async state for categories, products, product details, and cart actions. Dio is isolated in the API client, so widgets do not perform networking.

## Tests

Run all tests with:

```bash
flutter test
```

Tests use `mocktail` to mock `ApiClient` and cover repository errors and product parsing.

## Trade-offs

- There is no local database or offline cache; data comes from the API at runtime.
- The cart request is simulated by Fake Store API and is not a complete user cart system.
- JSON parsing is manual instead of generated to keep the project small and readable.
- Error handling is intentionally lightweight and surfaces retryable API/network failures to the UI.
