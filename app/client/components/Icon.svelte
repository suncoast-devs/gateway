<script>
  export let name
  export let large
  export let small

  $: classNames = ['fad', `fa-${name}`].join(' ')
</script>

<i class:fa-lg={large} class:fa-sm={small} class={classNames} />
