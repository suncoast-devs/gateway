<script>
  import { fade, fly } from 'svelte/transition'
  import Icon from './Icon'

  export let title
  export let onClose
</script>

<div class="fixed inset-0 overflow-hidden z-50">
  <div class="absolute inset-0 overflow-hidden">
    <div
      transition:fade
      class="absolute inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
      on:click={onClose} />

    <section class="absolute inset-y-0 right-0 pl-10 max-w-full flex">
      <div
        class="w-screen max-w-4xl"
        transition:fly={{ x: 300, duration: 300 }}>
        <div
          class="h-full flex flex-col space-y-6 py-4 bg-white shadow-xl overflow-y-auto">
          <header class="px-4">
            <div class="flex items-start justify-between space-x-3">
              <h2 class="text-lg leading-7 font-medium text-gray-900">
                {title}
              </h2>
              <div class="h-7 flex items-center">
                <button
                  on:click={onClose}
                  aria-label="Close panel"
                  class="text-gray-400 hover:text-gray-500 transition ease-in-out duration-150">
                  <Icon name="times-circle" />
                </button>
              </div>
            </div>
          </header>
          <div class="relative flex-1 px-4">
            <slot />
          </div>
        </div>
      </div>
    </section>
  </div>
</div>
