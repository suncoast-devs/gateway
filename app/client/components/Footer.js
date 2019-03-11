import React from 'react'
import { banner } from '../images'

export const Footer = () => (
  <footer className="footer">
    <div className="content has-text-centered">
      <p>
        <a
          className="has-text-grey-dark"
          href="https://github.io/suncoast-devs/gateway"
        >
          <span className="icon is-large">
            <i className="fab fa-github fa-lg" />
          </span>
        </a>
      </p>
      <p>
        <a href="https://suncoast.io">
          <img src={banner} width="150" height="60" />
        </a>
      </p>
      <p>
        <strong>Gateway</strong> by{' '}
        <a href="https://suncoast.io">Suncoast Developers Guild</a>. The source
        code is licensed{' '}
        <a href="http://opensource.org/licenses/mit-license.php">MIT</a>.<br />
        Made with
        <span className="icon">
          {' '}
          <i className="fas fa-heart has-text-danger" />
        </span>
        in St. Petersburg, FL.
      </p>
    </div>
  </footer>
)
