<script>
  import { onMount, onDestroy } from 'svelte'
  import formatTime from '../../utils/format-time'
  import communicationChannel from '../../channels/communication-channel'

  const UNREAD_WAIT = 5

  export let id
  export let time
  export let subject = null
  export let body
  export let media
  export let isUnread
  export let isOutgoing = false

  export let onClick

  const smsStyle = 'bg-green-100 border-green-200 text-green-900'
  const emailStyle = 'bg-blue-100 border-blue-200 text-blue-900'
  const isOwnStyle = 'justify-self-end flex-row-reverse opacity-75'

  let timeout

  onMount(() => {
    if (isUnread) {
      timeout = setTimeout(() => {
        communicationChannel.markAsRead(id)
      }, UNREAD_WAIT)
    }
  })

  onDestroy(() => clearTimeout(timeout))
</script>

<li
  class={`mx-2 my-1 flex items-center ${isOutgoing && isOwnStyle}`}
  on:click={onClick}>
  <div
    class={`px-3 py-2 w-8/12 border overflow-x-hidden rounded-md ${media === 'sms' ? smsStyle : emailStyle}`}>
    {#if subject}
      <h4 class="font-semibold text-sm">{subject}</h4>
    {/if}
    {@html body}
  </div>
  <time class="mx-2 text-xs text-gray-400">{formatTime(time)}</time>
</li>
