// Import the functions you need from the SDKs you need
const { initializeApp } = require("firebase/app");
const { getStorage } = require("firebase/storage");
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyD31SJ3MnsYmSt2h73oHOC4i5XRKYbRF3U",
  authDomain: "hidden-gems-travel-cf03e.firebaseapp.com",
  projectId: "hidden-gems-travel-cf03e",
  storageBucket: "hidden-gems-travel-cf03e.appspot.com",
  messagingSenderId: "791536054700",
  appId: "1:791536054700:web:aeb71e050f6c2e12704a09",
  measurementId: "G-L71YE9YRSV"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

const bucket = getStorage(app);

module.exports =  { bucket };