import consumer from './consumer'
import { notifications } from '../stores'

const DISPLAY_TIME = 10

// FIXME: Move timeout and remove logic to store?
export default consumer.subscriptions.create('NotificationChannel', {
  received(notification) {
    notifications.update((n) => [...n, notification])
    setTimeout(() => this.remove(notification), DISPLAY_TIME * 1000)
  },

  remove({ id }) {
    notifications.update((n) => n.filter((n) => n.id !== id))
  },

  acknowledge({ id }) {
    this.remove({ id })
    this.perform('acknowledge', { id })
  },
})
