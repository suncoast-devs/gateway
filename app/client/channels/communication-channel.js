import consumer from './consumer'
import { unreadMessageCount } from '../stores'

export default consumer.subscriptions.create('CommunicationChannel', {
  received(data) {
    unreadMessageCount.set(data.unread)
  },
})
