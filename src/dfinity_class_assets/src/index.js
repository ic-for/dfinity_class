import { dfinity_class } from "../../declarations/dfinity_class";

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  // Interact with dfinity_class actor, calling the greet method
  const greeting = await dfinity_class.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
