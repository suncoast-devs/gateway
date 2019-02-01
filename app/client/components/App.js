import React from 'react'
import PropTypes from 'prop-types'

class App extends React.Component {
  render() {
    return <React.Fragment>Signed In: {this.props.signedIn}</React.Fragment>
  }
}

App.propTypes = {
  signedIn: PropTypes.bool,
}
export default App
