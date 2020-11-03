<script>
  import { afterUpdate, onDestroy } from 'svelte'
  import { get } from '../../utils/api-fetch'
  import communicationChannel from '../../channels/communication-channel'
  import { communications } from '../../stores'
  import Spinner from '../Spinner'
  import Message from './Message'

  export let personId = null

  // FIXME: Move some of this to a store?
  export let lastSubject

  let person = null
  let lastPersonId
  let recentMessageId
  let scrollPane

  afterUpdate(() => {
    if (personId !== lastPersonId) {
      if (personId) {
        lastPersonId = personId
        communicationChannel.follow({ id: personId })
        loadMessages()
      } else {
        communicationChannel.unfollow()
      }
    }
  })

  onDestroy(() => {
    communicationChannel.unfollow()
  })

  async function loadMessages() {
    const data = await get('/communications', { person_id: personId })
    if (data.person) {
      person = data.person
      $communications = data.communications
      if ($communications.length > 0) {
        const mostRecentMessageId = $communications[0].id
        if (recentMessageId !== mostRecentMessageId) {
          recentMessageId = mostRecentMessageId
          setTimeout(scrollToBottom, 0)
        }

        // Set default subject in Compose view to last received email's subject
        const lastIncomingEmail = $communications.find(
          (m) => m.media === 'email' && !m.isOutgoing
        )
        if (lastIncomingEmail) lastSubject = lastIncomingEmail.subject
      }
    }
  }

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
          {#each $communications as communication (communication.id)}
            <Message {...communication} />
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
