# Hello World — Elixir + Dart

A small recreation of the supplied reference image:

- **Elixir + Plug/Cowboy** serves the compiled Dart web app.
- **Dart** builds the UI and injects the page structure.
- Dark dotted-grid background
- Tiny top-left “Hello World - Minimal” label
- Large rounded white Hello World bar
- Responsive sizing

## Run

### 1. Build the Dart frontend

Install Dart SDK, then:

```bash
cd dart_frontend
dart pub get
dart compile js -O4 lib/main.dart -o web/main.dart.js
```

### 2. Start Elixir server

Install Elixir/Erlang, then:

```bash
cd ../elixir_server
mix deps.get
mix run --no-halt
```

Open:

http://localhost:4000

The Elixir server serves everything in `../dart_frontend/web`.
