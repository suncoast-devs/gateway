import React from 'react'

export class App extends React.Component {
  render() {
    return <div>Signed In: {document.body.dataset.signedIn}</div>
  }
}
