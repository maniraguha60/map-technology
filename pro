npx create-expo-app smart-transport-app
cd smart-transport-app
npm install axiosimport React, { useState } from "react";
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  FlatList
} from "react-native";
import axios from "axios";

export default function App() {
  const [place, setPlace] = useState("");
  const [buses, setBuses] = useState([]);

  const searchBuses = async () => {
    try {
      const res = await axios.post(
        "http://YOUR_IP:5000/api/buses/nearby",
        { place }
      );
      setBuses(res.data);
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Smart Transport 🇷🇼</Text>

      {/* Input (District-Sector) */}
      <TextInput
        style={styles.input}
        placeholder="Urugero: Gasabo-Kimironko"
        value={place}
        onChangeText={setPlace}
      />

      {/* Button */}
      <TouchableOpacity style={styles.button} onPress={searchBuses}>
        <Text style={styles.buttonText}>Reba Imodoka</Text>
      </TouchableOpacity>

      {/* Bus List */}
      <FlatList
        data={buses}
        keyExtractor={(item) => item._id}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <Text style={styles.busName}>{item.name}</Text>
            <Text>📍 Distance: {item.distance} km</Text>
            <Text>⏱ ETA: {item.eta} min</Text>
            <Text>🪑 Seats: {item.seatsAvailable}</Text>
          </View>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: "#f5f5f5"
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
    marginBottom: 20,
    textAlign: "center"
  },
  input: {
    backgroundColor: "#fff",
    padding: 12,
    borderRadius: 10,
    marginBottom: 10
  },
  button: {
    backgroundColor: "#007bff",
    padding: 15,
    borderRadius: 10,
    marginBottom: 20
  },
  buttonText: {
    color: "#fff",
    textAlign: "center",
    fontWeight: "bold"
  },
  card: {
    backgroundColor: "#fff",
    padding: 15,
    borderRadius: 10,
    marginBottom: 10
  },
  busName: {
    fontSize: 18,
    fontWeight: "bold"
  }
});"http://YOUR_IP:5000/api/buses/nearby"http://192.168.1.5:5000/api/buses/nearbynpx expo startnpm install @react-native-picker/picker react-native-mapsimport React, { useState } from "react";
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  FlatList
} from "react-native";
import { Picker } from "@react-native-picker/picker";
import MapView, { Marker } from "react-native-maps";
import axios from "axios";

export default function App() {
  const [district, setDistrict] = useState("Gasabo");
  const [sector, setSector] = useState("Kimironko");
  const [buses, setBuses] = useState([]);

  const searchBuses = async () => {
    const place = `${district}-${sector}`;

    const res = await axios.post(
      "http://YOUR_IP:5000/api/buses/nearby",
      { place }
    );

    setBuses(res.data);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Smart Transport 🇷🇼</Text>

      {/* District Picker */}
      <Picker
        selectedValue={district}
        onValueChange={(itemValue) => setDistrict(itemValue)}
      >
        <Picker.Item label="Gasabo" value="Gasabo" />
        <Picker.Item label="Kicukiro" value="Kicukiro" />
        <Picker.Item label="Nyarugenge" value="Nyarugenge" />
      </Picker>

      {/* Sector Picker */}
      <Picker
        selectedValue={sector}
        onValueChange={(itemValue) => setSector(itemValue)}
      >
        <Picker.Item label="Kimironko" value="Kimironko" />
        <Picker.Item label="Nyabugogo" value="Nyabugogo" />
        <Picker.Item label="Kagarama" value="Kagarama" />
      </Picker>

      {/* Button */}
      <TouchableOpacity style={styles.button} onPress={searchBuses}>
        <Text style={styles.buttonText}>Reba Imodoka</Text>
      </TouchableOpacity>

      {/* Map */}
      <MapView
        style={styles.map}
        initialRegion={{
          latitude: -1.95,
          longitude: 30.06,
          latitudeDelta: 0.05,
          longitudeDelta: 0.05
        }}
      >
        {buses.map((bus) => (
          <Marker
            key={bus._id}
            coordinate={{
              latitude: bus.latitude,
              longitude: bus.longitude
            }}
            title={bus.name}
            description={`ETA: ${bus.eta} min`}
          />
        ))}
      </MapView>

      {/* Bus List */}
      <FlatList
        data={buses}
        keyExtractor={(item) => item._id}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <Text style={styles.busName}>{item.name}</Text>
            <Text>⏱ {item.eta} min</Text>
            <Text>🪑 {item.seatsAvailable} seats</Text>
          </View>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 10 },
  title: {
    fontSize: 22,
    fontWeight: "bold",
    textAlign: "center"
  },
  button: {
    backgroundColor: "green",
    padding: 12,
    borderRadius: 10,
    marginVertical: 10
  },
  buttonText: {
    color: "#fff",
    textAlign: "center",
    fontWeight: "bold"
  },
  map: {
    height: 200,
    marginVertical: 10
  },
  card: {
    backgroundColor: "#fff",
    padding: 10,
    marginVertical: 5,
    borderRadius: 10
  },
  busName: {
    fontWeight: "bold"
  }
});npx expo install react-native-mapsnpx expo install expo-notificationsimport * as Notifications from "expo-notifications";
import { useEffect } from "react";useEffect(() => {
  Notifications.requestPermissionsAsync();
}, []);const sendNotification = async (title, body) => {
  await Notifications.scheduleNotificationAsync({
    content: {
      title,
      body
    },
    trigger: null
  });
};const searchBuses = async () => {
  const place = `${district}-${sector}`;

  const res = await axios.post(
    "http://YOUR_IP:5000/api/buses/nearby",
    { place }
  );

  setBuses(res.data);

  // 🔔 Notification logic
  res.data.forEach((bus) => {
    if (bus.eta <= 3) {
      sendNotification(
        "🚐 Bus iri hafi!",
        `${bus.name} iragera mu minota ${bus.eta}`
      );
    }

    if (bus.seatsAvailable <= 3) {
      sendNotification(
        "⚠️ Imyanya iri gushira",
        `${bus.name} isigaje seats ${bus.seatsAvailable}`
      );
    }
  });
};res.data.forEach((bus) => {
  if (bus.seatsAvailable < 3) {
    sendNotification(
      "🤖 AI Suggestion",
      `${bus.name} ishobora kuba yuzuye, reba indi modoka`
    );
  }
});npm install axiosconst express = require("express");
const router = express.Router();
const axios = require("axios");

// POST payment
router.post("/pay", async (req, res) => {
  const { amount, phoneNumber, userId, plan } = req.body;

  try {
    // Example: call MoMo API (simplified)
    const momoRes = await axios.post("https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay", {
      amount: amount.toString(),
      currency: "RWF",
      externalId: userId,
      payer: { partyIdType: "MSISDN", partyId: phoneNumber },
      payerMessage: `Payment for ${plan}`,
      payeeNote: "Smart Transport Rwanda"
    }, {
      headers: {
        Authorization: "Bearer YOUR_ACCESS_TOKEN",
        "X-Target-Environment": "sandbox",
        "Ocp-Apim-Subscription-Key": "YOUR_SUBSCRIPTION_KEY"
      }
    });

    res.json({ success: true, data: momoRes.data });
  } catch (err) {
    console.log(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

module.exports = router;<TouchableOpacity
  style={styles.button}
  onPress={() => {
    axios.post("http://YOUR_IP:5000/api/payment/pay", {
      amount: 50, // change depending on plan
      phoneNumber: "0786480352",
      userId: "USER123",
      plan: "Daily"
    })
    .then(res => alert("Payment initiated!"))
    .catch(err => console.log(err));
  }}
>
  <Text style={styles.buttonText}>Pay Daily 50 Frw</Text>
</TouchableOpacity>smart-transport/
├── backend/
│   ├── server.js
│   ├── models/
│   │    ├── Bus.js
│   │    └── User.js
│   ├── routes/
│   │    ├── busRoutes.js
│   │    ├── paymentRoutes.js
│   │    └── userRoutes.js
│   ├── controllers/
│   │    ├── busController.js
│   │    └── paymentController.js
│   ├── config/
│   │    ├── distance.js
│   │    └── locations.js
│   └── .env
├── frontend/
│   ├── App.js
│   ├── components/
│   │    ├── BusCard.js
│   │    └── MapViewComponent.js
│   └── assets/
│        └── bus-icons/
└── README.mdpro
└── README.mdimport React, { useEffect, useState } from "react";
import axios from "axios";
import { Line } from "react-chartjs-2";

export default function Dashboard() {
  const [buses, setBuses] = useState([]);
  const [payments, setPayments] = useState([]);

  useEffect(() => {
    axios.get("https://YOUR_BACKEND_URL/api/buses").then((res) => setBuses(res.data));
    axios.get("https://YOUR_BACKEND_URL/api/payments").then((res) => setPayments(res.data));
  }, []);

  const chartData = {
    labels: payments.map(p => p.date),
    datasets: [
      {
        label: "Daily Revenue",
        data: payments.map(p => p.amount),
        backgroundColor: "rgba(34,197,94,0.5)"
      }
    ]
  };

  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-6">Admin Dashboard 🇷🇼</h1>

      <div className="grid grid-cols-3 gap-6 mb-6">
        <div className="bg-green-100 p-4 rounded shadow">Buses: {buses.length}</div>
        <div className="bg-blue-100 p-4 rounded shadow">Payments: {payments.length}</div>
        <div className="bg-yellow-100 p-4 rounded shadow">Users: 100</div>
      </div>

      <div className="bg-white p-6 rounded shadow">
        <h2 className="text-xl font-bold mb-4">Revenue Chart</h2>
        <Line data={chartData} />
      </div>
    </div>
  );
}{
  "expo": {
    "version": "1.0.0",
    "android": { "versionCode": 1 }
  }
}npm install -g expo-cliexpo build:android -t apk// aiController.js
const getBestBus = (buses) => {
  // Filter buses with seats > 2
  const availableBuses = buses.filter(bus => bus.seatsAvailable > 2);

  if (!availableBuses.length) return null;

  // Sort by ETA
  availableBuses.sort((a, b) => a.eta - b.eta);

  // Return best bus
  return availableBuses[0];
};

module.exports = { getBestBus };const { getBestBus } = require("../controllers/aiController");

router.post("/nearby-ai", async (req, res) => {
  const { place } = req.body;

  const buses = await Bus.find(); // fetch all buses for that place
  const bestBus = getBestBus(buses);

  if (!bestBus) {
    return res.json({ message: "All buses are full, wait for next bus" });
  }

  res.json({
    bestBus,
    message: `We suggest taking ${bestBus.name}, arriving in ${bestBus.eta} min`
  });
});{aiSuggestion && (
  <View style={styles.aiCard}>
    <Text>🤖 AI Suggestion:</Text>
    <Text>{aiSuggestion.message}</Text>
  </View>
)}PORT=5000
MONGO_URI=YOUR_MONGODB_URI
MOMO_API_KEY=YOUR_MOMO_KEY
JWT_SECRET=YOUR_SECRET_KEYconst jwt = require("jsonwebtoken");

const verifyToken = (req, res, next) => {
  const token = req.headers["authorization"];
  if (!token) return res.status(401).json({ message: "No token provided" });

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) return res.status(403).json({ message: "Invalid token" });
    req.userId = decoded.id;
    next();
  });
};

module.exports = verifyToken;const bcrypt = require("bcrypt");

const hashPassword = async (password) => {
  const salt = await bcrypt.genSalt(10);
  return await bcrypt.hash(password, salt);
};

const comparePassword = async (password, hashed) => {
  return await bcrypt.compare(password, hashed);
};const rateLimit = require("express-rate-limit");

const limiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 100, // max requests per IP
  message: "Too many requests from this IP, try again later"
});

app.use("/api/", limiter);const cors = require("cors");

app.use(cors({
  origin: "https://your-frontend-domain.com", // only allow frontend domain
  methods: ["GET", "POST", "PUT", "DELETE"],
  credentials: true
}));import * as SecureStore from "expo-secure-store";

// Save token
await SecureStore.setItemAsync("userToken", token);

// Read token
const token = await SecureStore.getItemAsync("userToken");const helmet = require("helmet");
app.use(helmet());pro
