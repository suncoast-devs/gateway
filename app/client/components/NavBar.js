import React from 'react'
import { Navbar, AnchorButton, Button, Alignment } from '@blueprintjs/core'
import { icon } from '../images'
import { Container } from './Container'
import { staticRoutes } from '../routes'

export class NavBar extends React.Component {
  state = {
    signedIn: false,
  }

  componentDidMount() {
    this.setState({ signedIn: document.body.dataset.signedIn === 'true' })
  }

  render() {
    return (
      <Navbar>
        <Container>
          <Navbar.Group align={Alignment.LEFT}>
            <Navbar.Heading>
              <img src={icon} height={32} width={32} alt="SDG Button" />
            </Navbar.Heading>
            <Button className="bp3-minimal" icon="home" text="Home" />
          </Navbar.Group>
          <Navbar.Group align={Alignment.RIGHT}>
            {this.state.signedIn ? (
              <AnchorButton
                href={staticRoutes.signOut}
                minimal={true}
                icon="log-out"
              />
            ) : (
              <AnchorButton
                href={staticRoutes.signIn}
                minimal={true}
                icon="log-in"
              />
            )}
          </Navbar.Group>
        </Container>
      </Navbar>
    )
  }
}
