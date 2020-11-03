<script>
  import { onMount } from 'svelte'
  import { get } from '../../utils/api-fetch'
  import Spinner from '../Spinner'
  import Summary from './Summary'

  export let selectedConversationId
  let conversationSummaries = []

  onMount(async () => {
    const {
      data: { people },
    } = await get(`/communications`)
    if (people) conversationSummaries = people
    selectedConversationId = people[0].id
  })
</script>

<div class="absolute inset-0 flex flex-col border-gray-300 border-r">
  <header
    class="p-4 border-gray-200 border-b bg-white"
    on:click={() => (selectedConversationId = null)}>
    <h1 class="text-lg font-semibold text-gray-900 font-serif italic">Inbox</h1>
  </header>
  {#if conversationSummaries.length > 0}
    <ul
      on:click|self={() => (selectedConversationId = null)}
      class="flex-1 overflow-y-auto">
      {#each conversationSummaries as { id, personName, subject, summary, time, isUnread, lastSender } (id)}
        <Summary
          onClick={() => (selectedConversationId = id)}
          isSelected={id === selectedConversationId}
          {personName}
          {subject}
          {summary}
          {time}
          {isUnread}
          {lastSender} />
      {/each}
    </ul>
  {:else}
    <Spinner />
  {/if}
</div>
