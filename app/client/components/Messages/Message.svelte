<script>
  import formatTime from '../../utils/format-time'

  export let time
  export let subject = null
  export let body
  export let media
  export let isOwn = false

  const smsStyle = 'bg-green-100 border-green-300 text-green-900'
  const emailStyle = 'bg-blue-100 border-blue-300 text-blue-900'
  const isOwnStyle = 'justify-self-end flex-row-reverse'
</script>

<div class={`mb-2 flex items-center ${isOwn && isOwnStyle}`}>
  <div
    class={`p-2 w-8/12 border  rounded-md ${media === 'sms' ? smsStyle : emailStyle}`}>
    {#if subject}
      <h4 class="font-semibold">{subject}</h4>
    {/if}
    {@html body}
  </div>
  <time class="mx-2 text-xs text-gray-400">{formatTime(time)}</time>
</div>
