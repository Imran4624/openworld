importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyAZskYtzIcny9p5Ah9VDTJFcYNeS_X_Wv8",
  authDomain: "boilerplatedev-52f7d.firebaseapp.com",
  projectId: "boilerplatedev-52f7d",
  storageBucket: "boilerplatedev-52f7d.firebasestorage.app",
  messagingSenderId: "99734603401",
  appId: "1:997346034018:web:c0e9e4b008ec175552ac3b",
});

const messaging = firebase.messaging();

// Optional background handler
messaging.onBackgroundMessage((payload) => {
  console.log("Received background message:", payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/firebase-logo.png", // Path relative to root of your site
  };

  return self.registration.showNotification(
    notificationTitle,
    notificationOptions
  );
});
