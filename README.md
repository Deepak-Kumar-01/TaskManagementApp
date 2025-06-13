# Task Manager App

A simple task management application built in **Flutter** for gig workers, submitted as part of the Flutter Developer Internship assignment at **Whatbytes**.

---

## ✅ Implemented Features

1. **Authentication**
   - Email/password **login & registration**  
   - Powered by **Firebase Authentication**  

2. **Task CRUD**
   - **Create**, **edit**, **delete**, and **view** tasks  
   - Task fields: **Title**, **Description**, **Due Date**, **Priority** (Low/Med/High), **Completion Status**

3. **Task Filtering & Sorting**
   - Filter by **Priority** and **Status** (Completed/Incomplete)  
   - Automatically **sort tasks** by due date (earliest → latest)

4. **Task Completion**
   - **Mark tasks** as complete/incomplete with a single tap  
   - Visual indicators for completed tasks

5. **Responsive UI**
   - Clean, Material‑design based screens  
   - Intuitive navigation between **Login**, **Task List**, **Task Form**, and **Filters**

---

## 🛠 Tech Stack

| Layer               | Technology                   |
| ------------------- | ---------------------------- |
| **Framework**       | Flutter                      |
| **Authentication**  | Firebase Authentication      |
| **Database**        | Firebase Firestore           |
| **State Management**| Bloc (`flutter_bloc`)        |
| **UI**              | Material Design Widgets      |

---

## 🧪 Setup Instructions

```bash
# Clone the repository
git clone https://github.com/Deepak-Kumar-01/TaskManagementApp.git
cd task-manager-app

# Install dependencies
flutter pub get

# Firebase Setup
# 1. Create a Firebase project
# 2. Enable Email/Password sign-in
# 3. Download & replace:
#    - android/app/google-services.json
#    - ios/Runner/GoogleService-Info.plist

# Run the app
flutter run
