import { initializeApp } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-app.js";
import {
  getAuth,
  GoogleAuthProvider,
  signInWithPopup,
  signOut,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
} from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";

// Fetch Firebase config from Flask API
fetch("http://127.0.0.1:5001/api/auth/firebase-config")
  .then((response) => response.json())
  .then((firebaseConfig) => {
    // Initialize Firebase
    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    auth.languageCode = "en";
    const provider = new GoogleAuthProvider();

    // Google Login Button
    const googleLogin = document.getElementById("google-login-btn");
    const emailLogin = document.getElementById("email-login-btn");
    if (googleLogin) {
      googleLogin.addEventListener("click", function () {
        signInWithPopup(auth, provider)
          .then((result) => {
            const user = result.user;

            // Save user info to localStorage
            localStorage.setItem(
              "user",
              JSON.stringify({
                email: user.email,
                google_uid: user.uid,
                full_name: user.displayName,
              }),
            );


            addUserToDatabase(user.email, user.uid, user.displayName);
            alert("Welcome " + user.displayName);
            window.location.href = "/frontend/dashboard.html";
          })
          .catch((error) => {
            console.error("Error during login:", error);
          });
      });
    }
    if (emailLogin) {
      emailLogin.addEventListener("click", function () {
        const email = document.getElementById("emailInput").value;
        const password = document.getElementById("passwordInput").value;

        signInWithEmailAndPassword(auth, email, password)
          .then((userCredential) => {
            const user = userCredential.user;
            addUserToDatabase(user.email, user.uid, user.displayName);
            alert("Welcome " + user.email);
            window.location.href = "/frontend/dashboard.html";
          })
          .catch((error) => {
            console.error("Error during email/password login:", error);
            alert("Login failed: " + error.message);
          });
      });
    }


    // Google Sign-out Button
    const googleSignout = document.getElementById("google-signout-btn");
    if (googleSignout) {
      googleSignout.addEventListener("click", function () {
        signOut(auth)
          .then(() => {
            alert("Signed out");
            window.location.href = "/frontend/index.html";
          })
          .catch((error) => {
            console.error("Error during sign-out:", error);
          });
      });
    }
  })
  .catch((error) => console.error("Failed to fetch Firebase config:", error));

function addUserToDatabase(email, uid, displayName) {
  // Send data to backend
  fetch("http://127.0.0.1:5001/api/users/", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      email: email,
      google_uid: uid,
      full_name: displayName,
    }),
  })
    .then((response) => response.json())
    .then((data) => {
      console.log("User added to backend:", data);
    })
    .catch((error) => {
      console.error("Error adding user to backend:", error);
    });
}