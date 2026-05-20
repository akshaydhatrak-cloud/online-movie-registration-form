const form = document.querySelector("#registration-form");
const message = document.querySelector("#form-message");
const password = document.querySelector("#password");
const confirmPassword = document.querySelector("#confirm-password");

form.addEventListener("submit", (event) => {
  message.textContent = "";

  if (!form.checkValidity()) {
    event.preventDefault();
    message.textContent = "Please complete all required fields with valid details.";
    form.reportValidity();
    return;
  }

  if (password.value !== confirmPassword.value) {
    event.preventDefault();
    message.textContent = "Passwords must match.";
    confirmPassword.focus();
  }
});
