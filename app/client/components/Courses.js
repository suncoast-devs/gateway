import React, { useReducer, useRef } from 'react'
import Icon from 'react-fontawesome'
import { Course } from '../models'
import { useModelData } from '../hooks'
import { Container, ModalForm, Section } from '.'

const initializeState = () => ({
  modalActive: false,
  newCourse: new Course({
    identifier: '',
    name: '',
    session: '',
    startsOn: new Date().toISOString().slice(0, 10),
    endsOn: new Date().toISOString().slice(0, 10),
    days: '',
    time: '',
  }),
})

const reducer = (state, { type, field, value }) => {
  switch (type) {
    case 'SHOW_MODAL':
      return { ...state, modalActive: true }
    case 'HIDE_MODAL':
      return { ...state, modalActive: false }
    case 'UPDATE':
      // NOTE: Mutating state here is a bad practice; a better solution is TBD.
      state.newCourse[field] = value
      return { ...state, newCourse: state.newCourse }
    case 'RESET':
      return initializeState()
    default:
      break
  }
}

export const Courses = () => {
  const { loading, data: courses, reload } = useModelData(() => Course.all())
  const [state, dispatch] = useReducer(reducer, {}, initializeState)

  const createCourse = () => {
    state.newCourse.save().then(success => {
      if (success) {
        dispatch({ type: 'RESET' })
        reload()
      } else {
        console.log(state.newCourse.errors)
      }
    })
  }

  return (
    <Section>
      <Container>
        <h1 className="title">Courses</h1>

        <nav className="level">
          <div className="level-left" />
          <div className="level-right">
            <div className="level-item">
              <button
                className="button"
                onClick={() => dispatch({ type: 'SHOW_MODAL' })}
              >
                <span className="icon">
                  <Icon name="plus" />
                </span>
                <span>Course</span>
              </button>
            </div>
          </div>
        </nav>

        <table className="table is-bordered is-hoverable is-fullwidth">
          <thead>
            <tr>
              <th>Name</th>
              <th>ID</th>
              <th>Session</th>
              <th>Start</th>
              <th>End</th>
              <th>Days</th>
              <th>Time</th>
            </tr>
          </thead>
          <tbody>
            {courses.map(course => (
              <tr key={course.id}>
                <td>{course.name}</td>
                <td>
                  <span className="tag">{course.identifier}</span>
                </td>
                <td>{course.session}</td>
                <td>{course.startsOn}</td>
                <td>{course.endsOn}</td>
                <td>{course.days}</td>
                <td>{course.time}</td>
              </tr>
            ))}
          </tbody>
        </table>
        <ModalForm
          title="New Course"
          active={state.modalActive}
          onClose={() => dispatch({ type: 'HIDE_MODAL' })}
          onConfirm={() => createCourse(state.newCourse)}
        >
          <>
            <InputField
              label="ID"
              value={state.newCourse.identifier}
              placeholder="wdtd"
              onChange={value =>
                dispatch({
                  type: 'UPDATE',
                  field: 'identifier',
                  value,
                })
              }
            />
            <InputField
              label="Name"
              value={state.newCourse.name}
              onChange={value =>
                dispatch({
                  type: 'UPDATE',
                  field: 'name',
                  value,
                })
              }
            />
            <InputField
              label="Session"
              value={state.newCourse.session}
              onChange={value =>
                dispatch({
                  type: 'UPDATE',
                  field: 'session',
                  value,
                })
              }
            />
            <InputField
              label="Starts On"
              value={state.newCourse.startsOn}
              type="date"
              onChange={value =>
                dispatch({
                  type: 'UPDATE',
                  field: 'startsOn',
                  value,
                })
              }
            />
            <InputField
              label="Ends On"
              value={state.newCourse.endsOn}
              type="date"
              onChange={value =>
                dispatch({
                  type: 'UPDATE',
                  field: 'endsOn',
                  value,
                })
              }
            />
            <InputField
              label="Days"
              value={state.newCourse.days}
              onChange={value =>
                dispatch({
                  type: 'UPDATE',
                  field: 'days',
                  value,
                })
              }
            />
            <InputField
              label="Time"
              value={state.newCourse.time}
              onChange={value =>
                dispatch({
                  type: 'UPDATE',
                  field: 'time',
                  value,
                })
              }
            />
          </>
        </ModalForm>
      </Container>
    </Section>
  )
}

const InputField = ({ label, value, placeholder, type = 'text', onChange }) => {
  const inputElement = useRef(null)
  return (
    <div className="field is-horizontal">
      <div className="field-label is-normal">
        <label className="label">{label}</label>
      </div>
      <div className="field-body">
        <div className="field">
          <div className="control">
            <input
              className="input"
              type={type}
              placeholder={placeholder}
              ref={inputElement}
              value={value}
              onChange={e => onChange(inputElement.current.value)}
            />
          </div>
        </div>
      </div>
    </div>
  )
}
