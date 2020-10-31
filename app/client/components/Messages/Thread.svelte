<script>
  import { afterUpdate } from 'svelte'
  import { get } from '../../utils/api-fetch'
  import Spinner from '../Spinner'
  import Message from './Message'

  export let personId = null
  let person = null
  let lastPersonId
  let messages = []
  let lastMostRecentMessageId
  let scrollPane

  afterUpdate(async () => {
    if (personId && personId !== lastPersonId) {
      const data = await get('/communications', { person_id: personId })
      if (data.person) {
        person = data.person
        messages = data.communications
        if (messages.length > 0) {
          const mostRecentMessageId = messages[0].id
          if (lastMostRecentMessageId !== mostRecentMessageId) {
            lastMostRecentMessageId = mostRecentMessageId
            setTimeout(scrollToBottom, 0)
          }
        }
      }
      lastPersonId = personId
    }
  })

  function scrollToBottom() {
    scrollPane.scroll({
      top: scrollPane.scrollHeight,
      behavior: 'smooth',
    })
  }
</script>

<div
  class="absolute inset-0 overflow-y-auto overflow-x-hidden flex flex-col"
  bind:this={scrollPane}>
  {#if personId}
    {#if person}
      <div class="flex flex-col">
        <h3
          class="py-2 pb-8 font-serif text-center italic sticky top-0 bg-gradient-to-b from-gray-100 via-gray-100 to-transparent text-gray-600">
          Conversation with
          <strong>{person.name}</strong>
        </h3>
        <ul class="flex flex-col-reverse py-1">
          {#each messages as message}
            <Message {...message} />
          {/each}
        </ul>
      </div>
    {:else}
      <Spinner />
    {/if}
  {:else}
    <div class="flex-1 flex items-center justify-center font-serif italic">
      No conversation selected.
    </div>
  {/if}
</div>
