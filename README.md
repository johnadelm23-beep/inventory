# 📦 Inventory Management System

A modern, scalable, and real-time **Inventory Management Application** built with **Flutter** and **Firebase**.

The system enables businesses to efficiently manage inventory, monitor stock movements, track user activities, and control access through role-based permissions. Designed with a clean architecture and responsive UI, the application supports both **mobile** and **desktop** platforms.

---

## 🚀 Features

### 🔐 Authentication & Authorization

* Firebase Authentication
* Secure Login & Registration
* Session Persistence
* Role-Based Access Control (Admin / Employee)
* Protected Routes & User Permissions

### 📦 Inventory Management

* Add New Products
* Update Product Information
* Delete Products
* Real-Time Stock Updates
* Inventory Quantity Management
* Product Search & Filtering

### 📊 Dashboard & Reporting

* Inventory Overview Dashboard
* Product Statistics
* Daily Inventory Reports
* Activity Tracking
* Stock Monitoring
* Low Stock Detection

### 📝 Activity Logs

* Track Product Modifications
* User Action History
* Date-Based Log Filtering
* Audit Trail for Inventory Changes

### 👥 User Management

* Admin Dashboard
* User Role Management
* Employee Access Control
* User Profile Management

### ☁️ Firebase Integration

* Cloud Firestore Database
* Real-Time Synchronization
* Secure Data Storage
* Authentication Services

### 📱 Responsive Design

* Mobile Optimized UI
* Desktop Support
* Windows Compatibility
* Adaptive Layouts
* Responsive Components

---

## 🖼️ Screenshots

### Authentication

<img width="720" height="1600" alt="Register Screen" src="https://github.com/user-attachments/assets/c564d3b0-6864-4879-b72d-d8f9687da51e" />

<img width="720" height="1600" alt="Login Screen" src="https://github.com/user-attachments/assets/91886fab-1fa3-4bd0-9700-b69679ed22c3" />

### Inventory Logs

<img width="1080" height="2400" alt="Logs Screen" src="https://github.com/user-attachments/assets/197df6d9-54b8-4e2e-8931-513452c44be6" />

<img width="1080" height="2400" alt="Detailed Logs" src="https://github.com/user-attachments/assets/2339cc44-91cf-4ea1-9353-fae43666a581" />

### Product Management

<img width="720" height="1600" alt="Add Product Screen" src="https://github.com/user-attachments/assets/5e8e5992-cbc8-493b-b390-6506f3f15bbe" />

<img width="720" height="1600" alt="Products Screen" src="https://github.com/user-attachments/assets/12ef410e-e526-4ccd-bb22-dcd4b03d1b01" />

### Navigation

<img width="720" height="1600" alt="Drawer Screen" src="https://github.com/user-attachments/assets/bcbe689f-b305-4885-aa8a-54cb4ccd532b" />

---

## 🛠️ Tech Stack

| Technology              | Purpose                                |
| ----------------------- | -------------------------------------- |
| Flutter                 | Cross-Platform Application Development |
| Dart                    | Programming Language                   |
| Firebase                | Backend Infrastructure                 |
| Cloud Firestore         | Real-Time Database                     |
| Firebase Authentication | User Authentication                    |
| Cubit / BLoC            | State Management                       |
| Flutter ScreenUtil      | Responsive UI                          |
| Lottie                  | Animations                             |
| Shared Preferences      | Local Storage                          |
| Material Design         | UI Components                          |

---

## 📂 Project Structure

```bash
lib
│
├── core
│   ├── constants
│   ├── services
│   ├── theme
│   ├── utils
│   └── widgets
│
├── features
│   ├── auth
│   ├── home
│   ├── products
│   ├── logs
│   └── admin
│
├── shared
│
└── main.dart
```

---

## ⚙️ Getting Started

### Prerequisites

Before running the project, make sure you have:

* Flutter SDK installed
* Firebase Project configured
* Android Studio or VS Code
* Dart SDK

### Installation

1. Clone the repository

```bash
git clone https://github.com/your-username/inventory-management-system.git
```

2. Navigate to the project directory

```bash
cd inventory-management-system
```

3. Install dependencies

```bash
flutter pub get
```

4. Configure Firebase

* Create a Firebase project.
* Add Android, iOS, or Windows applications.
* Download the Firebase configuration files.
* Place them in the appropriate project directories.

5. Run the application

```bash
flutter run
```

---

## 🏗️ Architecture

The project follows a **Feature-Based Clean Architecture** approach combined with **Cubit/BLoC State Management**.

```text
Presentation Layer
       │
       ▼
Cubit / BLoC
       │
       ▼
Repository Layer
       │
       ▼
Firebase Services
       │
       ▼
Cloud Firestore
```

---

## 🎯 Future Enhancements

* Barcode Scanner Integration
* Export Reports to Excel/PDF
* Product Categories
* Advanced Analytics Dashboard
* Dark Mode Support
* Multi-Warehouse Management
* Notifications & Alerts

---

## 👨‍💻 Author

John Adel

Flutter Developer passionate about building scalable, responsive, and production-ready applications using Flutter and Firebase.

---

## 📄 License

This project is available for educational and portfolio purposes.

Feel free to fork, explore, and contribute.
