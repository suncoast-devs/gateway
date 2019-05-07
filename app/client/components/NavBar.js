import React, { useState, useEffect } from 'react'
import { Link } from '@reach/router'
import cx from 'classnames'
import { icon } from '../images'
import { Container } from './Container'
import { staticRoutes } from '../routes'

const NavLink = ({ exact, ...props }) => (
  <Link
    getProps={({ isCurrent, isPartiallyCurrent }) => ({
      className: cx('navbar-item', {
        'is-active': exact ? isCurrent : isPartiallyCurrent,
      }),
    })}
    {...props}
  />
)

export const NavBar = () => {
  const [signedIn, setSignedIn] = useState(false)
  const [isActive, setIsActive] = useState(false)

  useEffect(() => {
    setSignedIn(document.body.dataset.signedIn === 'true')
  })

  const toggle = () => setIsActive(!isActive)

  return (
    <nav
      className="navbar is-light"
      role="navigation"
      aria-label="main navigation"
    >
      <Container>
        <div className="navbar-brand">
          <Link to="/" className="navbar-item">
            <img src={icon} height={28} width={28} alt="SDG Button" />
          </Link>

          <a
            role="button"
            className={cx('navbar-burger burger', { 'is-active': isActive })}
            onClick={toggle}
            aria-label="menu"
            aria-expanded={isActive}
          >
            <span aria-hidden="true" />
            <span aria-hidden="true" />
            <span aria-hidden="true" />
          </a>
        </div>

        <div className={cx('navbar-menu', { 'is-active': isActive })}>
          <div className="navbar-start">
            {signedIn && (
              <>
                <NavLink exact to="/people">
                  People
                </NavLink>

                <NavLink exact to="/courses">
                  Part-Time
                </NavLink>

                <div className="navbar-item has-dropdown is-hoverable">
                  <a className="navbar-link">Legacy</a>

                  <div className="navbar-dropdown">
                    <a className="navbar-item" href="/legacy/enrollments">
                      Enrollment
                    </a>
                    <a className="navbar-item" href="/legacy/apps">
                      Applications
                    </a>
                    <a
                      className="navbar-item"
                      href="/legacy/course_registrations"
                    >
                      Part-Time
                    </a>
                    <a className="navbar-item" href="/legacy/people">
                      People
                    </a>
                    <hr className="navbar-divider" />
                    <a className="navbar-item" href="/legacy/cohorts">
                      Cohorts
                    </a>
                  </div>
                </div>
              </>
            )}
          </div>

          <div className="navbar-end">
            <div className="navbar-item">
              <div className="buttons">
                {signedIn ? (
                  <a className="button is-light" href={staticRoutes.signOut}>
                    Sign Out
                  </a>
                ) : (
                  <a className="button is-primary" href={staticRoutes.signIn}>
                    <strong>Sign In</strong>
                  </a>
                )}
              </div>
            </div>
          </div>
        </div>
      </Container>
    </nav>
  )
}
