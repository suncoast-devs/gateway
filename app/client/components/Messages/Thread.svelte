<script>
  import { afterUpdate, onDestroy } from 'svelte'
  import { getPages } from '../../utils/api-fetch'
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
  let nextPage

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
    const { data, next } = await getPages('/communications', {
      person_id: personId,
    })
    if (data.person) {
      nextPage = next
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

  let messageList

  async function loadMore(event) {
    const currentLastItem = messageList.querySelector('li:last-child')

    if (nextPage) {
      const { data, next } = await getPages(nextPage)
      $communications = [...$communications, ...data.communications]
      nextPage = next
      setTimeout(() => {
        currentLastItem.previousElementSibling.scrollIntoView({
          block: 'end',
          behavior: 'smooth',
        })
      }, 0)
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
        {#if nextPage}
          <div class="flex flex-col items-center">
            <button
              class="inline-flex items-center max-w-sm px-2.5 py-1.5 border border-transparent text-xs leading-4 font-medium rounded text-white bg-gray-300 hover:bg-gray-200 focus:outline-none focus:border-gray-300 focus:shadow-outline-gray active:bg-gray-300 transition ease-in-out duration-150 "
              on:click={loadMore}>Load More&hellip;</button>
          </div>
        {/if}
        <ul bind:this={messageList} class="flex flex-col-reverse py-1">
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
