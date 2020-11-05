<script>
  import { onMount } from 'svelte'
  import { fade } from 'svelte/transition'
  import { debounce } from 'lodash'
  import { get } from '../../utils/api-fetch'
  import { unreadMessageCount } from '../../stores'
  import Icon from '../Icon.svelte'
  import Spinner from '../Spinner'
  import Summary from './Summary'

  export let selectedConversation
  let conversationSummaries = []
  let query = ''
  let isLoading = true

  async function loadPeople() {
    isLoading = true
    const {
      data: { people },
    } = await get(`/communications`, { q: query })
    if (people) conversationSummaries = people
    isLoading = false
  }

  function reset() {
    query = ''
    loadPeople()
  }

  unreadMessageCount.subscribe(() => {
    loadPeople()
  })

  onMount(loadPeople)
</script>

<div class="absolute inset-0 flex flex-col border-gray-300 border-r">
  <header
    class="px-4 py-3 border-gray-200 border-b bg-white"
    on:click={() => (selectedConversation = null)}>
    <div class="flex items-center justify-between">
      <h1 class="pr-4 text-lg font-semibold text-gray-900 font-serif italic">
        Inbox
      </h1>
      <div class="relative">
        <div
          class="pointer-events-none absolute inset-y-0 left-0 pl-3 flex items-center">
          <Icon name="search" />
        </div>
        <input
          class="block w-full bg-white border border-gray-300 rounded-md py-2 px-10 leading-5 placeholder-gray-500 focus:outline-none focus:text-gray-900 focus:placeholder-gray-400 focus:border-blue-300 focus:shadow-outline-blue text-sm transition duration-150 ease-in-out"
          placeholder="Search"
          bind:value={query}
          on:input={debounce(loadPeople, 500, { maxWait: 2000 })}
          type="search" />
        {#if query.length > 0}
          <button
            on:click={reset}
            transition:fade={{ duration: 300 }}
            class="absolute inset-y-0 right-0 pr-3 flex items-center transition duration-300 ease-in-out text-gray-500">
            <Icon name="times-circle" />
          </button>
        {/if}
      </div>
    </div>
  </header>
  {#if isLoading}
    <Spinner />
  {:else if conversationSummaries.length > 0}
    <ul
      on:click|self={() => (selectedConversation = null)}
      class="flex-1 overflow-y-auto">
      {#each conversationSummaries as { id, name, email, subject, summary, time, isUnread, lastSender } (id)}
        <Summary
          onClick={() => (selectedConversation = { id, name, email })}
          isSelected={selectedConversation && id === selectedConversation.id}
          {name}
          {subject}
          {summary}
          {time}
          {isUnread}
          {lastSender} />
      {/each}
    </ul>
  {:else}{/if}
</div>
