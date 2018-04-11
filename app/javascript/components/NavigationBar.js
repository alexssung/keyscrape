import React from 'react'

export default class NavigationBar extends React.Component {
  render() {
    return (
      <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
          <a class="navbar-brand" href="#">Keyscrape</a>
          <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav ml-auto">
              <li class="nav-item">
                <a class="nav-link" href="/users/sign_out" data-method="delete">Log out</a>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    )
  }
}