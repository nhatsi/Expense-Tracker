const { initializeApp } = require("firebase/app");
const {
  getFirestore,
  doc,
  setDoc,
  Timestamp,
} = require("firebase/firestore");

const firebaseConfig = {
  apiKey: "DÁN_API_KEY_CỦA_BẠN",
  authDomain: "expense-tracker-nhat-2026.firebaseapp.com",
  projectId: "expense-tracker-nhat-2026",
  storageBucket: "expense-tracker-nhat-2026.firebasestorage.app",
  messagingSenderId: "133599635280",
  appId: "1:133599635280:web:8d0d009f8add632ad22e55",
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

const categories = [
  {
    categoryId: "cat_food",
    name: "Ăn uống",
    totalExpenses: 0,
    icon: "food",
    color: 4294959282,
  },
  {
    categoryId: "cat_shopping",
    name: "Mua sắm",
    totalExpenses: 0,
    icon: "shopping",
    color: 4292984551,
  },
  {
    categoryId: "cat_home",
    name: "Nhà cửa",
    totalExpenses: 0,
    icon: "home",
    color: 4291354825,
  },
  {
    categoryId: "cat_travel",
    name: "Di chuyển",
    totalExpenses: 0,
    icon: "travel",
    color: 4290493371,
  },
  {
    categoryId: "cat_entertainment",
    name: "Giải trí",
    totalExpenses: 0,
    icon: "entertainment",
    color: 4294951116,
  },
  {
    categoryId: "cat_pet",
    name: "Thú cưng",
    totalExpenses: 0,
    icon: "pet",
    color: 4292325576,
  },
  {
    categoryId: "cat_tech",
    name: "Công nghệ",
    totalExpenses: 0,
    icon: "tech",
    color: 4291807692,
  },
];

const expenses = [
  {
    expenseId: "exp_001",
    category: categories[0],
    date: Timestamp.fromDate(new Date(2026, 4, 1)),
    amount: 45000,
  },
  {
    expenseId: "exp_002",
    category: categories[0],
    date: Timestamp.fromDate(new Date(2026, 4, 2)),
    amount: 75000,
  },
  {
    expenseId: "exp_003",
    category: categories[1],
    date: Timestamp.fromDate(new Date(2026, 4, 3)),
    amount: 250000,
  },
  {
    expenseId: "exp_004",
    category: categories[2],
    date: Timestamp.fromDate(new Date(2026, 4, 4)),
    amount: 120000,
  },
  {
    expenseId: "exp_005",
    category: categories[3],
    date: Timestamp.fromDate(new Date(2026, 4, 5)),
    amount: 30000,
  },
  {
    expenseId: "exp_006",
    category: categories[4],
    date: Timestamp.fromDate(new Date(2026, 4, 6)),
    amount: 90000,
  },
  {
    expenseId: "exp_007",
    category: categories[6],
    date: Timestamp.fromDate(new Date(2026, 4, 7)),
    amount: 350000,
  },
];

async function seed() {
  for (const category of categories) {
    await setDoc(doc(db, "categories", category.categoryId), category);
  }

  for (const expense of expenses) {
    await setDoc(doc(db, "expenses", expense.expenseId), expense);
  }

  console.log("Seed Firebase thành công!");
}

seed().catch(console.error);