<script>
  import Inbox from '../components/Messages/Inbox'
  import Thread from '../components/Messages/Thread'
  import Compose from '../components/Messages/Compose'
  let selectedConversationId = null
  let lastSubject = null
</script>

<div class="h-full flex">
  <div class="relative flex-1">
    <Inbox bind:selectedConversationId />
  </div>
  <div class="flex flex-col w-3/5">
    <div class="flex-1 relative">
      <Thread personId={selectedConversationId} bind:lastSubject />
    </div>
    {#if selectedConversationId}
      <Compose personId={selectedConversationId} {lastSubject} />
    {/if}
  </div>
</div>
