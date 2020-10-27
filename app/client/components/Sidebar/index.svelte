<script>
  import icon from '../../../assets/images/icon.svg'
  import Item from './Item'
</script>

<div class="flex-1 flex flex-col pt-5 pb-4 overflow-y-auto">
  <div class="flex items-center flex-shrink-0 px-4">
    <img class="h-8 w-auto" src={icon} alt="Suncoast Developers Guild" />
    <h3 class="ml-2 text-gray-200 font-semibold font-serif italic text-xl">
      Gateway
    </h3>
  </div>
  <nav class="mt-5 flex-1 px-2 bg-gray-800 space-y-1">
    <Item icon="home" title="Dashboard" path="/" />
    <!-- <Item icon="user-friends" title="People" path="/people" /> -->
    <Item icon="inbox" title="Messages" path="/messages" active count={42} />
  </nav>
</div>
