import { loadStripe } from "@stripe/stripe-js";

document.addEventListener("DOMContentLoaded", async () => {
  const stripe = await loadStripe("your_publishable_key");
  const elements = stripe.elements();

  const card = elements.create("card");
  card.mount("#card-element");

  const form = document.getElementById("payment-form");
  form.addEventListener("submit", async (event) => {
    event.preventDefault();

    const { token, error } = await stripe.createToken(card);

    if (error) {
      const errorElement = document.getElementById("card-errors");
      errorElement.textContent = error.message;
    } else {
      stripeTokenHandler(token);
    }
  });

  function stripeTokenHandler(token) {
    const hiddenInput = document.createElement("input");
    hiddenInput.setAttribute("type", "hidden");
    hiddenInput.setAttribute("name", "stripeToken");
    hiddenInput.setAttribute("value", token.id);
    form.appendChild(hiddenInput);

    form.submit();
  }
});
