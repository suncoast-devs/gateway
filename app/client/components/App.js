import React, { Fragment } from 'react'
import { Container, NavBar } from '.'

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
