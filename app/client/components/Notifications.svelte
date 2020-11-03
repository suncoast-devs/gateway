<script>
  import { notifications } from '../stores.js'
  import notificationChannel from '../channels/notification-channel'
  import Notification from './Notification'

  function acknowledge(notification) {
    notificationChannel.acknowledge(notification)
  }

  function close(notification) {
    notificationChannel.remove(notification)
  }
</script>

<div
  class="fixed inset-0 flex flex-col items-end justify-start p-4 pointer-events-none z-50">
  {#each $notifications as notification (notification.id)}
    <Notification
      {...notification.event}
      onAcknowledge={() => acknowledge(notification)}
      onClose={() => close(notification)} />
  {/each}
</div>
