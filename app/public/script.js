function addTitleListeners() {
  const todoDescriptions = document.querySelectorAll(".todo-description");
  const todoTitles = document.querySelectorAll(".todo-title");
  if (todoTitles) {
    todoTitles.forEach(el => {
      el.addEventListener("click", () => {
        const id = el.dataset.id;
        const desc = Array.from(todoDescriptions).filter(
          el => el.dataset.id === id
        )[0];
        desc.classList.toggle("hidden");
      });
    });
  }
}

function addEditTodoTitleListener() {
  const title = document.querySelector(".todo-title");
  const input = document.querySelector("input[data-input]");
  if (input) {
    input.addEventListener("input", e => {
      title.textContent = e.target.value;
    });
  }
}

function addFormInputListeners() {
  const labels = document.querySelectorAll(".form-input-label");
  const inputs = document.querySelectorAll(".form-input");

  if (labels) {
    labels.forEach(el => {
      el.addEventListener("click", e => {
        el.nextElementSibling.focus();
      });
    });
  }

  if (inputs) {
    inputs.forEach(el => {
      el.addEventListener("focus", () => {
        el.previousElementSibling.classList.add("focused-label");
        el.parentElement.classList.add("focused-wrap");
      });
    });

    inputs.forEach(el => {
      el.addEventListener("blur", () => {
        if (!el.value.length) {
          el.previousElementSibling.classList.remove("focused-label");
          el.parentElement.classList.remove("focused-wrap");
        }
      });
    });
  }
}

document.addEventListener("DOMContentLoaded", () => {
  addTitleListeners();
  addEditTodoTitleListener();
  addFormInputListeners();
});
