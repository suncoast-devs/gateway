import React from 'react'
import ReactDOM from 'react-dom'
import { App } from '../components/App'

import '../images'
import '../stylesheets'

document.addEventListener('DOMContentLoaded', () => {
  const root = document.getElementById('root')
  if (root) {
    ReactDOM.render(<App />, root)
  }
})
