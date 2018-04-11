import React from 'react'
import ReactDOM from 'react-dom'
import App from 'containers/App'

document.addEventListener('DOMContentLoaded', () => {
  const app = document.querySelector('#app')
  ReactDOM.render(<App />, app)
})