<script>
  import { fade, fly } from 'svelte/transition'
  import Icon from './Icon'
  import Notifications from './Notifications'
  import Sidebar from './Sidebar'

  let sidebarOpen = false
</script>

<div class="h-screen flex overflow-hidden bg-gray-100">
  {#if sidebarOpen}
    <!-- Mobile Sidebar -->
    <div class="md:hidden">
      <div class="fixed inset-0 flex z-30">
        <div transition:fade={{ duration: 300 }} class="fixed inset-0">
          <div class="absolute inset-0 bg-gray-600 opacity-75" />
        </div>
        <div
          transition:fly={{ x: '-100', duration: 300 }}
          class="relative flex-1 flex flex-col max-w-xs w-full bg-gray-800">
          <!-- Close Button -->
          <div class="absolute top-0 right-0 -mr-14 p-1">
            <button
              class="flex items-center justify-center h-12 w-12 rounded-full focus:outline-none focus:bg-gray-600"
              aria-label="Close sidebar"
              on:click={() => (sidebarOpen = false)}>
              <Icon name="times" large />
            </button>
          </div>
          <Sidebar />
        </div>
      </div>
    </div>
  {/if}
  <!-- Fixed Sidebar -->
  <div class="hidden md:flex md:flex-shrink-0">
    <div class="flex flex-col w-48">
      <div class="flex flex-col h-0 flex-1 bg-gray-800">
        <Sidebar />
      </div>
    </div>
  </div>
  <div class="flex flex-col w-0 flex-1">
    <!-- Top Bar -->
    <div
      class="relative z-10 flex-shrink-0 flex h-16 bg-white border-b border-gray-200">
      <!-- Hamburger Menu Button -->
      <button
        class="px-4 w-16 border-r border-gray-200 text-gray-500 focus:outline-none focus:bg-gray-100 focus:text-gray-600 md:hidden"
        aria-label="Open sidebar"
        on:click={() => (sidebarOpen = !sidebarOpen)}>
        <Icon name="bars" large />
      </button>
      <!-- Search -->
      <div class="flex-1 flex justify-between px-4 sm:px-6 lg:px-8">
        <!-- <div class="flex-1 flex">
          <form class="w-full flex :ml-0" action="#" method="GET">
            <label for="search_field" class="sr-only">Search</label>
            <div
              class="relative w-full text-gray-400 focus-within:text-gray-600">
              <div
                class="absolute inset-y-0 left-0 flex items-center pointer-events-none">
                <Icon name="search" />
              </div>
              <input
                id="search_field"
                class="block w-full h-full pl-8 pr-3 py-2 rounded-md text-gray-900 placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 sm:text-sm"
                placeholder="Search"
                type="search" />
            </div>
          </form>
        </div> -->
      </div>
      <!-- End Search -->
    </div>
    <!-- Layout Content -->
    <div class="flex-1">
      <slot />
    </div>
  </div>
</div>
<Notifications />
