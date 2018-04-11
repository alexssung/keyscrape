import React from 'react'
import NavigationBar from 'components/NavigationBar'
import Dashboard from 'containers/Dashboard'

export default class App extends React.Component {
  render() {
    return (
      <div id="main-wrapper">
        <NavigationBar />
        <Dashboard />
      </div>
    )
  }
}