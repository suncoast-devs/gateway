<script>
  import { onMount } from 'svelte'
  import { fly } from 'svelte/transition'
  import Icon from '../components/Icon'
  import alertSound from '../../assets/sounds/ponderous.ogg'
  export let onAcknowledge
  export let onClose

  export let title
  export let message

  onMount(() => {
    const audio = new Audio(alertSound)
    audio.play()
  })
</script>

<div
  transition:fly={{ y: '-100', duration: 300 }}
  class="max-w-sm w-full mb-4 bg-white shadow-lg rounded-lg pointer-events-auto cursor-pointer"
  on:click={onAcknowledge}>
  <div class="rounded-lg shadow-xs overflow-hidden">
    <div class="p-4">
      <div class="flex items-start">
        <div class="flex-shrink-0 text-green-400">
          <Icon name="exclamation-circle" />
        </div>
        <div class="ml-3 w-0 flex-1 pt-0.5">
          <p class="text-sm leading-5 font-medium text-gray-900">{title}</p>
          <p class="mt-1 text-sm leading-5 text-gray-500">{message}</p>
        </div>
        <div class="ml-4 flex-shrink-0 flex">
          <button
            class="inline-flex text-gray-400 focus:outline-none focus:text-gray-500 transition ease-in-out duration-150"
            on:click|stopPropagation={onClose}>
            <Icon name="times" />
          </button>
        </div>
      </div>
    </div>
  </div>
</div>
