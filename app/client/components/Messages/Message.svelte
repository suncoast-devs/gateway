<script>
  import formatTime from '../../utils/format-time'

  export let time
  export let subject = null
  export let body
  export let media
  export let isOwn = false

  const smsStyle = 'bg-green-100 border-green-200 text-green-900'
  const emailStyle = 'bg-blue-100 border-blue-200 text-blue-900'
  const isOwnStyle = 'justify-self-end flex-row-reverse'
</script>

<div class={`mb-2 flex items-center ${isOwn && isOwnStyle}`}>
  <div
    class={`px-3 py-2 w-8/12 border  rounded-md ${media === 'sms' ? smsStyle : emailStyle}`}>
    {#if subject}
      <h4 class="font-semibold text-sm">{subject}</h4>
    {/if}
    {@html body}
  </div>
  <time class="mx-2 text-xs text-gray-400">{formatTime(time)}</time>
</div>
