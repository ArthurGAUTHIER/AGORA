import "bootstrap";


console.log('Hello Libraries')

const nb = parseInt(document.getElementById('next').value, 10) - 1

document.getElementById('blacklist').addEventListener('click', (event) => {
  console_log('blacklist')
  sendData('blacklist')
});

document.getElementById('already_watched').addEventListener('click', (event) => {
  sendData('already_watched')
});

document.getElementById('watch_later').addEventListener('click', (event) => {
  sendData('watch_later')
});


const sendData = (bouton) => {
  fetch(`/media/${nb}/libraries`, {
    method: 'POST',
    headers: { 'Content-Type': 'app/JSON' },
    body: createLibraryJSON(bouton)
  });
}

const createLibraryJSON = (bouton) => {
  JSON.stringify({
    "blacklist": bouton === 'blacklist',
    "already_watched": bouton === 'already_watched',
    "watch_later": bouton === 'watch_later'
  })
}



function viewMultirange() {
"use strict";

var supportsMultiple = self.HTMLInputElement && "valueLow" in HTMLInputElement.prototype;

var descriptor = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, "value");

self.multirange = function(input) {
  if (supportsMultiple || input.classList.contains("multirange")) {
    return;
  }

  var value = input.getAttribute("value");
  var values = value === null ? [] : value.split(",");
  var min = +(input.min || 0);
  var max = +(input.max || 100);
  var ghost = input.cloneNode();

  input.classList.add("multirange", "original");
  ghost.classList.add("multirange", "ghost");
  // MODIF : change name of the ghost
  ghost.name = input.name.replace(']', 'max]')

  input.value = values[0] || min + (max - min) / 2;
  ghost.value = values[1] || min + (max - min) / 2;

  input.parentNode.insertBefore(ghost, input.nextSibling);

  Object.defineProperty(input, "originalValue", descriptor.get ? descriptor : {
    // Fuck you Safari >:(
    get: function() { return this.value; },
    set: function(v) { this.value = v; }
  });

  Object.defineProperties(input, {
    valueLow: {
      get: function() { return Math.min(this.originalValue, ghost.value); },
      set: function(v) { this.originalValue = v; },
      enumerable: true
    },
    valueHigh: {
      get: function() { return Math.max(this.originalValue, ghost.value); },
      set: function(v) { ghost.value = v; },
      enumerable: true
    }
  });

  if (descriptor.get) {
    // Again, fuck you Safari
    Object.defineProperty(input, "value", {
      get: function() { return this.valueLow + "," + this.valueHigh; },
      set: function(v) {
        var values = v.split(",");
        this.valueLow = values[0];
        this.valueHigh = values[1];
        update();
      },
      enumerable: true
    });
  }

  if (typeof input.oninput === "function") {
    ghost.oninput = input.oninput.bind(input);
  }

  function update() {
    ghost.style.setProperty("--low", 100 * ((input.valueLow - min) / (max - min)) + 1 + "%");
    ghost.style.setProperty("--high", 100 * ((input.valueHigh - min) / (max - min)) - 1 + "%");
  }

  input.addEventListener("input", update);
  ghost.addEventListener("input", update);

  update();
}

multirange.init = function() {
  [].slice.call(document.querySelectorAll("input[type=range][multiple]:not(.multirange)")).forEach(multirange);
}

if (document.readyState == "loading") {
  document.addEventListener("DOMContentLoaded", multirange.init);
}
else {
  multirange.init();
}

}
viewMultirange()

