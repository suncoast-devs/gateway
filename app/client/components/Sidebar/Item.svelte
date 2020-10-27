<script>
  import Icon from '../Icon'

  export let active
  export let count = 0
  export let icon
  export let path
  export let title

  const inactiveClasses =
    'text-gray-300 hover:text-white hover:bg-gray-700 focus:text-white focus:bg-gray-700'
  const activeClasses = 'text-white bg-gray-900  focus:bg-gray-700'
</script>

<a
  href={path}
  class={`group flex items-center px-2 py-2 text-sm leading-5 font-medium rounded-md  focus:outline-none transition ease-in-out duration-150 ${active ? activeClasses : inactiveClasses}`}>
  <div
    class="mr-2 text-gray-300 group-hover:text-gray-300 group-focus:text-gray-300 transition ease-in-out duration-150">
    <Icon name={icon} />
  </div>
  {title}
  {#if count > 0}
    <span
      class={`ml-auto inline-block py-0.5 px-3 text-xs leading-4 font-medium rounded-full transition ease-in-out duration-150 group-hover:bg-gray-800 group-focus:bg-gray-800 ${active ? 'bg-gray-700' : 'bg-gray-900'}`}>
      {count}
    </span>
  {/if}
</a>
