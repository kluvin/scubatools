<script lang="ts">
  import NextUp from '../lib/components/NextUp.svelte'; // Adjusted path
</script>

<svelte:head>
  <title>Scuba Tools - Neste Dykketurer</title>
  <meta name="description" content="Oversikt over kommende dykketurer" />
</svelte:head>

<div class="">
    <NextUp />
</div>

<style lang="postcss">
  :global(body) {
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  }
</style> 