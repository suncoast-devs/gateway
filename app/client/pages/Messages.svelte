<script>
  import Inbox from '../components/Messages/Inbox'
  import Thread from '../components/Messages/Thread'
  import Compose from '../components/Messages/Compose'
  let selectedConversation
  let lastSubject
</script>

<div class="h-full flex">
  <div class="relative flex-1">
    <Inbox bind:selectedConversation />
  </div>
  <div class="flex flex-col w-3/5">
    <div class="flex-1 relative">
      <Thread person={selectedConversation} bind:lastSubject />
    </div>
    {#if selectedConversation}
      <Compose person={selectedConversation} {lastSubject} />
    {/if}
  </div>
</div>
