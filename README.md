# Chrissan

Chrissan adalah aplikasi toko online sederhana yang dibangun menggunakan Flutter. Aplikasi ini menampilkan daftar produk yang diambil secara real-time dari API eksternal [DummyJSON](https://dummyjson.com/products), lengkap dengan fitur login, keranjang belanja, dan halaman profil.

Aplikasi ini dirancang untuk berjalan di berbagai platform termasuk Android, iOS, dan Web. Untuk mendukung hal tersebut, digunakan Sembast sebagai local database (menggantikan Hive/SQLite yang tidak support web) dan SharedPreferences untuk menyimpan session login agar user tidak perlu login ulang setiap kali membuka aplikasi.

---

## Struktur Folder

```
lib/
├── main.dart                  # Entry point, inisialisasi Provider & cek auto login
│
├── models/                    # Berisi class model sebagai representasi data - 
│   │                          # - dari API maupun local database
│   └── product_model.dart     # Model produk & cart item (parsing JSON dari API)
│
├── pages/                     # Berisi seluruh halaman/tampilan UI aplikasi, -
│   │                          # - masing-masing file = satu page
│   ├── login_page.dart        # Halaman login (username bebas, password = NIM)
│   ├── main_page.dart         # Wrapper bottom navigation bar (Home & Profile)
│   ├── home_page.dart         # Halaman utama, list produk dari API + search + filter
│   ├── detail_page.dart       # Halaman detail produk, qty selector, tombol add to cart
│   ├── cart_page.dart         # Halaman keranjang belanja per user
│   └── profile_page.dart      # Halaman profil, info user, dan tombol logout
│
├── providers/                 # Berisi state management global menggunakan Provider, -
│   │                          # - data di sini bisa diakses dari halaman mana saja
│   └── app_state.dart         # Handle state login, session, dan data cart
│
└── services/                  # Berisi logic yang berhubungan dengan data, -
    │                          # - dipisah dari UI agar kode lebih rapi (separation of concerns)
    ├── api_service.dart        # Semua logic HTTP request ke DummyJSON API
    ├── db_service.dart         # Local database menggunakan Sembast
    └── session_service.dart    # Simpan & ambil session login via SharedPreferences
```

---

## Package yang Digunakan

| Package | Kegunaan |
|---|---|
| `provider` | State management |
| `http` | Fetching data dari API |
| `shared_preferences` | Menyimpan session login |
| `sembast` + `sembast_web` | Local database cross-platform |
| `google_fonts` | Custom font (DM Sans) |
| `shimmer` | Loading skeleton effect |
| `cached_network_image` | Load & cache gambar produk |