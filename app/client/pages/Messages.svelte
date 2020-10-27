<script>
  import Main from '../components/Main'
  import Summary from '../components/Messages/Summary'
  import Thread from '../components/Messages/Thread'

  let selectedConversationId = 1

  const conversationSummaries = [
    {
      id: 1,
      personName: 'Joe Student',
      summary: 'Hey',
      time: '2020-10-28T13:22:39.972Z',
      isUnread: true,
      lastSender: 'Joe',
    },
    {
      id: 2,
      personName: 'Karen Maga',
      subject: 'This is an email so it has a subject',
      summary: "Why does this program cost so much if you're a nonprofit?",
      time: '2020-10-26T09:22:39.972Z',
      isUnread: false,
      lastSender: 'Karen',
    },
    {
      id: 3,
      personName: 'Ideal Candidate',
      subject: null,
      summary: 'I will send deposit today, thanks.',
      time: '2020-10-24T10:12:18.972Z',
      isUnread: true,
      lastSender: 'Ideal',
    },
  ]
</script>

<div class="flex flex-1">
  <Main>
    <!-- Page Header -->
    <header class="p-4 border-gray-200 border-b bg-white">
      <h1 class="text-lg font-semibold text-gray-900 font-serif italic">
        Messages
      </h1>
    </header>
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
