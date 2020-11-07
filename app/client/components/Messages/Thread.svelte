<script>
  import { afterUpdate, onDestroy } from 'svelte'
  import { getPages } from '../../utils/api-fetch'
  import communicationChannel from '../../channels/communication-channel'
  import { communications } from '../../stores'
  import SlidePanel from '../SlidePanel'
  import Icon from '../Icon'
  import Spinner from '../Spinner'
  import Message from './Message'

  // FIXME: Move some of this to a store?
  export let lastSubject

  export let person
  let lastPersonId
  let recentMessageId
  let scrollPane
  let nextPage

  let selectedMessageDetail

  afterUpdate(() => {
    if (person && person.id !== lastPersonId) {
      if (person.id) {
        lastPersonId = person.id
        communicationChannel.follow({ id: person.id })
        loadMessages()
      } else {
        communicationChannel.unfollow()
      }
    }

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
  })

  onDestroy(() => {
    communicationChannel.unfollow()
  })

  async function loadMessages() {
    const { data, next } = await getPages('/communications', {
      person_id: person.id,
    })
    if (data.person) {
      nextPage = next
      person = data.person
      $communications = data.communications
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
  {#if person}
    {#if person.id}
      <div class="flex flex-col">
        <h3
          class="py-2 pb-8 font-serif text-center italic sticky top-0 bg-gradient-to-b from-gray-100 via-gray-100 to-transparent text-gray-600 z-20">
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
            <Message
              {...communication}
              onClick={() => (selectedMessageDetail = communication)} />
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

{#if selectedMessageDetail}
  <SlidePanel
    title={selectedMessageDetail.subject}
    onClose={() => (selectedMessageDetail = null)}>
    <div class="absolute inset-0 flex flex-col px-4">
      <div class="flex-1">
        <iframe
          src={`/communications/${selectedMessageDetail.id}`}
          title={selectedMessageDetail.subject}
          class="w-full h-full"
          frameborder="0" />
      </div>

      <div class="border-t border-gray-200">
        <nav class="flex -mb-px">
          <button
            class="group inline-flex items-center pt-4 px-1 border-b-2 border-transparent font-medium text-sm leading-5 text-gray-500 hover:text-gray-700 hover:border-gray-300 focus:outline-none focus:text-gray-700 focus:border-gray-300">
            <span
              class="-ml-0.5 mr-2 h-5 w-5 text-gray-400 group-hover:text-gray-500 group-focus:text-gray-600">
              <Icon name="envelope-open-text" />
            </span>
            <span>Full Email</span>
          </button>
          <button
            class="ml-8 group inline-flex items-center pt-4 px-1 border-b-2 border-transparent font-medium text-sm leading-5 text-gray-500 hover:text-gray-700 hover:border-gray-300 focus:outline-none focus:text-gray-700 focus:border-gray-300">
            <span
              class="-ml-0.5 mr-2 h-5 w-5 text-gray-400 group-hover:text-gray-500 group-focus:text-gray-600">
              <Icon name="code" />
            </span>
            <span>RAW</span>
          </button>
        </nav>
      </div>
    </div>
  </SlidePanel>
{/if}
