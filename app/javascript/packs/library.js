console.log('Hello Libraries')

const nb = parseInt(document.getElementById('next').value, 10) - 1

document.getElementById('blacklist').addEventListener('click', (event) => {
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
