# ParkFlow Mobility – Parking Management System

**BS Software Engineering Mobile Application Development Mid-Term Project**

---

## 📌 Project Overview

**ParkFlow Mobility** is a complete, production-ready, full-featured Android application designed to digitize and automate parking space management for universities, corporate offices, commercial malls, and healthcare institutions. Built using **Flutter** and **SQLite (`sqflite`)**, the app follows the **Google Stitch UI Design** specifications (#17365D Dark Navy theme, #F4F7FC Light Background, Green/Red occupancy indicators).

---

## 🚀 Key Features & Completed Functionality

1. **Splash Screen**: Animated branding logo and automated SQLite initialization.
2. **Dashboard**: Real-time calculated database statistics (Total slots, Available slots, Occupied slots, Active sessions, Today's exits, Today's revenue, Occupancy %) with quick action buttons and recent activity feed.
3. **Parking Slots Grid**: Interactive grid displaying 20 slots (`P01`–`P20`), occupancy status badges, filter controls, and slot detail dialogs.
4. **Parking Slot Details Screen**: Full screen view showing slot status, current vehicle check-in info, and complete slot usage history.
5. **Vehicle Registration**: Register new vehicles with Owner Name, Registration Number, Vehicle Type (Car, Motorcycle, Other), Contact Phone, and Notes. Includes validation & duplicate number checks.
6. **Vehicle List Screen**: Search registered vehicles by owner or registration number, view active parking status, edit vehicle info, and safely delete unparked vehicles.
7. **Vehicle Details Screen**: Dedicated vehicle profile showing registration details, current parking state, and vehicle parking history.
8. **Vehicle Entry / Check-In**: Assign registered vehicles to available parking slots with auto-timestamping and atomic database transaction protection.
9. **Vehicle Exit / Check-Out**: Search active parked vehicles, automatically record exit timestamp, calculate total parking duration and total fee using configured hourly rate rules (ceiling of started hours with 1-hour minimum charge), and display parking bill receipt confirmation.
10. **Parking History**: View all completed parking sessions with search by vehicle/owner, date range filter, vehicle type filter, and sort order controls.
11. **Parking Reports & Analytics**: Comprehensive analytics dashboard featuring daily revenue, monthly revenue, total revenue, session counts, vehicle type breakdown, and most frequently used parking slots ranking.
12. **Parking Fee Settings**: Configure hourly rates for Cars, Motorcycles, and Other vehicles saved persistently in SQLite.
13. **Backup & Restore**: Export local JSON database backup files, restore database state, and integrate with Google Drive API cloud sync.
14. **General Settings & Data Management**: Navigation to fee settings, backup/restore, reset database data option, and application metadata.
15. **About Application Screen**: Project information, BS Software Engineering academic details, technology stack, and system specifications.

---

## 🛠️ Technology Stack

- **Framework**: Flutter (Dart SDK)
- **Local Database**: SQLite (`sqflite` & `sqflite_common_ffi` for multi-platform support)
- **Date & Time Formatting**: `intl` package
- **Database Path Management**: `path` & `path_provider`
- **Cloud Backup**: Google Drive API (`googleapis`, `google_sign_in`, `http`)
- **UI Design System**: Google Stitch Specification

---

## 🗄️ Database Architecture (SQLite Schema)

Database File: `parkflow_database.db`

### 1. `parking_slots`
- `id`: INTEGER PRIMARY KEY AUTOINCREMENT
- `slot_number`: TEXT UNIQUE NOT NULL (`P01` to `P20`)
- `status`: TEXT NOT NULL ('available' | 'occupied')
- `created_at`: TEXT

### 2. `vehicles`
- `id`: INTEGER PRIMARY KEY AUTOINCREMENT
- `owner_name`: TEXT NOT NULL
- `vehicle_number`: TEXT UNIQUE NOT NULL
- `vehicle_type`: TEXT NOT NULL ('Car' | 'Motorcycle' | 'Other')
- `contact`: TEXT
- `notes`: TEXT
- `created_at`: TEXT NOT NULL

### 3. `parking_sessions`
- `id`: INTEGER PRIMARY KEY AUTOINCREMENT
- `vehicle_id`: INTEGER NOT NULL (FOREIGN KEY -> `vehicles.id`)
- `slot_id`: INTEGER NOT NULL (FOREIGN KEY -> `parking_slots.id`)
- `entry_time`: TEXT NOT NULL
- `exit_time`: TEXT
- `duration_minutes`: INTEGER
- `hourly_rate`: REAL NOT NULL
- `fee`: REAL DEFAULT 0
- `status`: TEXT NOT NULL ('active' | 'completed')
- `created_at`: TEXT

### 4. `settings`
- `id`: INTEGER PRIMARY KEY AUTOINCREMENT
- `vehicle_type`: TEXT UNIQUE NOT NULL
- `hourly_rate`: REAL NOT NULL

---

## 💰 Parking Fee Formula

$$\text{Charged Hours} = \text{Ceiling}\left(\frac{\text{Total Duration Minutes}}{60}\right)$$

$$\text{Total Fee} = \max(1, \text{Charged Hours}) \times \text{Hourly Rate}$$

*Rule*: Non-zero parking durations are billed at a minimum of 1 hour. Rate is selected based on vehicle type from persistent settings at entry time.

---

## 💻 How to Run the Application

### Prerequisites
- Flutter SDK (v3.13+) installed.
- Android Studio / VS Code with Flutter extension.
- Connected Android Device or Emulator.

### Commands

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run Unit & Widget Tests**:
   ```bash
   flutter test
   ```

3. **Run App on Android Emulator / Physical Device**:
   ```bash
   flutter run
   ```

4. **Run App on Windows Desktop**:
   ```bash
   flutter run -d windows
   ```

---

## 📊 University Project Demonstration Steps

1. **Launch App**: Observe the animated Splash Screen with ParkFlow Mobility branding.
2. **Dashboard Overview**: Show initial statistics (20 total slots, 20 available slots, 0 occupied slots, 0% occupancy).
3. **Register Vehicle**: Navigate to "Vehicles" -> "New Vehicle", enter Owner Name: "John Doe", Reg Number: "ABC-1234", Type: "Car", Phone: "03001234567". Save record.
4. **Vehicle Check-In**: Tap "Vehicle Entry", select "ABC-1234", choose slot "P01", confirm entry.
5. **Observe Real-Time Dashboard Update**: Return to Dashboard to demonstrate occupied slots = 1, available = 19, occupancy = 5.0%, and recent activity record.
6. **Slot Grid View**: Go to "Slots Grid", observe slot P01 highlighted in RED with vehicle ABC-1234 and entry time.
7. **Vehicle Check-Out & Billing**: Tap "Vehicle Exit", select "ABC-1234", review fee breakdown dialog showing entry time, duration, and calculated fee. Confirm exit.
8. **Observe Slot Release**: Confirm slot P01 returns to GREEN ("AVAILABLE").
9. **Parking History & Receipt**: Open "History" tab to view completed session details, duration, and collected fee.
10. **Reports & Analytics**: Open "Reports" tab to demonstrate daily revenue, vehicle type breakdown, and most used slots ranking.
11. **Settings & Backup**: Navigate to "Settings" / "Backup & Restore" to demonstrate exporting local JSON backup data.
