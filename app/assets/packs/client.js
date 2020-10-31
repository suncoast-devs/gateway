import App from '../../client/App.svelte'
import '../stylesheets/tailwind.css'
import '../../client/channels'

document.addEventListener('DOMContentLoaded', () => {
  const app = new App({ target: document.body })
  window.app = app
})
