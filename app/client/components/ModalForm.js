import React from 'react'
import cx from 'classnames'

export const ModalForm = ({
  active,
  children,
  title,
  onClose,
  onConfirm,
  confirmLabel,
}) => {
  return (
    <div className={cx('modal', { 'is-active': active })}>
      <div className="modal-background" />
      <div className="modal-card">
        <form
          onSubmit={e => {
            e.preventDefault()
            onConfirm()
          }}
        >
          <header className="modal-card-head">
            <p className="modal-card-title">{title}</p>
            <button className="delete" aria-label="close" onClick={onClose} />
          </header>
          <section className="modal-card-body">{children}</section>
          <footer className="modal-card-foot">
            <button className="button is-success" type="submit">
              {confirmLabel || 'Submit'}
            </button>
            <button className="button" onClick={onClose} type="button">
              Cancel
            </button>
          </footer>
        </form>
      </div>
    </div>
  )
}
