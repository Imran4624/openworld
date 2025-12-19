importScripts("https://www.gstatic.com/firebasejs/8.2.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.2.0/firebase-messaging.js");

// Initialize Firebase
firebase.initializeApp({
  apiKey: "AIzaSyAZskYtzIcny9p5Ah9VDTJFcYNeS_X_Wv8",
  authDomain: "boilerplatedev-52f7d.firebaseapp.com",
  projectId: "boilerplatedev-52f7d",
  storageBucket: "boilerplatedev-52f7d.firebasestorage.app",
  messagingSenderId: "997346034018",
  appId: "1:997346034018:web:c0e9e4b008ec175552ac3b",
  measurementId: "G-4H5YXFXM8L",
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log("Received background message: ", payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/firebase-logo.png",
  };

  return self.registration.showNotification(
    notificationTitle,
    notificationOptions
  );
});
