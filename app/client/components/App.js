import React from 'react'
import { Router } from '@reach/router'
import { Footer, NavBar, People } from '.'

export class App extends React.Component {
  render() {
    return (
      <>
        <NavBar />
        <Router>
          <People path="/" />
        </Router>
        <Footer />
      </>
    )
  }
}
