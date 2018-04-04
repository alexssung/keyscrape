import React from 'react'
import ReactDOM from 'react-dom'
import Dashboard from 'containers/Dashboard'

document.addEventListener('DOMContentLoaded', () => {
  const app = document.querySelector('#app')
  ReactDOM.render(<Dashboard />, app)
})