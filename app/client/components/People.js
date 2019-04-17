import React, { useReducer } from 'react'
import cx from 'classnames'
import { Container, Section } from '.'
import Icon from 'react-fontawesome'

const initialState = {
  loading: true,
}

const FilterField = ({ value = '', options = {}, icon, onChange, onClear }) => {
  const hasValue = value.length > 0
  return (
    <div className="field has-addons">
      <div className="control has-icons-left">
        <div className="select">
          <select name="stage" id="stage" value={value} onChange={onChange}>
            <option value="" label=" " />
            {Object.keys(options).map(key => (
              <option value={key} key={key}>
                {options[key]}
              </option>
            ))}
          </select>
        </div>
        <div className="icon is-small is-left">
          <Icon name={icon} />
        </div>
      </div>
      <div className="control">
        <button
          className={cx('button', { 'is-info': hasValue })}
          onClick={onClear}
        >
          <Icon name={hasValue ? 'times' : 'filter'} />
        </button>
      </div>
    </div>
  )
}

export const People = () => {
  return (
    <Section>
      <Container>
        <h1 className="title">People</h1>
        <nav className="level">
          <div className="level-left">
            <div className="level-item">
              <div className="field has-addons">
                <div className="control">
                  <input
                    type="text"
                    name="query"
                    id="query"
                    placeholder="Search People"
                    className="input"
                  />
                </div>
              </div>
            </div>
            <div className="level-item">
              <FilterField
                icon="users"
                options={{ aaa: 'AAA', bbb: 'BBB' }}
                value={'aaa'}
                onChange={e => setCohort(e.target.value)}
                onClear={() => setCohort('')}
              />
            </div>
            <div className="level-item">
              <FilterField icon="tasks" />
            </div>
            <div className="level-item">
              <FilterField icon="flag" />
            </div>
          </div>
        </nav>
        <table className="table is-bordered is-striped is-fullwidth">
          <thead>
            <tr>
              <th>Name</th>
              <th>Stage</th>
              <th>Status</th>
              <th>Cohort</th>
              <th className="has-text-centered">
                <span className="icon">
                  <i className="fas fa-stopwatch" />
                </span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <a href="/legacy/people/1">Jason Perry</a>
              </td>
              <td>
                <span className="tag is-warning">Applied</span>
              </td>
              <td>
                <span className="tag is-info">Active</span>
              </td>
              <td />
              <td className="has-text-centered">
                <time datetime="2019-03-18T15:30:13Z">27 days</time>
              </td>
            </tr>
          </tbody>
        </table>
        <nav
          className="pagy-bulma-nav pagination is-centered"
          role="navigation"
          aria-label="pagination"
        >
          <a className="pagination-previous" disabled="">
            ‹&nbsp;Prev
          </a>
          <a className="pagination-next" disabled="">
            Next&nbsp;›
          </a>
          <ul className="pagination-list">
            <li>
              <a
                href="/legacy/enrollments?page=1"
                className="pagination-link is-current"
                aria-label="page 1"
                aria-current="page"
              >
                1
              </a>
            </li>
          </ul>
        </nav>
      </Container>
    </Section>
  )
}
