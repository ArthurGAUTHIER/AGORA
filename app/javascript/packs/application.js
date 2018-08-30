import "bootstrap";

const buttons = document.querySelectorAll('.tablinks')

buttons.forEach((button) => {
  button.addEventListener('click', (event) => {
    console.log(event.target.innerText)
  })
})
