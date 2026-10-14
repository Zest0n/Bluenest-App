# 🏡 BlueNest — Modern Property & Real Estate Platform

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)](https://www.djangoproject.com/)
[![Django REST Framework](https://img.shields.io/badge/DRF-A30000?style=for-the-badge&logo=django&logoColor=white)](https://www.django-rest-framework.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.style=for-the-badge)](LICENSE)

**BlueNest** is a full-stack real estate application designed to simplify property management and discovery. Built with a responsive **Flutter** cross-platform mobile UI and powered by a robust **Django REST Framework** backend, BlueNest bridges the gap between landlords listing properties and tenants searching for their next home.

---

## ✨ Features

### 🔑 Authentication & Role Management
* **Dual-User System:** Separate user profiles for **Landlords** and **Tenants**.
* **Token-Based Authentication:** Secure JWT Bearer authentication for API requests.
* **Streamlined Onboarding:** Account registration with personal details, contact info, and role assignment.

### 🏢 Landlord Experience
* **Property Dashboard:** Manage all property listings in one central view.
* **Listing Management (CRUD):** Add, view, edit, update, or remove property entries seamlessly.
* **Detailed Specs Input:** Configure asking rent, BHK configuration, furnishing status, floor number, area size (sqft), and tenant preferences.
* **Image Hosting & Previews:** Upload and preview high-quality property imagery.

### 🔍 Tenant Experience
* **Property Exploration:** Browse detailed rental property listings with locations, amenities, and pricing.
* **Smart Specs Breakdown:** Clear view of key details like furnishing, preferences, and exact location.

---

## 🛠️ Tech Stack

### **Frontend (Mobile & Web)**
* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Architecture:** Modular architecture with dedicated service layers, models, and custom state widgets.
* **Networking:** Clean HTTP client implementation using `http` package with centralized interceptors.

### **Backend (REST API)**
* **Framework:** [Django](https://www.djangoproject.com/) & [Django REST Framework (DRF)](https://www.django-rest-framework.org/)
* **Database:** PostgreSQL / SQLite
* **Deployment:** Hosted on Render cloud platform.

---

## 📡 API Architecture Overview

The API endpoints provided by the Django backend:

### **Accounts Service (`/api/accounts/`)**
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/accounts/register/` | Register new landlord or tenant account |
| `POST` | `/api/accounts/login/` | Authenticate user & return JWT token |

### **Property Listing Service (`/api/listing/properties/`)**
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/listing/properties/` | Fetch all active listings |
| `POST` | `/api/listing/properties/create/` | Create a new property listing |
| `GET` | `/api/listing/properties/{id}/` | Fetch single property details |
| `PUT` | `/api/listing/properties/{id}/update/` | Complete update of a property listing |
| `PATCH` | `/api/listing/properties/{id}/partial-update/` | Partial update of specific property fields |
| `DELETE` | `/api/listing/properties/{id}/delete/` | Remove a property listing |

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0`)
* [Python 3.10+](https://www.python.org/downloads/)
* [Git](https://git-scm.com/)

---

### 1. Backend Setup (Django)

```bash
# Clone the repository
git clone https://github.com/your-username/bluenest.orig.git
cd bluenest/aws_grp_task-backend

# Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Start development server
python manage.py runserver
```

The backend server will run at `http://127.0.0.1:8000/`.

---

### 2. Frontend Setup (Flutter)

```bash
# Navigate to flutter project directory
cd ../bluenest-frontend

# Get dependencies
flutter pub get

# Run app on connected device or emulator
flutter run
```

> **Note for Chrome / Web Development:** Ensure CORS header configurations are enabled on your backend if serving requests across origins.

---

## 📂 Project Directory Structure

```text
bluenest/
├── aws_grp_task-backend/       # Django Backend REST API
│   ├── accounts/               # Authentication & User Management
│   ├── bluenest/               # Django Core Settings & URLs
│   ├── listing/                # Property Models, Serializers & Views
│   ├── inquiries/              # Tenant Inquiry Management Module
│   ├── tenancy/                # Agreements & Tenancy Module
│   └── manage.py
│
└── bluenest_frontend/          # Flutter Cross-Platform Application
    ├── lib/
    │   ├── core/               # App constants, themes, routing
    │   ├── models/             # Property & User Dart models
    │   ├── services/           # ApiService & PropertyService HTTP handlers
    │   ├── screens/            # UI Screens (MyProperties, AddEditProperty, etc.)
    │   └── widgets/            # Reusable UI Cards, Empty & Loading views
    └── pubspec.yaml
```

---

## 🗺️ Roadmap & Future Enhancements

- [ ] Direct landlord-tenant in-app messaging system.
- [ ] Advanced filter & search parameters (Rent price range, location tags, BHK filters).
- [ ] Interactive Map view for property locations.
- [ ] Online rent payments and tenancy agreement signing integration.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.