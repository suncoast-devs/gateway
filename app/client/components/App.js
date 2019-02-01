import React, { Fragment } from 'react'
import { NavBar } from './NavBar'
import { Container } from './Container'

export class App extends React.Component {
  render() {
    return (
      <Fragment>
        <NavBar />
        <Container>...</Container>
      </Fragment>
    )
  }
}
