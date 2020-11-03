<script>
  import { fly } from 'svelte/transition'
  import { notifications } from '../stores.js'
  import notificationChannel from '../channels/notification-channel'
  import Icon from '../components/Icon'

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
    <div
      transition:fly={{ y: '-100', duration: 300 }}
      class="max-w-sm w-full mb-4 bg-white shadow-lg rounded-lg pointer-events-auto cursor-pointer"
      on:click={() => acknowledge(notification)}>
      <div class="rounded-lg shadow-xs overflow-hidden">
        <div class="p-4">
          <div class="flex items-start">
            <div class="flex-shrink-0 text-green-400">
              <Icon name="exclamation-circle" />
            </div>
            <div class="ml-3 w-0 flex-1 pt-0.5">
              <p class="text-sm leading-5 font-medium text-gray-900">
                {notification.event.title}
              </p>
              <p class="mt-1 text-sm leading-5 text-gray-500">
                {notification.event.message}
              </p>
            </div>
            <div class="ml-4 flex-shrink-0 flex">
              <button
                class="inline-flex text-gray-400 focus:outline-none focus:text-gray-500 transition ease-in-out duration-150"
                on:click|stopPropagation={() => close(notification)}>
                <Icon name="times" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  {/each}
</div>
