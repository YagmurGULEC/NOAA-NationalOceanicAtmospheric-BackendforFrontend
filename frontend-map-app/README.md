# 📍 Leaflet Map in Next.js with Dynamic Points

This project is a **Next.js** application that uses **Leaflet** to display an interactive map. It dynamically generates random points inside the visible bounding box and updates them as the user moves or zooms.

## 🚀 Features
- 📌 **Next.js 13+ App Router**
- 🗺️ **Leaflet Map Integration**
- 🔄 **Dynamic Point Generation** (inside bounding box)
- 🖼️ **Custom Tile Layers** (showing only place names)
- 🎯 **Zoom & Bounding Box Tracking**

## 🛠 Installation & Setup

### 1️⃣ Clone the Repository
```sh
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

### 2️⃣ Install Dependencies
```sh
npm install
```

### 3️⃣ Start the Development Server
```sh
npm run dev
```

📌 **Visit:** `http://localhost:3000` in your browser.

---

## 📌 Technologies Used
- **Next.js** (React Framework)
- **Leaflet** (Interactive Maps)
- **React-Leaflet** (React bindings for Leaflet)
- **TypeScript** (Strong typing)

---

## 📜 Project Structure
```
.
├── README.md
├── eslint.config.mjs
├── next-env.d.ts
├── next.config.ts
├── package-lock.json
├── package.json
├── public
├── src
│   ├── app
│   │   ├── favicon.ico
│   │   ├── globals.css
│   │   ├── layout.tsx
│   │   ├── page.module.css
│   │   └── page.tsx
│   └── components
│       ├── LeafletMap.tsx
│       └── MapComponent.tsx
└── tsconfig.json

```

---

## 🛠 Dependencies
```json
{
  "dependencies": {
    "leaflet": "^1.9.4",
    "next": "15.2.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "react-leaflet": "^5.0.0"
  },
}

```

---

## 🗺️ Usage
### 📍 Displaying a Map
- The map is centered at **London (51.505, -0.09)**.
- The map updates dynamically based on user **zoom & movement**.
- **Random points** are generated inside the bounding box on movement.

### 🔄 How Points Are Generated
- **5-10 random points** are placed **inside the visible bounding box**.
- Clicking a **point** shows its latitude & longitude.

---

## 🎨 Customization
### 🌍 Change the Default Loc