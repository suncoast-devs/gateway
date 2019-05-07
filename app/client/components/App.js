import React from 'react'
import { Router } from '@reach/router'
import { Footer, NavBar, People, Courses } from '.'

export class App extends React.Component {
  render() {
    return (
      <>
        <NavBar />
        <Router>
          <People path="/people" />
          <Courses path="/courses" />
        </Router>
        <Footer />
      </>
    )
  }
}
