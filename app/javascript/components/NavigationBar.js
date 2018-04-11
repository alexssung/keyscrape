import React from 'react'

export default class NavigationBar extends React.Component {
  render() {
    return (
      <nav className="navbar navbar-expand-lg navbar-dark bg-dark">
        <div className="container">
          <a className="navbar-brand" href="#">Keyscrape</a>
          <div className="collapse navbar-collapse" id="navbarResponsive">
            <ul className="navbar-nav ml-auto">
              <li className="nav-item">
                <a className="nav-link" href="/users/sign_out" data-method="delete">Log out</a>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    )
  }
}