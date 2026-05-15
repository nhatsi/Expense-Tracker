const { initializeApp } = require("firebase/app");
const {
  getFirestore,
  doc,
  updateDoc,
} = require("firebase/firestore");

const firebaseConfig = {
  apiKey: "AIzaSyDUHrT0ncEmavrIWZNdrVNSSlGvs0GcM4g",
  authDomain: "expense-tracker-nhat-2026.firebaseapp.com",
  projectId: "expense-tracker-nhat-2026",
  storageBucket: "expense-tracker-nhat-2026.firebasestorage.app",
  messagingSenderId: "133599635280",
  appId: "1:133599635280:web:8d0d009f8add632ad22e55",
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

const amounts = [
  ["exp_001", 10],
  ["exp_002", 20],
  ["exp_003", 45],
  ["exp_004", 120],
  ["exp_005", 250],
  ["exp_006", 35],
  ["exp_007", 80],
  ["exp_008", 15],
];

async function fixAmounts() {
  for (const [id, amount] of amounts) {
    await updateDoc(doc(db, "expenses", id), {
      amount: amount,
    });
    console.log(`Updated ${id} = $${amount}`);
  }

  console.log("Sửa amount Firebase thành công!");
}

fixAmounts().catch(console.error);