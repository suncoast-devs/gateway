<script>
  import formatTime from '../../utils/format-time'
  import Icon from '../../components/Icon'

  export let name
  export let subject
  export let summary
  export let time
  export let isUnread
  export let lastSender

  export let onClick
  export let isSelected = false

  $: formattedTime = formatTime(time)

  const selectedStyles = 'bg-purple-100 border-purple-200'
  const unselectedStyles = 'hover:bg-white border-gray-200'
</script>

<li
  on:click={onClick}
  class={`px-4 py-2 border-b hover:shadow-lg overflow-x-hidden cursor-pointer ${isSelected ? selectedStyles : unselectedStyles}`}>
  <div class="flex items-center">
    {#if isUnread}
      <div class="text-purple-500 mr-2">
        <Icon name="circle" small />
      </div>
    {/if}
    <h3 class="flex-1 font-bold">{name}</h3>
    {#if time}<time class="text-xs">{formattedTime}</time>{/if}
  </div>
  {#if subject}
    <h4 class="font-semibold text-sm text-gray-600">{subject}</h4>
  {/if}
  {#if summary}
    <p class="font-serif">
      <em>{lastSender} said:</em>
      {@html summary}
    </p>
  {/if}
</li>
