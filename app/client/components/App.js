import React, { Fragment } from 'react'
import { Container, NavBar, PeopleList } from '.'

export class App extends React.Component {
  render() {
    return (
      <Fragment>
        <NavBar />
        <Container>
          <PeopleList />
        </Container>
      </Fragment>
    )
  }
}
