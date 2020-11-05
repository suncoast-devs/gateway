import consumer from './consumer'
import { unreadMessageCount, communications } from '../stores'

export default consumer.subscriptions.create('CommunicationChannel', {
  received(data) {
    if (data.unread) {
      unreadMessageCount.set(data.unread)
    } else if (data.id) {
      communications.update((c) => [data, ...c])
    }
  },

  // follow({ id: 1 }) -- Person id
  follow(data) {
    this.perform('follow', data)
  },

  unfollow() {
    this.perform('unfollow')
  },

  // markAsRead(communication.id)
  markAsRead(id) {
    this.perform('mark_as_read', { id })
  },
})
