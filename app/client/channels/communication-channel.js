import consumer from './consumer'
import { unreadMessageCount, communications } from '../stores'

export default consumer.subscriptions.create('CommunicationChannel', {
  received(data) {
    if (data.unread) {
      unreadMessageCount.set(data.unread)
    } else {
      console.log({ data })
      communications.update((c) => [data, ...c])
    }
  },

  follow(data) {
    this.perform('follow', data)
  },

  unfollow() {
    this.perform('unfollow')
  },
})
