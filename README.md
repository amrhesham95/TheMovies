# 🎬 TheMovies

**TheMovies** is a SwiftUI iOS app that allows users to browse and search movies using [The Movie Database (TMDB)](https://www.themoviedb.org/) API. It features modern SwiftUI architecture, pagination, MVVM, and Combine-based networking.

---

## ✨ Features

- 🔍 Search for movies in real time
- 📄 Movie details with poster, release date, and rating
- ⬇️ Infinite scroll/pagination support
- 📱 Built using SwiftUI
- 🧱 MVVM architecture

---

## 🔧 Tech Stack

- **SwiftUI** – Declarative UI framework
- **async/await** – Modern concurrency
- **MVVM** – Clean separation of concerns
- **URLSession** – Network layer
- **TMDB API** – Movie data provider

---

## 🏗️ Project Structure
TheMovies/
├── Models/ # Codable models for TMDB API
├── ViewModels/ # ObservableObjects for data/state
├── Views/ # SwiftUI Views
├── Services/ # API and network logic
└── Resources/ # Assets and UI helpers

