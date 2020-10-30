<script>
  import { onMount } from 'svelte'
  import Main from '../components/Main'
  import Summary from '../components/Messages/Summary'
  import Thread from '../components/Messages/Thread'
  import Spinner from '../components/Spinner'

  let selectedConversationId
  let conversationSummaries = []

  onMount(async () => {
    const response = await fetch(`/communications`)
    conversationSummaries = (await response.json()).people
  })
</script>

<div class="flex flex-1">
  <Main>
    <!-- Page Header -->
    <header class="p-4 border-gray-200 border-b bg-white">
      <h1 class="text-lg font-semibold text-gray-900 font-serif italic">
        Messages
      </h1>
    </header>
    {#if conversationSummaries.length > 0}
      <ul on:click|self={() => (selectedConversationId = null)} class="flex-1">
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
  </Main>
  <div
    class="flex flex-col bg-gray-50 border-l border-gray-200 w-3/5 max-w-3xl overflow-hidden">
    {#if selectedConversationId}
      <Thread personId={selectedConversationId} />
    {:else}
      <div class="flex-1 flex items-center justify-center font-serif italic">
        No conversation selected.
      </div>
    {/if}
  </div>
</div>

<!-- Status Bar -->
<!-- <div class="px-4 py-2 bg-white">
  <p class="italic text-gray-500 text-sm">Sending message&hellip;</p>
</div> -->
